# otp_server.py — Zhinflim OTP backend (sends a 4-digit code to Gmail)
# ---------------------------------------------------------------------------
# This is the small server the Flutter app talks to so the OTP arrives in the
# user's real email inbox. A phone app alone cannot send email securely.
#
# SETUP (one time):
#   1) pip install fastapi "uvicorn[standard]"
#   2) Turn on 2-Step Verification for your Gmail account.
#   3) Create an "App Password":  Google Account → Security → App passwords.
#      (It is a 16-character password, e.g. "abcd efgh ijkl mnop")
#   4) Put your Gmail + that app password below, OR set them as env vars:
#         export GMAIL_ADDRESS="you@gmail.com"
#         export GMAIL_APP_PASSWORD="abcdefghijklmnop"
#
# RUN:
#   uvicorn otp_server:app --host 0.0.0.0 --port 8000
#
# THEN in the Flutter app (main.dart) set:
#   const String kApiBase = 'http://10.0.2.2:8000';   // Android emulator
#   // real phone on same Wi-Fi: use your PC's IP, e.g. 'http://192.168.1.20:8000'
# ---------------------------------------------------------------------------

import os
import time
import random
import smtplib
from email.message import EmailMessage

from fastapi import FastAPI
from pydantic import BaseModel

GMAIL_ADDRESS = os.environ.get("GMAIL_ADDRESS", "youremail@gmail.com")
GMAIL_APP_PASSWORD = os.environ.get("GMAIL_APP_PASSWORD", "your16charapppassword")
CODE_TTL_SECONDS = 300  # the code is valid for 5 minutes

app = FastAPI(title="Zhinflim OTP")

# email (lowercased) -> (code, expires_at). In-memory; fine for one server.
_codes: dict[str, tuple[str, float]] = {}


class EmailIn(BaseModel):
    email: str


class VerifyIn(BaseModel):
    email: str
    code: str


def _send_email(to_addr: str, code: str) -> None:
    msg = EmailMessage()
    msg["Subject"] = "Zhinflim — your verification code"
    msg["From"] = f"Zhinflim <{GMAIL_ADDRESS}>"
    msg["To"] = to_addr
    msg.set_content(
        f"Your Zhinflim verification code is: {code}\n\n"
        f"This code expires in 5 minutes.\n"
        f"If you did not request it, you can ignore this email."
    )
    # Nice gold/black HTML version (falls back to plain text above).
    msg.add_alternative(
        f"""
        <div style="background:#0d0d0d;padding:32px;font-family:Arial,Helvetica,sans-serif">
          <div style="max-width:420px;margin:auto;background:#141008;border:1px solid #3a2e14;
                      border-radius:16px;padding:28px;text-align:center;color:#f3dc8e">
            <h1 style="margin:0 0 8px;letter-spacing:1px">Zhinflim</h1>
            <p style="color:#cfc09a;margin:0 0 22px">Your verification code</p>
            <div style="font-size:38px;font-weight:800;letter-spacing:12px;color:#fff6d9">{code}</div>
            <p style="color:#8c7e5e;font-size:13px;margin:22px 0 0">Expires in 5 minutes.</p>
          </div>
        </div>
        """,
        subtype="html",
    )
    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(GMAIL_ADDRESS, GMAIL_APP_PASSWORD)
        server.send_message(msg)


@app.post("/send-otp")
def send_otp(body: EmailIn):
    email = body.email.strip().lower()
    code = f"{random.randint(0, 9999):04d}"  # always 4 digits
    _codes[email] = (code, time.time() + CODE_TTL_SECONDS)
    try:
        _send_email(body.email.strip(), code)
    except Exception as exc:  # surface SMTP problems clearly during setup
        return {"ok": False, "error": str(exc)}
    return {"ok": True}


@app.post("/verify-otp")
def verify_otp(body: VerifyIn):
    email = body.email.strip().lower()
    record = _codes.get(email)
    if not record:
        return {"ok": False, "reason": "no_code"}
    code, expires_at = record
    if time.time() > expires_at:
        _codes.pop(email, None)
        return {"ok": False, "reason": "expired"}
    if body.code.strip() != code:
        return {"ok": False, "reason": "mismatch"}
    _codes.pop(email, None)  # one-time use
    return {"ok": True}


@app.get("/")
def health():
    return {"service": "Zhinflim OTP", "status": "ok"}
