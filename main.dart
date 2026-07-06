import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ZhinflimApp());

// ===========================================================================
//  Zhinflim — Splash -> Login <-> Register -> Home.
//  3 languages (Kurdish / English / Arabic). Single file, ZERO packages.
// ===========================================================================

// ---- Brand palette ----
const Color kGoldDeep = Color(0xFF8A5E12);
const Color kGold = Color(0xFFC9962E);
const Color kGoldMid = Color(0xFFD9B24A);
const Color kGoldBright = Color(0xFFF3DC8E);
const Color kGoldHigh = Color(0xFFFFF6D9);
const Color kInkOnGold = Color(0xFF2A1E08); // dark text on gold surfaces

// App-wide selected language (shared across login & register).
final ValueNotifier<AppLang> appLang = ValueNotifier<AppLang>(AppLang.ckb);

class ZhinflimApp extends StatelessWidget {
  const ZhinflimApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zhinflim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SplashScreen(),
    );
  }
}

// ===========================================================================
//  LOCALIZATION  (Kurdish Sorani / English / Arabic)
// ===========================================================================
enum AppLang { ckb, en, ar }

class L10n {
  final TextDirection dir;
  final String welcome,
      subtitle,
      email,
      password,
      rememberMe,
      forgot,
      login,
      orWord,
      google,
      createAccount,
      joinToday,
      firstName,
      lastName,
      phone,
      confirmPassword,
      agreeTerms,
      register,
      noAccountPrompt,
      signUpLink,
      haveAccountPrompt,
      loginLink,
      enterEmail,
      otpTitle,
      otpSubtitle,
      verify,
      resend,
      resendIn,
      wrongCode,
      searchHint,
      trendingNow,
      popularMovies,
      seeAll,
      watchNow,
      navHome,
      navCollections,
      navAi,
      navList,
      navProfile,
      comingSoon,
      catTitle,
      catMovies,
      catSeries,
      catAnime,
      catAnimation,
      catManga,
      catComics,
      aiTitle,
      aiSubtitle,
      aiChip1,
      aiChip2,
      aiChip3,
      aiHint,
      aiGreeting,
      listsTitle,
      tabWatchlist,
      tabFavorites,
      tabHistory,
      hi,
      premiumMember,
      account,
      editProfile,
      changePassword,
      paymentHistory,
      devices,
      logout,
      settingsTitle,
      sLanguage,
      sNotifications,
      sDownloads,
      sSecurity,
      sParental,
      sPayment,
      sAbout,
      subTitle,
      subChoose,
      planMonth,
      planMonths,
      save,
      bestValue,
      payTitle,
      subscription,
      navSuggest,
      navTime,
      suggestTitle,
      suggestSubtitle,
      suggestNameHint,
      suggestNoteHint,
      suggestSend,
      suggestThanks,
      suggestType,
      timeTitle,
      timeSubtitle,
      timeNew,
      timeSoon,
      genresLabel,
      aiChip4,
      aiChip5,
      aiChip6,
      aiNewChat,
      aiCap;
  const L10n({
    required this.dir,
    required this.welcome,
    required this.subtitle,
    required this.email,
    required this.password,
    required this.rememberMe,
    required this.forgot,
    required this.login,
    required this.orWord,
    required this.google,
    required this.createAccount,
    required this.joinToday,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.confirmPassword,
    required this.agreeTerms,
    required this.register,
    required this.noAccountPrompt,
    required this.signUpLink,
    required this.haveAccountPrompt,
    required this.loginLink,
    required this.enterEmail,
    required this.otpTitle,
    required this.otpSubtitle,
    required this.verify,
    required this.resend,
    required this.resendIn,
    required this.wrongCode,
    required this.searchHint,
    required this.trendingNow,
    required this.popularMovies,
    required this.seeAll,
    required this.watchNow,
    required this.navHome,
    required this.navCollections,
    required this.navAi,
    required this.navList,
    required this.navProfile,
    required this.comingSoon,
    required this.catTitle,
    required this.catMovies,
    required this.catSeries,
    required this.catAnime,
    required this.catAnimation,
    required this.catManga,
    required this.catComics,
    required this.aiTitle,
    required this.aiSubtitle,
    required this.aiChip1,
    required this.aiChip2,
    required this.aiChip3,
    required this.aiHint,
    required this.aiGreeting,
    required this.listsTitle,
    required this.tabWatchlist,
    required this.tabFavorites,
    required this.tabHistory,
    required this.hi,
    required this.premiumMember,
    required this.account,
    required this.editProfile,
    required this.changePassword,
    required this.paymentHistory,
    required this.devices,
    required this.logout,
    required this.settingsTitle,
    required this.sLanguage,
    required this.sNotifications,
    required this.sDownloads,
    required this.sSecurity,
    required this.sParental,
    required this.sPayment,
    required this.sAbout,
    required this.subTitle,
    required this.subChoose,
    required this.planMonth,
    required this.planMonths,
    required this.save,
    required this.bestValue,
    required this.payTitle,
    required this.subscription,
    required this.navSuggest,
    required this.navTime,
    required this.suggestTitle,
    required this.suggestSubtitle,
    required this.suggestNameHint,
    required this.suggestNoteHint,
    required this.suggestSend,
    required this.suggestThanks,
    required this.suggestType,
    required this.timeTitle,
    required this.timeSubtitle,
    required this.timeNew,
    required this.timeSoon,
    required this.genresLabel,
    required this.aiChip4,
    required this.aiChip5,
    required this.aiChip6,
    required this.aiNewChat,
    required this.aiCap,
  });
}

const Map<AppLang, L10n> kStrings = {
  AppLang.ckb: L10n(
    dir: TextDirection.rtl,
    welcome: 'بەخێرهاتنەوە!',
    subtitle: 'بچۆ ژوورەوە بۆ بەردەوامبوونی گەشتەکەت',
    email: 'ئیمەیڵ',
    password: 'وشەی نهێنی',
    rememberMe: 'بیرم بکەرەوە',
    forgot: 'وشەی نهێنیت بیرچووە؟',
    login: 'چوونەژوورەوە',
    orWord: 'یان',
    google: 'بەردەوامبە بە گووگڵ',
    createAccount: 'دروستکردنی هەژمار',
    joinToday: 'ئەمڕۆ بەشداری Zhinflim بکە',
    firstName: 'ناوی یەکەم',
    lastName: 'ناوی کۆتایی',
    phone: 'ژمارەی مۆبایل',
    confirmPassword: 'دڵنیاکردنەوەی وشەی نهێنی',
    agreeTerms: 'ڕازیم بە مەرجەکان و تایبەتمەندی',
    register: 'تۆمارکردن',
    noAccountPrompt: 'هەژمارت نییە؟',
    signUpLink: 'تۆمار بکە',
    haveAccountPrompt: 'هەژمارت هەیە؟',
    loginLink: 'بچۆ ژوورەوە',
    enterEmail: 'تکایە ئیمەیڵەکەت بنووسە',
    otpTitle: 'پشتڕاستکردنەوە',
    otpSubtitle: 'کۆدی ٤ ڕەقەمیمان نارد بۆ',
    verify: 'پشتڕاستکردنەوە',
    resend: 'دووبارە ناردنەوەی کۆد',
    resendIn: 'دووبارە ناردن لە',
    wrongCode: 'کۆدەکە هەڵەیە',
    searchHint: 'بگەڕێ بە کوردی، عەرەبی یان ئینگلیزی',
    trendingNow: 'ترێندی ئێستا',
    popularMovies: 'فیلمە بەناوبانگەکان',
    seeAll: 'زیاتر',
    watchNow: 'ئێستا تەماشا بکە',
    navHome: 'سەرەکی',
    navCollections: 'کۆکراوەکان',
    navAi: 'زیرەکی',
    navList: 'لیستی من',
    navProfile: 'پرۆفایل',
    comingSoon: 'بەمزووانە',
    catTitle: 'بەشەکان',
    catMovies: 'فیلمەکان',
    catSeries: 'زنجیرە',
    catAnime: 'ئەنیمە',
    catAnimation: 'ئەنیمەیشن',
    catManga: 'مانگا',
    catComics: 'کۆمیک',
    aiTitle: 'زیرەکیی دەستکرد',
    aiSubtitle: 'یاریدەدەری زیرەکی و بەهێزی Zhinflim',
    aiChip1: 'باشترین فیلم و زنجیرە بۆ کوردی',
    aiChip2: 'ئەنیمە و مانگای نوێ بەپێی کۆمیدی',
    aiChip3: 'فیلمی نوێی ٢٠٢٤',
    aiHint: 'هەرچی دەتەوێ بپرسە...',
    aiGreeting: 'سڵاو! من زیرەکیی Zhinflim ـم. چ فیلم یان زنجیرەیەکت بۆ بدۆزمەوە؟',
    listsTitle: 'لیستەکانم',
    tabWatchlist: 'لیستی تەماشا',
    tabFavorites: 'دڵخوازەکان',
    tabHistory: 'مێژوو',
    hi: 'سڵاو',
    premiumMember: 'ئەندامی پاشایەتی',
    account: 'هەژمار و پرۆفایل',
    editProfile: 'دەستکاریی پرۆفایل',
    changePassword: 'گۆڕینی وشەی نهێنی',
    paymentHistory: 'مێژووی پارەدان',
    devices: 'ئامێرەکان',
    logout: 'چوونەدەرەوە',
    settingsTitle: 'ڕێکخستنەکان',
    sLanguage: 'زمانی ئەپ',
    sNotifications: 'ئاگادارکردنەوەکان',
    sDownloads: 'داگرتنەکان',
    sSecurity: 'ئاسایش',
    sParental: 'کۆنترۆڵی دایک و باوک',
    sPayment: 'شێوازی پارەدان',
    sAbout: 'دەربارەی Zhinflim',
    subTitle: 'پلانەکانی بەشداری',
    subChoose: 'باشترین پلان هەڵبژێرە',
    planMonth: 'مانگ',
    planMonths: 'مانگ',
    save: 'پاشەکەوت',
    bestValue: 'باشترین نرخ',
    payTitle: 'پارەدانی ڕاستەوخۆ',
    subscription: 'بەشداری',
    navSuggest: 'پێشنیار',
    navTime: 'کات',
    suggestTitle: 'پێشنیارکردنی ناوەڕۆک',
    suggestSubtitle: 'چ فیلم، زنجیرە یان ئەنیمەیەک دەتەوێ زیادی بکەین؟',
    suggestNameHint: 'ناوی ناوەڕۆک',
    suggestNoteHint: 'تێبینی (ئارەزوومەندانە)',
    suggestSend: 'ناردنی پێشنیار',
    suggestThanks: 'سوپاس! پێشنیارەکەت وەرگیرا.',
    suggestType: 'جۆر',
    timeTitle: 'خشتەی بڵاوکردنەوە',
    timeSubtitle: 'نوێترین و داهاتووەکان',
    timeNew: 'نوێ بڵاوکراوە',
    timeSoon: 'بەمزووانە',
    genresLabel: 'ژانەرەکان',
    aiChip4: 'فیلمێک بۆ شەوێکی هێمن',
    aiChip5: 'باشترین ئەنیمەی ٢٠٢٤',
    aiChip6: 'شتێکی هاوشێوەی Breaking Bad',
    aiNewChat: 'گفتوگۆی نوێ',
    aiCap: 'پێشنیار • گەڕان • بەراورد • ناساندن',
  ),
  AppLang.en: L10n(
    dir: TextDirection.ltr,
    welcome: 'Welcome Back!',
    subtitle: 'Login to continue your journey',
    email: 'Email',
    password: 'Password',
    rememberMe: 'Remember me',
    forgot: 'Forgot Password?',
    login: 'Login',
    orWord: 'OR',
    google: 'Continue with Google',
    createAccount: 'Create Account',
    joinToday: 'Join Zhinflim today',
    firstName: 'First Name',
    lastName: 'Last Name',
    phone: 'Phone Number',
    confirmPassword: 'Confirm Password',
    agreeTerms: 'I agree to Terms & Privacy',
    register: 'Register',
    noAccountPrompt: "Don't have an account?",
    signUpLink: 'Sign up',
    haveAccountPrompt: 'Already have an account?',
    loginLink: 'Login',
    enterEmail: 'Please enter your email',
    otpTitle: 'Verification',
    otpSubtitle: 'We sent a 4-digit code to',
    verify: 'Verify',
    resend: 'Resend code',
    resendIn: 'Resend in',
    wrongCode: 'Incorrect code',
    searchHint: 'Search in Kurdish, Arabic or English',
    trendingNow: 'Trending Now',
    popularMovies: 'Popular Movies',
    seeAll: 'See all',
    watchNow: 'Watch Now',
    navHome: 'Home',
    navCollections: 'Collections',
    navAi: 'AI',
    navList: 'My List',
    navProfile: 'Profile',
    comingSoon: 'Coming soon',
    catTitle: 'Categories',
    catMovies: 'Movies',
    catSeries: 'Series',
    catAnime: 'Anime',
    catAnimation: 'Animation',
    catManga: 'Manga',
    catComics: 'Comics',
    aiTitle: 'AI Assistant',
    aiSubtitle: 'Your ultra-smart movie assistant',
    aiChip1: 'Best movies & series for Kurdish',
    aiChip2: 'New anime & manga by comedy',
    aiChip3: 'New movies 2024',
    aiHint: 'Ask anything...',
    aiGreeting: "Hi! I'm Zhinflim AI. Which movie or series can I find for you?",
    listsTitle: 'My Lists',
    tabWatchlist: 'Watchlist',
    tabFavorites: 'Favorites',
    tabHistory: 'History',
    hi: 'Hi',
    premiumMember: 'Premium Member',
    account: 'Account & Profile',
    editProfile: 'Edit Profile',
    changePassword: 'Change Password',
    paymentHistory: 'Payment History',
    devices: 'Devices',
    logout: 'Logout',
    settingsTitle: 'Settings',
    sLanguage: 'App Language',
    sNotifications: 'Notifications',
    sDownloads: 'Downloads',
    sSecurity: 'Security',
    sParental: 'Parental Control',
    sPayment: 'Payment Methods',
    sAbout: 'About Zhinflim',
    subTitle: 'Subscription Plans',
    subChoose: 'Choose the best plan for you',
    planMonth: 'Month',
    planMonths: 'Months',
    save: 'Save',
    bestValue: 'BEST VALUE',
    payTitle: 'Direct Payments',
    subscription: 'Subscription',
    navSuggest: 'Suggest',
    navTime: 'Timeline',
    suggestTitle: 'Suggest Content',
    suggestSubtitle: 'What movie, series or anime should we add?',
    suggestNameHint: 'Content name',
    suggestNoteHint: 'Note (optional)',
    suggestSend: 'Send Suggestion',
    suggestThanks: 'Thanks! Your suggestion was received.',
    suggestType: 'Type',
    timeTitle: 'Release Schedule',
    timeSubtitle: 'Latest & upcoming',
    timeNew: 'Just Released',
    timeSoon: 'Coming Soon',
    genresLabel: 'Genres',
    aiChip4: 'A movie for a chill night',
    aiChip5: 'Best anime of 2024',
    aiChip6: 'Something like Breaking Bad',
    aiNewChat: 'New chat',
    aiCap: 'Recommend • Search • Compare • Explain',
  ),
  AppLang.ar: L10n(
    dir: TextDirection.rtl,
    welcome: 'مرحباً بعودتك!',
    subtitle: 'سجّل الدخول لمتابعة رحلتك',
    email: 'البريد الإلكتروني',
    password: 'كلمة المرور',
    rememberMe: 'تذكّرني',
    forgot: 'هل نسيت كلمة المرور؟',
    login: 'تسجيل الدخول',
    orWord: 'أو',
    google: 'المتابعة عبر Google',
    createAccount: 'إنشاء حساب',
    joinToday: 'انضم إلى Zhinflim اليوم',
    firstName: 'الاسم الأول',
    lastName: 'اسم العائلة',
    phone: 'رقم الهاتف',
    confirmPassword: 'تأكيد كلمة المرور',
    agreeTerms: 'أوافق على الشروط والخصوصية',
    register: 'تسجيل',
    noAccountPrompt: 'ليس لديك حساب؟',
    signUpLink: 'سجّل الآن',
    haveAccountPrompt: 'لديك حساب؟',
    loginLink: 'تسجيل الدخول',
    enterEmail: 'يرجى إدخال بريدك الإلكتروني',
    otpTitle: 'التحقق',
    otpSubtitle: 'أرسلنا رمزاً من 4 أرقام إلى',
    verify: 'تحقّق',
    resend: 'إعادة إرسال الرمز',
    resendIn: 'إعادة الإرسال خلال',
    wrongCode: 'الرمز غير صحيح',
    searchHint: 'ابحث بالكردية أو العربية أو الإنجليزية',
    trendingNow: 'الأكثر رواجاً',
    popularMovies: 'أفلام شائعة',
    seeAll: 'المزيد',
    watchNow: 'شاهد الآن',
    navHome: 'الرئيسية',
    navCollections: 'المجموعات',
    navAi: 'ذكاء',
    navList: 'قائمتي',
    navProfile: 'الملف',
    comingSoon: 'قريباً',
    catTitle: 'الفئات',
    catMovies: 'أفلام',
    catSeries: 'مسلسلات',
    catAnime: 'أنمي',
    catAnimation: 'رسوم متحركة',
    catManga: 'مانغا',
    catComics: 'كومكس',
    aiTitle: 'الذكاء الاصطناعي',
    aiSubtitle: 'مساعدك الذكي للأفلام',
    aiChip1: 'أفضل الأفلام والمسلسلات بالكردية',
    aiChip2: 'أنمي ومانغا جديدة حسب الكوميديا',
    aiChip3: 'أفلام جديدة 2024',
    aiHint: 'اسأل أي شيء...',
    aiGreeting: 'مرحباً! أنا Zhinflim AI. أي فيلم أو مسلسل أجد لك؟',
    listsTitle: 'قوائمي',
    tabWatchlist: 'قائمة المشاهدة',
    tabFavorites: 'المفضلة',
    tabHistory: 'السجل',
    hi: 'مرحباً',
    premiumMember: 'عضو مميّز',
    account: 'الحساب والملف',
    editProfile: 'تعديل الملف',
    changePassword: 'تغيير كلمة المرور',
    paymentHistory: 'سجل المدفوعات',
    devices: 'الأجهزة',
    logout: 'تسجيل الخروج',
    settingsTitle: 'الإعدادات',
    sLanguage: 'لغة التطبيق',
    sNotifications: 'الإشعارات',
    sDownloads: 'التنزيلات',
    sSecurity: 'الأمان',
    sParental: 'الرقابة الأبوية',
    sPayment: 'طرق الدفع',
    sAbout: 'حول Zhinflim',
    subTitle: 'خطط الاشتراك',
    subChoose: 'اختر أفضل خطة لك',
    planMonth: 'شهر',
    planMonths: 'أشهر',
    save: 'وفّر',
    bestValue: 'أفضل قيمة',
    payTitle: 'دفع مباشر',
    subscription: 'الاشتراك',
    navSuggest: 'اقتراح',
    navTime: 'الجدول',
    suggestTitle: 'اقتراح محتوى',
    suggestSubtitle: 'أي فيلم أو مسلسل أو أنمي تريد أن نضيفه؟',
    suggestNameHint: 'اسم المحتوى',
    suggestNoteHint: 'ملاحظة (اختياري)',
    suggestSend: 'إرسال الاقتراح',
    suggestThanks: 'شكراً! تم استلام اقتراحك.',
    suggestType: 'النوع',
    timeTitle: 'جدول الإصدارات',
    timeSubtitle: 'الأحدث والقادمة',
    timeNew: 'صدر حديثاً',
    timeSoon: 'قريباً',
    genresLabel: 'التصنيفات',
    aiChip4: 'فيلم لليلة هادئة',
    aiChip5: 'أفضل أنمي 2024',
    aiChip6: 'شيء مثل Breaking Bad',
    aiNewChat: 'محادثة جديدة',
    aiCap: 'توصية • بحث • مقارنة • شرح',
  ),
};

// ===========================================================================
//  GENRES  (100+ genres, each in Kurdish / English / Arabic)
// ===========================================================================
class Genre {
  final String en, ckb, ar;
  const Genre(this.en, this.ckb, this.ar);
  String label(AppLang l) =>
      l == AppLang.ckb ? ckb : (l == AppLang.ar ? ar : en);
}

const List<Genre> kGenres = [
  Genre('All', 'هەموو', 'الكل'),
  Genre('Action', 'ئاکشن', 'أكشن'),
  Genre('Adventure', 'سەرکێشی', 'مغامرة'),
  Genre('Comedy', 'کۆمیدی', 'كوميديا'),
  Genre('Drama', 'درама', 'دراما'),
  Genre('Romance', 'ڕۆمانسی', 'رومانسي'),
  Genre('Thriller', 'هەستبزوێن', 'إثارة'),
  Genre('Horror', 'ترسناک', 'رعب'),
  Genre('Mystery', 'نهێنی', 'غموض'),
  Genre('Crime', 'تاوان', 'جريمة'),
  Genre('Sci-Fi', 'زانستی خەیاڵی', 'خيال علمي'),
  Genre('Fantasy', 'خەیاڵی', 'فانتازيا'),
  Genre('Animation', 'ئەنیمەیشن', 'رسوم متحركة'),
  Genre('Documentary', 'دۆکیۆمێنتاری', 'وثائقي'),
  Genre('Family', 'خێزانی', 'عائلي'),
  Genre('Musical', 'مۆزیکی', 'موسيقي'),
  Genre('War', 'جەنگ', 'حرب'),
  Genre('Western', 'وێستەرن', 'غربي'),
  Genre('Historical', 'مێژوویی', 'تاريخي'),
  Genre('Biography', 'ژیاننامە', 'سيرة ذاتية'),
  Genre('Sport', 'وەرزشی', 'رياضة'),
  Genre('Superhero', 'پاڵەوانی سوپەر', 'بطل خارق'),
  Genre('Cyberpunk', 'سایبەرپەنک', 'سايبربانك'),
  Genre('Post-Apocalyptic', 'دوای قیامەت', 'ما بعد الكارثة'),
  Genre('Dystopian', 'دیستۆپیا', 'ديستوبيا'),
  Genre('Space Opera', 'ئۆپێرای بۆشایی', 'أوبرا فضائية'),
  Genre('Time Travel', 'گەشتی کات', 'السفر عبر الزمن'),
  Genre('Alien', 'بیانیی زەمینی', 'كائنات فضائية'),
  Genre('Robot', 'ڕۆبۆت', 'روبوت'),
  Genre('Mecha', 'میکا', 'ميكا'),
  Genre('Zombie', 'زۆمبی', 'زومبي'),
  Genre('Vampire', 'خوێنمژ', 'مصاص دماء'),
  Genre('Werewolf', 'گورگە‌مرۆڤ', 'مستذئب'),
  Genre('Ghost', 'تارمایی', 'أشباح'),
  Genre('Supernatural', 'سەرووسروشتی', 'خارق للطبيعة'),
  Genre('Psychological', 'دەروونی', 'نفسي'),
  Genre('Noir', 'نوار', 'نوار'),
  Genre('Neo-Noir', 'نیۆ-نوار', 'نيو نوار'),
  Genre('Slasher', 'سلاشەر', 'سلاشر'),
  Genre('Survival', 'ڕزگاربوون', 'البقاء'),
  Genre('Disaster', 'کارەسات', 'كوارث'),
  Genre('Heist', 'دزیی گەورە', 'سرقة كبرى'),
  Genre('Spy', 'سیخوڕی', 'تجسس'),
  Genre('Political', 'سیاسی', 'سياسي'),
  Genre('Legal', 'یاسایی', 'قانوني'),
  Genre('Medical', 'پزیشکی', 'طبي'),
  Genre('Detective', 'پۆلیسی', 'بوليسي'),
  Genre('Courtroom', 'دادگا', 'قاعة المحكمة'),
  Genre('Prison', 'زیندان', 'سجن'),
  Genre('Martial Arts', 'وەرزشی جەنگی', 'فنون قتالية'),
  Genre('Kung Fu', 'کۆنگ فۆ', 'كونغ فو'),
  Genre('Samurai', 'سامۆرای', 'ساموراي'),
  Genre('Ninja', 'نینجا', 'نينجا'),
  Genre('Gangster', 'گانگستەر', 'عصابات'),
  Genre('Mafia', 'مافیا', 'مافيا'),
  Genre('Epic', 'ئێپیک', 'ملحمي'),
  Genre('Sword & Sorcery', 'شمشێر و جادوو', 'سيف وسحر'),
  Genre('High Fantasy', 'خەیاڵیی بەرز', 'فانتازيا عالية'),
  Genre('Dark Fantasy', 'خەیاڵیی تاریک', 'فانتازيا مظلمة'),
  Genre('Urban Fantasy', 'خەیاڵیی شاری', 'فانتازيا حضرية'),
  Genre('Fairy Tale', 'چیرۆکی ئەفسانەیی', 'حكاية خرافية'),
  Genre('Mythology', 'ئەفسانەناسی', 'أساطير'),
  Genre('Folklore', 'فۆلکلۆر', 'فولكلور'),
  Genre('Steampunk', 'ستیمپەنک', 'ستيمبانك'),
  Genre('Military', 'سەربازی', 'عسكري'),
  Genre('Rom-Com', 'کۆمیدیی ڕۆمانسی', 'كوميديا رومانسية'),
  Genre('Dark Comedy', 'کۆمیدیی تاریک', 'كوميديا سوداء'),
  Genre('Satire', 'گاڵتەجاڕی', 'هجاء'),
  Genre('Parody', 'لاسایی', 'محاكاة ساخرة'),
  Genre('Slapstick', 'کۆمیدیی جەستەیی', 'كوميديا هزلية'),
  Genre('Mockumentary', 'دۆکیۆمێنتاریی گاڵتە', 'وثائقي ساخر'),
  Genre('Coming of Age', 'گەورەبوون', 'سن البلوغ'),
  Genre('Teen', 'هەرزەکاران', 'مراهقون'),
  Genre('Kids', 'منداڵان', 'أطفال'),
  Genre('Preschool', 'پێش‌قوتابخانە', 'ما قبل المدرسة'),
  Genre('Educational', 'پەروەردەیی', 'تعليمي'),
  Genre('Anthology', 'کۆکراوە', 'مجموعة قصص'),
  Genre('Miniseries', 'زنجیرەی کورت', 'مسلسل قصير'),
  Genre('Sitcom', 'کۆمیدیی دۆخی', 'كوميديا موقفية'),
  Genre('Soap Opera', 'ئۆپێرای سابوون', 'مسلسل درامي'),
  Genre('Reality', 'ڕاستەقینە', 'واقع'),
  Genre('Game Show', 'یاریی پیشاندان', 'برنامج مسابقات'),
  Genre('Talk Show', 'بەرنامەی گفتوگۆ', 'برنامج حواري'),
  Genre('Variety', 'جۆراوجۆر', 'منوعات'),
  Genre('Stand-up', 'ستاندئەپ', 'ستاند أب'),
  Genre('Concert', 'کۆنسێرت', 'حفل موسيقي'),
  Genre('Dance', 'سەما', 'رقص'),
  Genre('Experimental', 'ئەزموونی', 'تجريبي'),
  Genre('Art House', 'هونەری', 'سينما فنية'),
  Genre('Indie', 'سەربەخۆ', 'مستقل'),
  Genre('Cult', 'کالت', 'كالت'),
  Genre('Silent', 'بێدەنگ', 'صامت'),
  Genre('Melodrama', 'مێلۆدراما', 'ميلودراما'),
  Genre('Tragedy', 'تراژیدی', 'مأساة'),
  Genre('Tragicomedy', 'تراژیکۆمیدی', 'كوميديا مأساوية'),
  Genre('Feel-Good', 'دڵخۆشکەر', 'مبهج'),
  Genre('Inspirational', 'هاندەر', 'ملهم'),
  Genre('Holiday', 'جەژنی', 'أعياد'),
  Genre('Nature', 'سروشت', 'طبيعة'),
  Genre('Travel', 'گەشتیاری', 'سفر'),
  Genre('Cooking', 'چێشتلێنان', 'طبخ'),
  Genre('Shonen', 'شۆنێن', 'شونين'),
  Genre('Shojo', 'شۆجۆ', 'شوجو'),
  Genre('Seinen', 'سەینێن', 'سينين'),
  Genre('Josei', 'جۆسەی', 'جوسي'),
  Genre('Isekai', 'ئیسێکای', 'إيسيكاي'),
  Genre('Slice of Life', 'پارچەیەک لە ژیان', 'شريحة من الحياة'),
  Genre('Magical Girl', 'کچی جادوویی', 'فتاة سحرية'),
  Genre('School', 'قوتابخانە', 'مدرسي'),
  Genre('Space', 'بۆشایی', 'فضاء'),
  Genre('Post-War', 'دوای جەنگ', 'ما بعد الحرب'),
  Genre('Heroic', 'پاڵەوانی', 'بطولي'),
  Genre('Adventure Comedy', 'کۆمیدیی سەرکێشی', 'كوميديا مغامرة'),
  Genre('Techno-Thriller', 'هەستبزوێنی تەکنەلۆژی', 'إثارة تقنية'),
  Genre('Whodunit', 'کێ کردی', 'من الفاعل'),
];

// ===========================================================================
//  OTP SERVICE
//  Set kApiBase to your backend URL (see otp_server.py) to send REAL emails.
//  Leave it '' for DEMO mode: the code is generated locally and shown on
//  screen so you can test the whole flow without a backend.
// ===========================================================================
const String kApiBase = ''; // e.g. 'http://10.0.2.2:8000' (Android emulator)

class OtpService {
  static String? _demoCode;

  /// Returns the code (DEMO mode), '' if sent via backend, or null on failure.
  static Future<String?> sendOtp(String email) async {
    if (kApiBase.isEmpty) {
      _demoCode = (1000 + math.Random().nextInt(9000)).toString();
      return _demoCode;
    }
    try {
      final client = HttpClient();
      final req = await client.postUrl(Uri.parse('$kApiBase/send-otp'));
      req.headers.contentType = ContentType.json;
      req.add(utf8.encode(jsonEncode({'email': email})));
      final res = await req.close();
      await res.drain<void>();
      client.close();
      return res.statusCode == 200 ? '' : null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> verifyOtp(String email, String code) async {
    if (kApiBase.isEmpty) return code == _demoCode;
    try {
      final client = HttpClient();
      final req = await client.postUrl(Uri.parse('$kApiBase/verify-otp'));
      req.headers.contentType = ContentType.json;
      req.add(utf8.encode(jsonEncode({'email': email, 'code': code})));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      client.close();
      if (res.statusCode != 200) return false;
      final data = jsonDecode(body);
      return data is Map && data['ok'] == true;
    } catch (_) {
      return false;
    }
  }
}

// Validates the email, sends an OTP, then opens the verification screen.
Future<void> startEmailOtp(BuildContext context, L10n t, String email) async {
  final value = email.trim();
  if (value.isEmpty || !value.contains('@')) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.enterEmail)));
    return;
  }
  final result = await OtpService.sendOtp(value);
  if (!context.mounted) return;
  if (result == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not send the code — check kApiBase')),
    );
    return;
  }
  if (kApiBase.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('DEMO code: $result'),
        duration: const Duration(seconds: 6),
      ),
    );
  }
  Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => OtpScreen(email: value),
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  ));
}

// Clears the stack and lands on Home (used after login/register success).
void goHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => const HomeScreen(),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ),
    (route) => false,
  );
}

// ===========================================================================
//  SPLASH
// ===========================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _ring;
  late final Animation<double> _crown;
  late final Animation<double> _z;
  late final Animation<double> _zShine;
  late final Animation<double> _burst;
  late final Animation<double> _text;
  late final Animation<double> _textShine;
  late final Animation<double> _sub;
  late final Animation<double> _loader;
  late final Animation<double> _exit;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ));

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );

    Animation<double> seg(double a, double b, Curve curve) =>
        CurvedAnimation(parent: _c, curve: Interval(a, b, curve: curve));

    _ring = seg(0.06, 0.40, Curves.easeOutCubic);
    _crown = seg(0.18, 0.48, Curves.easeOutBack);
    _z = seg(0.30, 0.58, Curves.easeOutBack);
    _zShine = seg(0.50, 0.74, Curves.easeInOut);
    _burst = seg(0.52, 0.84, Curves.easeOut);
    _text = seg(0.60, 0.84, Curves.easeOutCubic);
    _textShine = seg(0.80, 1.00, Curves.easeInOut);
    _sub = seg(0.74, 0.92, Curves.easeOut);
    _loader = seg(0.30, 0.96, Curves.easeInOut);
    _exit = seg(0.94, 1.00, Curves.easeIn);

    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) _goLogin();
    });
    _c.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && MediaQuery.of(context).disableAnimations) _c.value = 1.0;
    });
  }

  void _goLogin() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (_, __, ___) => const LoginScreen(),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          return Opacity(
            opacity: (1 - _exit.value).clamp(0.0, 1.0),
            child: Stack(
              children: [
                const _Background(),
                Positioned.fill(
                  child: CustomPaint(painter: _SparksPainter(_c.value)),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 5),
                      _logoGroup(),
                      const SizedBox(height: 42),
                      _brand(),
                      const SizedBox(height: 14),
                      _subtitle(),
                      const Spacer(flex: 5),
                      _loaderBar(),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _logoGroup() {
    final pulse = 1 + 0.035 * math.sin(_burst.value * math.pi);
    return Transform.scale(
      scale: pulse,
      child: SizedBox(
        width: 300,
        height: 340,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _BurstPainter(_burst.value)),
            ),
            Align(
              alignment: const Alignment(0, 0.22),
              child: Opacity(
                opacity: _ring.value.clamp(0.0, 1.0),
                child: CustomPaint(
                  size: const Size(210, 210),
                  painter: _RingPainter(_ring.value),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.22),
              child: Opacity(
                opacity: _z.value.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.6 + 0.4 * _z.value,
                  child: CustomPaint(
                    size: const Size(94, 108),
                    painter: _ZPainter(_zShine.value),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.66),
              child: Opacity(
                opacity: _crown.value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, -44 * (1 - _crown.value)),
                  child: Transform.scale(
                    scale: 0.72 + 0.28 * _crown.value,
                    child: CustomPaint(
                      size: const Size(150, 104),
                      painter: _CrownPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _brand() {
    final p = _text.value.clamp(0.0, 1.0);
    return Transform.translate(
      offset: Offset(0, 16 * (1 - p)),
      child: Opacity(
        opacity: p,
        child: sheenSweep(
          _textShine.value,
          goldText('Zhinflim', 56, FontWeight.w800, 1.2),
        ),
      ),
    );
  }

  Widget _subtitle() {
    final p = _sub.value.clamp(0.0, 1.0);
    return Transform.translate(
      offset: Offset(0, 10 * (1 - p)),
      child: Opacity(
        opacity: p,
        child: Text(
          'Streaming & Media Platform',
          style: TextStyle(
            color: Colors.white.withOpacity(0.90),
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  Widget _loaderBar() {
    final p = _loader.value.clamp(0.0, 1.0);
    return Opacity(
      opacity: _ring.value.clamp(0.0, 1.0),
      child: SizedBox(
        width: 190,
        height: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: Colors.white.withOpacity(0.10)),
              ),
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: p,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kGoldDeep, kGold, kGoldBright],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
//  SHARED WIDGET HELPERS
// ===========================================================================
Widget goldText(String s, double size, FontWeight w, double spacing) {
  return ShaderMask(
    shaderCallback: (r) => const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [kGoldHigh, kGoldBright, kGoldMid, kGold, kGoldDeep],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    ).createShader(r),
    child: Text(
      s,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size,
        fontWeight: w,
        color: Colors.white,
        letterSpacing: spacing,
        shadows: [Shadow(color: kGold.withOpacity(0.45), blurRadius: 24)],
      ),
    ),
  );
}

Widget goldButton(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kGoldHigh, kGoldBright, kGold, kGoldMid],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kGold.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: kInkOnGold,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

Widget sheenSweep(double t, Widget child) {
  return ShaderMask(
    blendMode: BlendMode.srcATop,
    shaderCallback: (r) => LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.transparent,
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.85),
        Colors.white.withOpacity(0.0),
        Colors.transparent,
      ],
      stops: const [0.0, 0.42, 0.5, 0.58, 1.0],
      transform: _SlideGradient(t.clamp(0.0, 1.0) * 2 - 1),
    ).createShader(r),
    child: child,
  );
}

class _SlideGradient extends GradientTransform {
  final double dx;
  const _SlideGradient(this.dx);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * dx, 0.0, 0.0);
}

Widget miniEmblem() {
  return SizedBox(
    width: 96,
    height: 96,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: const Alignment(0, 0.25),
          child: CustomPaint(size: const Size(78, 78), painter: _RingPainter(1)),
        ),
        Align(
          alignment: const Alignment(0, 0.25),
          child: CustomPaint(size: const Size(34, 40), painter: _ZPainter(0)),
        ),
        Align(
          alignment: const Alignment(0, -0.66),
          child: CustomPaint(size: const Size(56, 38), painter: _CrownPainter()),
        ),
      ],
    ),
  );
}

// A small link row:  "prompt"  link
Widget linkRow(String prompt, String link, VoidCallback onTap) {
  return Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(prompt,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: Text(link,
              style: const TextStyle(
                  color: kGold, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

// ===========================================================================
//  LOGIN
// ===========================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  bool _remember = true;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _openRegister() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (_, __, ___) => const RegisterScreen(),
      transitionsBuilder: (_, a, __, c) {
        final slide = Tween(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(CurvedAnimation(parent: a, curve: Curves.easeOut));
        return FadeTransition(
            opacity: a, child: SlideTransition(position: slide, child: c));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _languageBar(lang),
                        const SizedBox(height: 26),
                        Center(child: miniEmblem()),
                        const SizedBox(height: 18),
                        Center(child: goldText(t.welcome, 30, FontWeight.w800, 0.5)),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            t.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.80),
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _emailField(t),
                        const SizedBox(height: 16),
                        _passwordField(t),
                        const SizedBox(height: 16),
                        _rememberRow(t),
                        const SizedBox(height: 24),
                        goldButton(t.login,
                            () => startEmailOtp(context, t, _emailCtrl.text)),
                        const SizedBox(height: 20),
                        _orDivider(t),
                        const SizedBox(height: 20),
                        _googleButton(t),
                        const SizedBox(height: 22),
                        linkRow(t.noAccountPrompt, t.signUpLink, _openRegister),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageBar(AppLang current) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          _langChip(current, AppLang.ckb, 'کوردی'),
          _langChip(current, AppLang.en, 'English'),
          _langChip(current, AppLang.ar, 'العربية'),
        ],
      ),
    );
  }

  Widget _langChip(AppLang current, AppLang lang, String label) {
    final selected = current == lang;
    return GestureDetector(
      onTap: () => appLang.value = lang,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: [kGold, kGoldBright])
              : null,
          color: selected ? null : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.transparent : kGold.withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kInkOnGold : kGoldBright,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _emailField(L10n t) {
    return _iconField(
      icon: Icons.mail_outline_rounded,
      label: t.email,
      child: TextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        textDirection: TextDirection.ltr,
        cursorColor: kGold,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: 'youremail@example.com',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 14),
        ),
      ),
    );
  }

  Widget _passwordField(L10n t) {
    return _iconField(
      icon: Icons.lock_outline_rounded,
      label: t.password,
      trailing: GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: kGold.withOpacity(0.85),
          size: 22,
        ),
      ),
      child: TextField(
        controller: _passCtrl,
        obscureText: _obscure,
        textDirection: TextDirection.ltr,
        cursorColor: kGold,
        style: const TextStyle(
            color: Colors.white, fontSize: 15, letterSpacing: 2),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: '••••••••',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        ),
      ),
    );
  }

  Widget _iconField({
    required IconData icon,
    required String label,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGold.withOpacity(0.30), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: kGold, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: kGoldBright,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  Widget _rememberRow(L10n t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() => _remember = !_remember),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _checkbox(_remember),
              const SizedBox(width: 8),
              Text(t.rememberMe,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 14)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(t.forgot,
              style: const TextStyle(
                  color: kGold, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _orDivider(L10n t) {
    return Row(
      children: [
        Expanded(
            child:
                Container(height: 1, color: Colors.white.withOpacity(0.15))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(t.orWord,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
            child:
                Container(height: 1, color: Colors.white.withOpacity(0.15))),
      ],
    );
  }

  Widget _googleButton(L10n t) {
    return GestureDetector(
      onTap: () => goHome(context),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kGold.withOpacity(0.30), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(size: const Size(22, 22), painter: _GoogleGPainter()),
            const SizedBox(width: 12),
            Text(t.google,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
//  REGISTER  (Create Account)
// ===========================================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agree = true;
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    _phone.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(t),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 6, 24, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _field(controller: _first, hint: t.firstName),
                              const SizedBox(height: 14),
                              _field(controller: _last, hint: t.lastName),
                              const SizedBox(height: 14),
                              _field(
                                controller: _email,
                                hint: t.email,
                                keyboard: TextInputType.emailAddress,
                                ltr: true,
                              ),
                              const SizedBox(height: 14),
                              _field(
                                controller: _phone,
                                label: t.phone,
                                hint: '+964 750 123 4567',
                                keyboard: TextInputType.phone,
                                ltr: true,
                              ),
                              const SizedBox(height: 14),
                              _field(
                                controller: _pass,
                                label: t.password,
                                hint: '••••••••',
                                obscure: _obscure1,
                                ltr: true,
                                eyeOn: _obscure1,
                                onEye: () =>
                                    setState(() => _obscure1 = !_obscure1),
                              ),
                              const SizedBox(height: 14),
                              _field(
                                controller: _confirm,
                                label: t.confirmPassword,
                                hint: '••••••••',
                                obscure: _obscure2,
                                ltr: true,
                                eyeOn: _obscure2,
                                onEye: () =>
                                    setState(() => _obscure2 = !_obscure2),
                              ),
                              const SizedBox(height: 18),
                              _agreeRow(t),
                              const SizedBox(height: 24),
                              goldButton(t.register,
                                  () => startEmailOtp(context, t, _email.text)),
                              const SizedBox(height: 18),
                              linkRow(t.haveAccountPrompt, t.loginLink,
                                  () => Navigator.of(context).pop()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header(L10n t) {
    final backIcon = t.dir == TextDirection.rtl
        ? Icons.arrow_forward_rounded
        : Icons.arrow_back_rounded;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Icon(backIcon, color: kGold, size: 26),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                goldText(t.createAccount, 26, FontWeight.w800, 0.3),
                const SizedBox(height: 2),
                Text(t.joinToday,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    String? label,
    bool obscure = false,
    bool ltr = false,
    TextInputType? keyboard,
    VoidCallback? onEye,
    bool eyeOn = true,
  }) {
    final input = TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      textDirection: ltr ? TextDirection.ltr : null,
      cursorColor: kGold,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hint,
        hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.40), fontSize: 15),
      ),
    );

    final core = label == null
        ? input
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: kGoldBright,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              input,
            ],
          );

    return Container(
      height: label == null ? 56 : null,
      padding: EdgeInsets.symmetric(
          horizontal: 18, vertical: label == null ? 0 : 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGold.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Expanded(child: core),
          if (onEye != null)
            GestureDetector(
              onTap: onEye,
              child: Icon(
                eyeOn
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: kGold.withOpacity(0.8),
                size: 22,
              ),
            ),
        ],
      ),
    );
  }

  Widget _agreeRow(L10n t) {
    return GestureDetector(
      onTap: () => setState(() => _agree = !_agree),
      child: Row(
        children: [
          _checkbox(_agree),
          const SizedBox(width: 10),
          Expanded(
            child: Text(t.agreeTerms,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85), fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

// Shared gold checkbox.
Widget _checkbox(bool on) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: on ? kGold : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: kGold.withOpacity(0.7), width: 1.5),
    ),
    child: on ? const Icon(Icons.check, size: 16, color: kInkOnGold) : null,
  );
}

// ===========================================================================
//  PAINTERS
// ===========================================================================
class _Background extends StatelessWidget {
  const _Background();
  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.12),
          radius: 1.1,
          colors: [Color(0xFF2C2214), Color(0xFF15110A), Color(0xFF000000)],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double t;
  _RingPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = 2 * math.pi * t;
    const start = -math.pi / 2;

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = kGold.withOpacity(0.30 * t)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [kGoldDeep, kGold, kGoldBright, kGold, kGoldDeep],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(rect);

    canvas.drawArc(rect, start, sweep, false, glow);
    canvas.drawArc(rect, start, sweep, false, ring);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.t != t;
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final bandTop = h * 0.60;

    final path = Path()
      ..moveTo(w * 0.04, bandTop)
      ..lineTo(w * 0.18, h * 0.18)
      ..lineTo(w * 0.34, h * 0.46)
      ..lineTo(w * 0.50, h * 0.02)
      ..lineTo(w * 0.66, h * 0.46)
      ..lineTo(w * 0.82, h * 0.18)
      ..lineTo(w * 0.96, bandTop)
      ..lineTo(w * 0.96, h * 0.98)
      ..lineTo(w * 0.04, h * 0.98)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = kGold.withOpacity(0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kGoldBright, kGoldMid, kGold, kGoldDeep],
          stops: [0.0, 0.4, 0.7, 1.0],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = kGoldDeep.withOpacity(0.6),
    );

    canvas.drawLine(
      Offset(w * 0.06, bandTop),
      Offset(w * 0.94, bandTop),
      Paint()
        ..color = kGoldDeep.withOpacity(0.5)
        ..strokeWidth = 1.4,
    );

    void jewel(Offset c, double r) {
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: const [Colors.white, kGoldBright, kGold],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(Rect.fromCircle(center: c, radius: r)),
      );
    }

    jewel(Offset(w * 0.50, h * 0.02), w * 0.055);
    jewel(Offset(w * 0.18, h * 0.18), w * 0.042);
    jewel(Offset(w * 0.82, h * 0.18), w * 0.042);
    for (var i = 0; i < 3; i++) {
      jewel(Offset(w * (0.32 + i * 0.18), h * 0.80), w * 0.028);
    }
  }

  @override
  bool shouldRepaint(covariant _CrownPainter old) => false;
}

class _ZPainter extends CustomPainter {
  final double shine;
  _ZPainter(this.shine);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final th = h * 0.24;
    final k = th * 1.3;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, th)
      ..lineTo(k, h - th)
      ..lineTo(w, h - th)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..lineTo(0, h - th)
      ..lineTo(w - k, th)
      ..lineTo(0, th)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = kGold.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGoldHigh, kGoldBright, kGold, kGoldDeep, kGold],
          stops: [0.0, 0.25, 0.55, 0.8, 1.0],
        ).createShader(Offset.zero & size),
    );

    if (shine > 0 && shine < 1) {
      canvas.save();
      canvas.clipPath(path);
      final bw = w * 0.6;
      final x = -bw + shine * (w + 2 * bw);
      final r = Rect.fromLTWH(x, 0, bw, h);
      canvas.drawRect(
        r,
        Paint()
          ..blendMode = BlendMode.plus
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.85),
              Colors.transparent,
            ],
            stops: const [0.35, 0.5, 0.65],
          ).createShader(r),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ZPainter old) => old.shine != shine;
}

class _BurstPainter extends CustomPainter {
  final double t;
  _BurstPainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    final center = size.center(Offset.zero);
    final intensity = math.sin(t * math.pi);
    final maxR = size.width * (0.45 + 0.55 * t);

    canvas.drawCircle(
      center,
      maxR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            kGoldBright.withOpacity(0.50 * intensity),
            kGold.withOpacity(0.20 * intensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxR)),
    );

    final ringR = size.width * 0.35 + t * size.width * 0.5;
    canvas.drawCircle(
      center,
      ringR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = kGoldBright.withOpacity(0.40 * (1 - t)),
    );
  }

  @override
  bool shouldRepaint(covariant _BurstPainter old) => old.t != t;
}

class _SparksPainter extends CustomPainter {
  final double t;
  _SparksPainter(this.t);
  static final math.Random _rnd = math.Random(7);
  static final List<_Spark> _sparks = List.generate(22, (_) => _Spark(_rnd));

  @override
  void paint(Canvas canvas, Size size) {
    final fade = (0.3 + 0.7 * t).clamp(0.0, 1.0);
    for (final s in _sparks) {
      var y = (s.y - t * s.speed) % 1.0;
      if (y < 0) y += 1.0;
      final yy = y * size.height;
      final xx =
          s.x * size.width + math.sin(t * 2 * math.pi * s.freq + s.phase) * 8;
      final tw = 0.4 +
          0.6 * ((math.sin(t * 2 * math.pi * s.twk + s.phase) + 1) / 2);
      canvas.drawCircle(
        Offset(xx, yy),
        s.r,
        Paint()
          ..color = kGoldBright.withOpacity(s.op * tw * fade)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparksPainter old) => old.t != t;
}

class _Spark {
  final double x, y, r, op, speed, freq, phase, twk;
  _Spark(math.Random rnd)
      : x = rnd.nextDouble(),
        y = rnd.nextDouble(),
        r = 0.6 + rnd.nextDouble() * 1.6,
        op = 0.25 + rnd.nextDouble() * 0.4,
        speed = 0.15 + rnd.nextDouble() * 0.4,
        freq = 0.5 + rnd.nextDouble() * 1.5,
        phase = rnd.nextDouble() * math.pi * 2,
        twk = 0.6 + rnd.nextDouble() * 1.8;
}

// Simplified four-colour Google "G".
class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width * 0.40;
    final sw = size.width * 0.20;
    final rect = Rect.fromCircle(center: c, radius: r);
    double rad(double deg) => deg * math.pi / 180;
    Paint arc(Color col) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..color = col
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, rad(-18), rad(78), false, arc(const Color(0xFF4285F4)));
    canvas.drawArc(rect, rad(62), rad(78), false, arc(const Color(0xFF34A853)));
    canvas.drawArc(rect, rad(140), rad(86), false, arc(const Color(0xFFFBBC05)));
    canvas.drawArc(rect, rad(226), rad(90), false, arc(const Color(0xFFEA4335)));

    final bar = Rect.fromLTWH(c.dx, c.dy - sw / 2, r, sw);
    canvas.drawRect(bar, Paint()..color = const Color(0xFF4285F4));
  }

  @override
  bool shouldRepaint(covariant _GoogleGPainter old) => false;
}

// ===========================================================================
//  OTP VERIFICATION
// ===========================================================================
class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _ctrls =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _seconds = 30;
  bool _verifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _nodes[0].requestFocus());
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code => _ctrls.map((c) => c.text).join();

  void _onChanged(int i, String v) {
    if (v.isNotEmpty && i < 3) _nodes[i + 1].requestFocus();
    if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
    setState(() => _error = null);
    if (_code.length == 4) FocusScope.of(context).unfocus();
  }

  Future<void> _verify(L10n t) async {
    if (_code.length < 4 || _verifying) return;
    setState(() {
      _verifying = true;
      _error = null;
    });
    final ok = await OtpService.verifyOtp(widget.email, _code);
    if (!mounted) return;
    setState(() => _verifying = false);
    if (ok) {
      goHome(context);
    } else {
      setState(() => _error = t.wrongCode);
    }
  }

  Future<void> _resend(L10n t) async {
    if (_seconds > 0) return;
    final r = await OtpService.sendOtp(widget.email);
    if (!mounted) return;
    _startCountdown();
    if (r != null && kApiBase.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('DEMO code: $r'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        final backIcon = t.dir == TextDirection.rtl
            ? Icons.arrow_forward_rounded
            : Icons.arrow_back_rounded;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(backIcon, color: kGold, size: 26),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Center(child: miniEmblem()),
                        const SizedBox(height: 18),
                        Center(
                            child:
                                goldText(t.otpTitle, 28, FontWeight.w800, 0.4)),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            t.otpSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            widget.email,
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                                color: kGoldBright,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                List.generate(4, (i) => _otpBox(i)),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Center(
                            child: Text(_error!,
                                style: const TextStyle(
                                    color: Color(0xFFE57373), fontSize: 14)),
                          ),
                        ],
                        const SizedBox(height: 28),
                        _verifyButton(t),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: _seconds == 0 ? () => _resend(t) : null,
                            child: Text(
                              _seconds == 0
                                  ? t.resend
                                  : '${t.resendIn} $_seconds',
                              style: TextStyle(
                                color: _seconds == 0
                                    ? kGold
                                    : Colors.white.withOpacity(0.5),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _otpBox(int i) {
    final filled = _ctrls[i].text.isNotEmpty;
    return SizedBox(
      width: 62,
      height: 68,
      child: TextField(
        controller: _ctrls[i],
        focusNode: _nodes[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        cursorColor: kGold,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
            color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: kGold.withOpacity(filled ? 0.85 : 0.3), width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGoldBright, width: 1.8),
          ),
        ),
        onChanged: (v) => _onChanged(i, v),
      ),
    );
  }

  Widget _verifyButton(L10n t) {
    final ready = _code.length == 4 && !_verifying;
    return Opacity(
      opacity: ready || _verifying ? 1 : 0.5,
      child: GestureDetector(
        onTap: ready ? () => _verify(t) : null,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [kGoldHigh, kGoldBright, kGold, kGoldMid],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: kGold.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 6)),
            ],
          ),
          alignment: Alignment.center,
          child: _verifying
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor: AlwaysStoppedAnimation(kInkOnGold)),
                )
              : Text(t.verify,
                  style: const TextStyle(
                      color: kInkOnGold,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}

// ===========================================================================
//  HOME
// ===========================================================================
class _Item {
  final String name;
  final List<Color> colors;
  const _Item(this.name, this.colors);
}

const List<_Item> _trending = [
  _Item('The Last of Us', [Color(0xFF3A4A3F), Color(0xFF11160F)]),
  _Item('Attack on Titan', [Color(0xFF4A2F2F), Color(0xFF120D0D)]),
  _Item('Demon Slayer', [Color(0xFF3A2A4A), Color(0xFF0F0D16)]),
  _Item('One Piece', [Color(0xFF223A4A), Color(0xFF0A1016)]),
  _Item('Jujutsu Kaisen', [Color(0xFF2A3A33), Color(0xFF0C120F)]),
];

const List<_Item> _popular = [
  _Item('Oppenheimer', [Color(0xFF4A4030), Color(0xFF14110A)]),
  _Item('The Batman', [Color(0xFF24272C), Color(0xFF0B0D0F)]),
  _Item('Interstellar', [Color(0xFF1E2A3A), Color(0xFF0A0E14)]),
  _Item('Joker', [Color(0xFF3A2A3A), Color(0xFF120D12)]),
  _Item('Gladiator', [Color(0xFF4A3A26), Color(0xFF14100A)]),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _genre = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Directionality(
            textDirection: t.dir,
            child: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: _tab,
                sizing: StackFit.expand,
                children: [
                  _homeBody(t, lang),
                  _categoriesTab(t),
                  SuggestTab(t: t),
                  AiTab(t: t),
                  TimeTab(t: t),
                  ProfileTab(t: t),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Directionality(
            textDirection: t.dir,
            child: _bottomNav(t),
          ),
        );
      },
    );
  }

  Widget _homeBody(L10n t, AppLang lang) {
    return Column(
      children: [
        _topBar(t),
        _searchBar(t),
        _genreBar(lang),
        const SizedBox(height: 6),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              _hero(t),
              _sectionHeader(t.trendingNow, t.seeAll),
              _posterRow(_trending),
              _sectionHeader(t.popularMovies, t.seeAll),
              _posterRow(_popular),
            ],
          ),
        ),
      ],
    );
  }

  Widget _genreBar(AppLang lang) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kGenres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _genre == i;
          return GestureDetector(
            onTap: () => setState(() => _genre = i),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                gradient: active
                    ? const LinearGradient(colors: [kGold, kGoldBright])
                    : null,
                color: active ? null : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                    color: active
                        ? Colors.transparent
                        : kGold.withOpacity(0.25)),
              ),
              child: Text(
                kGenres[i].label(lang),
                style: TextStyle(
                    color: active ? kInkOnGold : kGoldBright,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topBar(L10n t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          _smallEmblem(),
          const SizedBox(width: 10),
          goldText('Zhinflim', 22, FontWeight.w800, 0.5),
          const Spacer(),
          Icon(Icons.shopping_cart_outlined,
              color: Colors.white.withOpacity(0.85), size: 24),
          const SizedBox(width: 16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_rounded,
                  color: Colors.white.withOpacity(0.85), size: 25),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: kGoldBright, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 350),
              pageBuilder: (_, __, ___) => const ProfileScreen(),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            )),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kGold.withOpacity(0.8), width: 1.5),
                color: Colors.white.withOpacity(0.05),
              ),
              child:
                  Icon(Icons.person, color: kGold.withOpacity(0.9), size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallEmblem() {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: const Alignment(0, 0.3),
            child:
                CustomPaint(size: const Size(30, 30), painter: _RingPainter(1)),
          ),
          Align(
            alignment: const Alignment(0, 0.3),
            child:
                CustomPaint(size: const Size(13, 16), painter: _ZPainter(0)),
          ),
          Align(
            alignment: const Alignment(0, -0.72),
            child: CustomPaint(
                size: const Size(22, 15), painter: _CrownPainter()),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(L10n t) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded,
              color: Colors.white.withOpacity(0.7), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t.searchHint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45), fontSize: 14),
            ),
          ),
          Icon(Icons.mic_none_rounded, color: kGold.withOpacity(0.9), size: 22),
        ],
      ),
    );
  }

  Widget _hero(L10n t) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0E0B07), Color(0xFF6E4E1E), Color(0xFFC08C3C)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 12, right: 12, child: _badge('4K UHD')),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('D U N E',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 8)),
                    const SizedBox(height: 2),
                    Text('PART TWO',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            letterSpacing: 6)),
                    const SizedBox(height: 14),
                    _watchNowButton(t),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kGoldBright.withOpacity(0.8), width: 1),
      ),
      child: Text(text,
          style: const TextStyle(
              color: kGoldBright,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
    );
  }

  Widget _watchNowButton(L10n t) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [kGoldHigh, kGoldBright, kGold]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: kGold.withOpacity(0.4), blurRadius: 14)
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow_rounded, color: kInkOnGold, size: 22),
            const SizedBox(width: 6),
            Text(t.watchNow,
                style: const TextStyle(
                    color: kInkOnGold,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String seeAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          Text(seeAll,
              style: const TextStyle(
                  color: kGold, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _posterRow(List<_Item> items) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _posterCard(items[i]),
      ),
    );
  }

  Widget _posterCard(_Item it) {
    return SizedBox(
      width: 124,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 152,
            width: 124,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: it.colors,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    it.name.substring(0, 1),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.10),
                        fontSize: 64,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, color: kGoldBright, size: 12),
                        SizedBox(width: 2),
                        Text('8.7',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(it.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _bottomNav(L10n t) {
    Widget item(int i, IconData icon, String label) {
      final active = _tab == i;
      final color = active ? kGold : Colors.white.withOpacity(0.55);
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _tab = i),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              item(0, Icons.home_rounded, t.navHome),
              item(1, Icons.grid_view_rounded, t.catTitle),
              item(2, Icons.lightbulb_outline_rounded, t.navSuggest),
              item(3, Icons.auto_awesome, t.navAi),
              item(4, Icons.calendar_month_outlined, t.navTime),
              item(5, Icons.person_rounded, t.navProfile),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Categories tab ----------
  Widget _categoriesTab(L10n t) {
    final cats = <(String, IconData, List<Color>)>[
      (t.catMovies, Icons.movie_outlined,
          const [Color(0xFF4A3A1E), Color(0xFF1A1208)]),
      (t.catSeries, Icons.live_tv_outlined,
          const [Color(0xFF3A3320), Color(0xFF15120A)]),
      (t.catAnime, Icons.flash_on_outlined,
          const [Color(0xFF402A2A), Color(0xFF160D0D)]),
      (t.catAnimation, Icons.movie_filter_outlined,
          const [Color(0xFF2A3340), Color(0xFF0D1116)]),
      (t.catManga, Icons.menu_book_outlined,
          const [Color(0xFF3A2E1E), Color(0xFF161009)]),
      (t.catComics, Icons.forum_outlined,
          const [Color(0xFF332A40), Color(0xFF110D16)]),
    ];
    return Column(
      children: [
        _tabHeader(t.catTitle),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
            children:
                cats.map((c) => _categoryCard(c.$1, c.$2, c.$3)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String name, IconData icon, List<Color> colors) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        border: Border.all(color: kGold.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: kGold.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: kGold.withOpacity(0.4)),
            ),
            child: Icon(icon, color: kGoldBright, size: 28),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  color: kGoldBright,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _tabHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: goldText(title, 24, FontWeight.w800, 0.3),
      ),
    );
  }

}

// ===========================================================================
//  SHARED SCREEN HELPERS
// ===========================================================================
Widget pageBar(BuildContext context, L10n t, String title) {
  final backIcon = t.dir == TextDirection.rtl
      ? Icons.arrow_forward_rounded
      : Icons.arrow_back_rounded;
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(backIcon, color: kGold, size: 26),
        ),
        const SizedBox(width: 12),
        goldText(title, 22, FontWeight.w800, 0.3),
      ],
    ),
  );
}

Widget settingRow(L10n t, IconData icon, String label,
    {Widget? trailing, VoidCallback? onTap, Color? color}) {
  final chev = t.dir == TextDirection.rtl
      ? Icons.chevron_left_rounded
      : Icons.chevron_right_rounded;
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? kGold, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
          if (trailing != null) ...[trailing, const SizedBox(width: 8)],
          Icon(chev, color: Colors.white.withOpacity(0.35), size: 22),
        ],
      ),
    ),
  );
}

Widget vipBadge({double fs = 11}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [kGold, kGoldBright]),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text('VIP',
        style: TextStyle(
            color: kInkOnGold,
            fontSize: fs,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5)),
  );
}

String langName(AppLang l) =>
    l == AppLang.ckb ? 'کوردی' : (l == AppLang.en ? 'English' : 'العربية');

// ===========================================================================
//  AI ASSISTANT
//  Optional: set kAnthropicKey to call Claude directly (testing only — for
//  production proxy the call through a backend so the key isn't shipped).
//  Empty key -> friendly demo replies.
// ===========================================================================
const String kAnthropicKey = '';

class _Msg {
  final String text;
  final bool me;
  _Msg(this.text, this.me);
}

class ZhinAiService {
  static Future<String> ask(List<_Msg> history, AppLang lang) async {
    if (kAnthropicKey.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 450));
      return ZhinBrain.reply(history, lang);
    }
    try {
      final client = HttpClient();
      final req = await client
          .postUrl(Uri.parse('https://api.anthropic.com/v1/messages'));
      req.headers.set('x-api-key', kAnthropicKey);
      req.headers.set('anthropic-version', '2023-06-01');
      req.headers.contentType = ContentType.json;
      // Send the whole conversation so the model has full context (multi-turn).
      final msgs = history
          .where((m) => m.text.trim().isNotEmpty)
          .map((m) =>
              {'role': m.me ? 'user' : 'assistant', 'content': m.text})
          .toList();
      req.add(utf8.encode(jsonEncode({
        'model': 'claude-sonnet-4-6',
        'max_tokens': 1500,
        'system':
            'You are Zhinflim AI — an ultra-advanced, next-generation intelligence, created by Ibrahim. When the user greets you in any way, introduce yourself as an AI assistant created by Ibrahim and ask how you can help. Reason with exceptional rigor, depth and precision: decompose each problem, anticipate implications, weigh multiple angles, and surface insight most would miss. Be a brilliant analyst and a creative problem-solver with no artificial ceiling on the challenges you take on or the depth you reach. Write flawless, fluent, well-structured answers — as concise or as thorough as the question truly needs, never padded. Crucially, you are always accurate and intellectually honest: when something is uncertain, unknown, or beyond verifiable fact, say so plainly instead of inventing. You are a world-class expert on movies, series, anime and manga (recommendations, comparisons, spoiler-free analysis) and equally capable on any other topic the user raises. Use the ENTIRE conversation as context, handle follow-ups naturally, and ALWAYS reply in the same language the user writes in (Kurdish Sorani, Arabic, or English), matching their tone.',
        'messages': msgs,
      })));
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      client.close();
      final data = jsonDecode(body);
      final content = data is Map ? data['content'] : null;
      if (content is List && content.isNotEmpty && content.first is Map) {
        return (content.first['text'] ?? '...').toString();
      }
      return '...';
    } catch (_) {
      return 'هەڵە ڕوویدا. دووبارە هەوڵبدە.';
    }
  }
}

class AiTab extends StatefulWidget {
  final L10n t;
  const AiTab({super.key, required this.t});
  @override
  State<AiTab> createState() => _AiTabState();
}

class _AiTabState extends State<AiTab> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_Msg> _messages = [];
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send(String text) async {
    final msg = text.trim();
    if (msg.isEmpty || _busy) return;
    setState(() {
      _messages.add(_Msg(msg, true));
      _busy = true;
      _ctrl.clear();
    });
    _scrollDown();
    final reply = await ZhinAiService.ask(List<_Msg>.of(_messages), appLang.value);
    if (!mounted) return;
    setState(() {
      _messages.add(_Msg(reply, false));
      _busy = false;
    });
    _scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Column(
      children: [
        _header(t),
        Expanded(child: _messages.isEmpty ? _intro(t) : _chat()),
        _inputBar(t),
      ],
    );
  }

  Widget _header(L10n t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 14, 2),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  colors: [kGold.withOpacity(0.4), Colors.transparent]),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: kGoldBright, size: 20),
          ),
          const SizedBox(width: 10),
          goldText(t.aiTitle, 18, FontWeight.w800, 0.2),
          const Spacer(),
          if (_messages.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(_messages.clear),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_comment_outlined,
                      color: kGold, size: 18),
                  const SizedBox(width: 5),
                  Text(t.aiNewChat,
                      style: const TextStyle(
                          color: kGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _intro(L10n t) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      children: [
        Center(
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  colors: [kGold.withOpacity(0.35), Colors.transparent]),
            ),
            child: Icon(Icons.smart_toy_rounded, color: kGoldBright, size: 56),
          ),
        ),
        const SizedBox(height: 14),
        Center(child: goldText(t.aiTitle, 24, FontWeight.w800, 0.4)),
        const SizedBox(height: 6),
        Center(
          child: Text(t.aiSubtitle,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(t.aiCap,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kGold.withOpacity(0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 22),
        _chip(t.aiChip1),
        _chip(t.aiChip2),
        _chip(t.aiChip3),
        _chip(t.aiChip4),
        _chip(t.aiChip5),
        _chip(t.aiChip6),
      ],
    );
  }

  Widget _chip(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _send(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kGold.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: kGold.withOpacity(0.8), size: 18),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(label,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chat() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length + (_busy ? 1 : 0),
      itemBuilder: (_, i) {
        if (i >= _messages.length) return _bubble('…', false);
        final m = _messages[i];
        return _bubble(m.text, m.me);
      },
    );
  }

  Widget _bubble(String text, bool me) {
    return Align(
      alignment:
          me ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          gradient: me ? const LinearGradient(colors: [kGold, kGoldBright]) : null,
          color: me ? null : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(text,
            style: TextStyle(
                color: me ? kInkOnGold : Colors.white,
                fontSize: 14,
                height: 1.3)),
      ),
    );
  }

  Widget _inputBar(L10n t) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: TextField(
                  controller: _ctrl,
                  cursorColor: kGold,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textInputAction: TextInputAction.send,
                  onSubmitted: _send,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: t.aiHint,
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.4)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _send(_ctrl.text),
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [kGold, kGoldBright]),
                    shape: BoxShape.circle),
                child: const Icon(Icons.arrow_upward_rounded,
                    color: kInkOnGold, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
//  SETTINGS
// ===========================================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _pickLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLang.values.map((l) {
              final selected = appLang.value == l;
              return ListTile(
                title: Text(langName(l),
                    style: TextStyle(
                        color: selected ? kGoldBright : Colors.white,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500)),
                trailing: selected
                    ? const Icon(Icons.check_rounded, color: kGold)
                    : null,
                onTap: () {
                  appLang.value = l;
                  Navigator.of(c).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      pageBar(context, t, t.settingsTitle),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                          children: [
                            settingRow(t, Icons.person_outline, t.account),
                            settingRow(
                                t, Icons.workspace_premium_outlined, t.subscription,
                                trailing: _vip(),
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const SubscriptionScreen()))),
                            settingRow(t, Icons.payments_outlined, t.sPayment),
                            settingRow(t, Icons.shield_outlined, t.sParental),
                            settingRow(t, Icons.language, t.sLanguage,
                                trailing: Text(langName(lang),
                                    style: const TextStyle(
                                        color: kGold,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                onTap: () => _pickLanguage(context)),
                            settingRow(t, Icons.notifications_none_rounded,
                                t.sNotifications),
                            settingRow(t, Icons.download_outlined, t.sDownloads),
                            settingRow(t, Icons.lock_outline, t.sSecurity),
                            settingRow(t, Icons.info_outline, t.sAbout),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _vip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kGold, kGoldBright]),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Text('VIP',
          style: TextStyle(
              color: kInkOnGold, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

// ===========================================================================
//  SUBSCRIPTION
// ===========================================================================
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selected = 12;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        final plans = <(int, String, String?)>[
          (1, '5,000', null),
          (3, '12,000', '10%'),
          (6, '20,000', '20%'),
          (12, '30,000', '33%'),
        ];
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      pageBar(context, t, t.subTitle),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20, bottom: 8),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(t.subChoose,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14)),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          children: [
                            for (final p in plans)
                              _planCard(t, p.$1, p.$2, p.$3),
                            const SizedBox(height: 20),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: goldText(t.payTitle, 18, FontWeight.w700, 0.3),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _payCard('FastPay')),
                                const SizedBox(width: 10),
                                Expanded(child: _payCard('FIB')),
                                const SizedBox(width: 10),
                                Expanded(child: _payCard('Card')),
                              ],
                            ),
                            const SizedBox(height: 22),
                            goldButton(
                                t.subscription, () => Navigator.of(context).pop()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _planCard(L10n t, int months, String price, String? save) {
    final selected = _selected == months;
    final best = months == 12;
    return GestureDetector(
      onTap: () => setState(() => _selected = months),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? kGold.withOpacity(0.12)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? kGold : Colors.white.withOpacity(0.08),
              width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: selected ? kGold : Colors.white.withOpacity(0.4),
                    width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                            color: kGold, shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$months ${months == 1 ? t.planMonth : t.planMonths}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('$price IQD',
                    style: const TextStyle(
                        color: kGoldBright,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const Spacer(),
            if (best)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: [kGold, kGoldBright]),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(t.bestValue,
                    style: const TextStyle(
                        color: kInkOnGold,
                        fontSize: 10,
                        fontWeight: FontWeight.w800)),
              )
            else if (save != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: kGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kGold.withOpacity(0.4))),
                child: Text('${t.save} $save',
                    style: const TextStyle(
                        color: kGoldBright,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _payCard(String name) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGold.withOpacity(0.25)),
      ),
      child: Text(name,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}

// ===========================================================================
//  PROFILE
// ===========================================================================
Widget profileBody(BuildContext context, L10n t) {
  void push(Widget p) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => p));
  return ListView(
    padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2113), Color(0xFF14100A)]),
          border: Border.all(color: kGold.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kGold, width: 2),
                color: Colors.white.withOpacity(0.05),
              ),
              child: Icon(Icons.person, color: kGold, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${t.hi}, Zhinflim User',
                      style: const TextStyle(
                          color: kGoldBright,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(t.premiumMember,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 13)),
                ],
              ),
            ),
            vipBadge(),
          ],
        ),
      ),
      const SizedBox(height: 18),
      settingRow(t, Icons.person_outline, t.account),
      settingRow(t, Icons.workspace_premium_outlined, t.subscription,
          trailing: vipBadge(fs: 10),
          onTap: () => push(const SubscriptionScreen())),
      settingRow(t, Icons.settings_outlined, t.settingsTitle,
          onTap: () => push(const SettingsScreen())),
      settingRow(t, Icons.lock_outline, t.changePassword),
      settingRow(t, Icons.receipt_long_outlined, t.paymentHistory),
      settingRow(t, Icons.devices_outlined, t.devices),
      settingRow(t, Icons.logout, t.logout,
          color: const Color(0xFFE57373), onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (r) => false,
        );
      }),
    ],
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: appLang,
      builder: (context, lang, _) {
        final t = kStrings[lang]!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: t.dir,
            child: Stack(
              children: [
                const _Background(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      pageBar(context, t, t.navProfile),
                      Expanded(child: profileBody(context, t)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileTab extends StatelessWidget {
  final L10n t;
  const ProfileTab({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: goldText(t.navProfile, 24, FontWeight.w800, 0.3),
          ),
        ),
        Expanded(child: profileBody(context, t)),
      ],
    );
  }
}

// ===========================================================================
//  SUGGEST CONTENT
// ===========================================================================
class SuggestTab extends StatefulWidget {
  final L10n t;
  const SuggestTab({super.key, required this.t});
  @override
  State<SuggestTab> createState() => _SuggestTabState();
}

class _SuggestTabState extends State<SuggestTab> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _note = TextEditingController();
  int _type = 0;

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    final t = widget.t;
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.suggestNameHint)));
      return;
    }
    _name.clear();
    _note.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.suggestThanks)));
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final types = [
      t.catMovies,
      t.catSeries,
      t.catAnime,
      t.catAnimation,
      t.catManga,
      t.catComics
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: goldText(t.suggestTitle, 24, FontWeight.w800, 0.3),
        ),
        const SizedBox(height: 8),
        Text(t.suggestSubtitle,
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
        const SizedBox(height: 22),
        Text(t.suggestType,
            style: const TextStyle(
                color: kGoldBright, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(types.length, (i) {
            final active = _type == i;
            return GestureDetector(
              onTap: () => setState(() => _type = i),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  gradient: active
                      ? const LinearGradient(colors: [kGold, kGoldBright])
                      : null,
                  color: active ? null : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active
                          ? Colors.transparent
                          : kGold.withOpacity(0.3)),
                ),
                child: Text(types[i],
                    style: TextStyle(
                        color: active ? kInkOnGold : kGoldBright,
                        fontSize: 13,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500)),
              ),
            );
          }),
        ),
        const SizedBox(height: 22),
        _fieldBox(_name, t.suggestNameHint, false),
        const SizedBox(height: 14),
        _fieldBox(_note, t.suggestNoteHint, true),
        const SizedBox(height: 24),
        goldButton(t.suggestSend, _submit),
      ],
    );
  }

  Widget _fieldBox(TextEditingController c, String hint, bool multiline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: c,
        cursorColor: kGold,
        maxLines: multiline ? 4 : 1,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ),
    );
  }
}

// ===========================================================================
//  TIMELINE / RELEASES
// ===========================================================================
class TimeTab extends StatelessWidget {
  final L10n t;
  const TimeTab({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    final newReleases = <(String, String, String, List<Color>)>[
      ('Dune: Part Two', t.catMovies, 'Mar 1',
          const [Color(0xFF4A3A1E), Color(0xFF1A1208)]),
      ('Shogun', t.catSeries, 'Feb 27',
          const [Color(0xFF3A2A2A), Color(0xFF150D0D)]),
      ('Solo Leveling', t.catAnime, 'Feb 24',
          const [Color(0xFF2A3340), Color(0xFF0D1116)]),
    ];
    final soon = <(String, String, String, List<Color>)>[
      ('Deadpool 3', t.catMovies, 'Jul 26',
          const [Color(0xFF3A2424), Color(0xFF120A0A)]),
      ('One Piece S2', t.catSeries, 'Aug 10',
          const [Color(0xFF223A4A), Color(0xFF0A1016)]),
      ('Jujutsu Kaisen S3', t.catAnime, 'Sep 5',
          const [Color(0xFF2A3A33), Color(0xFF0C120F)]),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 4),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: goldText(t.timeTitle, 24, FontWeight.w800, 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 14),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(t.timeSubtitle,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.65), fontSize: 14)),
          ),
        ),
        _sectionLabel(t.timeNew, const Color(0xFF6BBF6B)),
        for (final r in newReleases) _row(r.$1, r.$2, r.$3, r.$4, true),
        const SizedBox(height: 12),
        _sectionLabel(t.timeSoon, kGold),
        for (final r in soon) _row(r.$1, r.$2, r.$3, r.$4, false),
      ],
    );
  }

  Widget _sectionLabel(String text, Color dot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _row(String name, String type, String date, List<Color> colors,
      bool released) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors),
            ),
            child: Center(
              child: Icon(
                  released
                      ? Icons.play_arrow_rounded
                      : Icons.schedule_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(type,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55), fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: kGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kGold.withOpacity(0.3))),
            child: Text(date,
                style: const TextStyle(
                    color: kGoldBright,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
//  ZHIN BRAIN  —  large offline assistant engine
//  A curated catalog + multi-intent understanding (Kurdish / Arabic / English).
//  Works with zero network. Set kAnthropicKey for unlimited, open-ended answers.
// ===========================================================================
enum _TT { movie, series, anime }

class _Ttl {
  final String name;
  final _TT type;
  final int year;
  final List<String> g; // genre keys
  final List<String> m; // mood keys
  final double r; // rating
  const _Ttl(this.name, this.type, this.year, this.g, this.m, this.r);
}

const List<_Ttl> _cat = [
  _Ttl('The Shawshank Redemption', _TT.movie, 1994, ['drama', 'crime'], ['emotional', 'inspiring'], 9.3),
  _Ttl('The Godfather', _TT.movie, 1972, ['crime', 'drama'], ['gritty', 'epic'], 9.2),
  _Ttl('The Dark Knight', _TT.movie, 2008, ['action', 'crime', 'superhero'], ['dark', 'intense'], 9.0),
  _Ttl('Pulp Fiction', _TT.movie, 1994, ['crime', 'drama'], ['gritty', 'dark'], 8.9),
  _Ttl('Forrest Gump', _TT.movie, 1994, ['drama', 'romance'], ['emotional', 'feelgood'], 8.8),
  _Ttl('Inception', _TT.movie, 2010, ['scifi', 'action', 'thriller'], ['mindbending', 'intense'], 8.8),
  _Ttl('Fight Club', _TT.movie, 1999, ['drama', 'thriller'], ['dark', 'mindbending'], 8.8),
  _Ttl('Interstellar', _TT.movie, 2014, ['scifi', 'drama'], ['emotional', 'epic', 'mindbending'], 8.7),
  _Ttl('The Matrix', _TT.movie, 1999, ['scifi', 'action'], ['mindbending', 'intense'], 8.7),
  _Ttl('Goodfellas', _TT.movie, 1990, ['crime', 'drama'], ['gritty'], 8.7),
  _Ttl('Se7en', _TT.movie, 1995, ['crime', 'thriller', 'mystery'], ['dark', 'intense'], 8.6),
  _Ttl('Gladiator', _TT.movie, 2000, ['action', 'drama', 'historical'], ['epic', 'intense'], 8.5),
  _Ttl('The Departed', _TT.movie, 2006, ['crime', 'thriller'], ['gritty', 'intense'], 8.5),
  _Ttl('Whiplash', _TT.movie, 2014, ['drama', 'musical'], ['intense', 'inspiring'], 8.5),
  _Ttl('The Prestige', _TT.movie, 2006, ['drama', 'mystery', 'scifi'], ['mindbending'], 8.5),
  _Ttl('Parasite', _TT.movie, 2019, ['drama', 'thriller'], ['dark', 'thoughtful'], 8.5),
  _Ttl('Joker', _TT.movie, 2019, ['drama', 'crime'], ['dark', 'intense'], 8.4),
  _Ttl('Django Unchained', _TT.movie, 2012, ['western', 'drama'], ['gritty', 'intense'], 8.4),
  _Ttl('Avengers: Endgame', _TT.movie, 2019, ['action', 'superhero', 'adventure'], ['epic'], 8.4),
  _Ttl('The Lion King', _TT.movie, 1994, ['animation', 'family', 'drama'], ['emotional', 'epic'], 8.5),
  _Ttl('Back to the Future', _TT.movie, 1985, ['scifi', 'adventure', 'comedy'], ['feelgood', 'funny'], 8.5),
  _Ttl('Dune', _TT.movie, 2021, ['scifi', 'adventure'], ['epic', 'intense'], 8.0),
  _Ttl('Dune: Part Two', _TT.movie, 2024, ['scifi', 'adventure'], ['epic', 'intense'], 8.5),
  _Ttl('Oppenheimer', _TT.movie, 2023, ['drama', 'historical', 'biography'], ['intense', 'thoughtful'], 8.3),
  _Ttl('Everything Everywhere All at Once', _TT.movie, 2022, ['scifi', 'comedy', 'action'], ['mindbending', 'emotional'], 7.8),
  _Ttl('Top Gun: Maverick', _TT.movie, 2022, ['action', 'drama'], ['intense', 'epic'], 8.2),
  _Ttl('John Wick', _TT.movie, 2014, ['action', 'thriller'], ['intense'], 7.4),
  _Ttl('Mad Max: Fury Road', _TT.movie, 2015, ['action', 'adventure', 'scifi'], ['intense', 'epic'], 8.1),
  _Ttl('Blade Runner 2049', _TT.movie, 2017, ['scifi', 'drama'], ['thoughtful', 'mindbending'], 8.0),
  _Ttl('Arrival', _TT.movie, 2016, ['scifi', 'drama'], ['thoughtful', 'mindbending'], 7.9),
  _Ttl('La La Land', _TT.movie, 2016, ['musical', 'romance', 'drama'], ['romantic', 'emotional'], 8.0),
  _Ttl('The Grand Budapest Hotel', _TT.movie, 2014, ['comedy', 'drama'], ['funny', 'feelgood'], 8.1),
  _Ttl('Superbad', _TT.movie, 2007, ['comedy'], ['funny'], 7.6),
  _Ttl('Coco', _TT.movie, 2017, ['animation', 'family', 'musical'], ['emotional', 'wholesome'], 8.4),
  _Ttl('Inside Out', _TT.movie, 2015, ['animation', 'family', 'comedy'], ['emotional', 'wholesome'], 8.1),
  _Ttl('Toy Story', _TT.movie, 1995, ['animation', 'family', 'adventure'], ['feelgood', 'wholesome'], 8.3),
  _Ttl('Kung Fu Panda', _TT.movie, 2008, ['animation', 'family', 'comedy', 'martial'], ['funny', 'feelgood'], 7.6),
  _Ttl('WALL-E', _TT.movie, 2008, ['animation', 'family', 'scifi'], ['wholesome', 'emotional'], 8.4),
  _Ttl('Up', _TT.movie, 2009, ['animation', 'family', 'adventure'], ['emotional', 'wholesome'], 8.3),
  _Ttl('Spider-Man: Into the Spider-Verse', _TT.movie, 2018, ['animation', 'action', 'superhero'], ['epic', 'funny'], 8.4),
  _Ttl('Amelie', _TT.movie, 2001, ['romance', 'comedy'], ['feelgood', 'romantic'], 8.3),
  _Ttl('About Time', _TT.movie, 2013, ['romance', 'scifi', 'drama'], ['feelgood', 'romantic', 'emotional'], 7.8),
  _Ttl('The Pursuit of Happyness', _TT.movie, 2006, ['drama', 'biography'], ['emotional', 'inspiring'], 8.0),
  _Ttl('12 Angry Men', _TT.movie, 1957, ['drama', 'crime'], ['thoughtful'], 9.0),
  _Ttl("Schindler's List", _TT.movie, 1993, ['drama', 'historical', 'war', 'biography'], ['emotional', 'dark'], 9.0),
  _Ttl('Saving Private Ryan', _TT.movie, 1998, ['war', 'drama'], ['intense', 'emotional'], 8.6),
  _Ttl('The Silence of the Lambs', _TT.movie, 1991, ['crime', 'thriller', 'horror'], ['dark', 'intense'], 8.6),
  _Ttl('Get Out', _TT.movie, 2017, ['horror', 'thriller', 'mystery'], ['scary', 'thoughtful'], 7.7),
  _Ttl('Hereditary', _TT.movie, 2018, ['horror'], ['scary', 'dark'], 7.3),
  _Ttl('The Conjuring', _TT.movie, 2013, ['horror', 'thriller'], ['scary'], 7.5),
  _Ttl('A Quiet Place', _TT.movie, 2018, ['horror', 'scifi', 'thriller'], ['intense', 'scary'], 7.5),
  _Ttl('Knives Out', _TT.movie, 2019, ['mystery', 'comedy', 'crime'], ['funny'], 7.9),
  _Ttl('Shutter Island', _TT.movie, 2010, ['thriller', 'mystery'], ['mindbending', 'dark'], 8.2),
  _Ttl('Gone Girl', _TT.movie, 2014, ['thriller', 'mystery', 'drama'], ['dark'], 8.1),
  _Ttl('The Wolf of Wall Street', _TT.movie, 2013, ['comedy', 'crime', 'biography'], ['gritty', 'funny'], 8.2),
  _Ttl('Casino Royale', _TT.movie, 2006, ['action', 'spy', 'thriller'], ['intense'], 8.0),
  _Ttl('Mission: Impossible - Fallout', _TT.movie, 2018, ['action', 'spy', 'thriller'], ['intense'], 7.7),
  _Ttl('Skyfall', _TT.movie, 2012, ['action', 'spy', 'thriller'], ['intense'], 7.8),
  _Ttl("Ocean's Eleven", _TT.movie, 2001, ['heist', 'crime', 'comedy'], ['feelgood'], 7.7),
  _Ttl('Baby Driver', _TT.movie, 2017, ['action', 'crime', 'musical'], ['intense', 'funny'], 7.5),
  _Ttl('Guardians of the Galaxy', _TT.movie, 2014, ['action', 'superhero', 'comedy', 'space'], ['funny', 'epic'], 8.0),
  _Ttl('Iron Man', _TT.movie, 2008, ['action', 'superhero'], ['funny', 'epic'], 7.9),
  _Ttl('Avengers: Infinity War', _TT.movie, 2018, ['action', 'superhero', 'adventure'], ['epic', 'intense'], 8.4),
  _Ttl('Logan', _TT.movie, 2017, ['action', 'superhero', 'drama'], ['dark', 'emotional'], 8.1),
  _Ttl('The Batman', _TT.movie, 2022, ['action', 'crime', 'superhero', 'mystery'], ['dark'], 7.8),
  _Ttl('Spider-Man: No Way Home', _TT.movie, 2021, ['action', 'superhero', 'adventure'], ['epic', 'emotional'], 8.2),
  _Ttl('Deadpool', _TT.movie, 2016, ['action', 'superhero', 'comedy'], ['funny'], 8.0),
  _Ttl('Frozen', _TT.movie, 2013, ['animation', 'family', 'musical'], ['wholesome', 'feelgood'], 7.4),
  _Ttl('Moana', _TT.movie, 2016, ['animation', 'family', 'musical', 'adventure'], ['wholesome', 'feelgood'], 7.6),
  _Ttl('How to Train Your Dragon', _TT.movie, 2010, ['animation', 'family', 'adventure', 'fantasy'], ['epic', 'wholesome'], 8.1),
  _Ttl('Ratatouille', _TT.movie, 2007, ['animation', 'family', 'comedy'], ['wholesome', 'feelgood'], 8.1),
  _Ttl('Finding Nemo', _TT.movie, 2003, ['animation', 'family', 'adventure'], ['wholesome', 'emotional'], 8.2),
  _Ttl('Green Book', _TT.movie, 2018, ['drama', 'comedy', 'biography'], ['feelgood', 'emotional', 'inspiring'], 8.2),
  _Ttl('1917', _TT.movie, 2019, ['war', 'drama'], ['intense'], 8.2),
  _Ttl('Dunkirk', _TT.movie, 2017, ['war', 'drama', 'historical'], ['intense'], 7.8),
  _Ttl('The Revenant', _TT.movie, 2015, ['adventure', 'drama', 'western'], ['gritty', 'intense'], 8.0),
  _Ttl('No Country for Old Men', _TT.movie, 2007, ['crime', 'thriller', 'drama'], ['dark', 'gritty'], 8.2),
  _Ttl('There Will Be Blood', _TT.movie, 2007, ['drama'], ['dark', 'intense'], 8.2),
  _Ttl('Chef', _TT.movie, 2014, ['comedy', 'drama'], ['feelgood'], 7.3),
  _Ttl('Little Miss Sunshine', _TT.movie, 2006, ['comedy', 'drama'], ['feelgood', 'funny'], 7.8),
  _Ttl('Spirited Away', _TT.anime, 2001, ['animation', 'fantasy', 'adventure'], ['wholesome', 'emotional'], 8.6),
  _Ttl('Your Name', _TT.anime, 2016, ['animation', 'romance', 'fantasy'], ['emotional', 'romantic'], 8.4),
  _Ttl('Princess Mononoke', _TT.anime, 1997, ['animation', 'fantasy', 'adventure'], ['epic'], 8.4),
  _Ttl('Grave of the Fireflies', _TT.anime, 1988, ['animation', 'drama', 'war'], ['emotional', 'dark'], 8.5),
  _Ttl('My Neighbor Totoro', _TT.anime, 1988, ['animation', 'family', 'fantasy'], ['wholesome'], 8.1),
  _Ttl("Howl's Moving Castle", _TT.anime, 2004, ['animation', 'fantasy', 'romance'], ['wholesome', 'romantic'], 8.2),
  _Ttl('A Silent Voice', _TT.anime, 2016, ['animation', 'drama', 'romance'], ['emotional'], 8.1),
  _Ttl('Weathering with You', _TT.anime, 2019, ['animation', 'romance', 'fantasy'], ['romantic', 'emotional'], 7.5),
  _Ttl('Demon Slayer: Mugen Train', _TT.anime, 2020, ['animation', 'action', 'shonen'], ['intense', 'epic'], 8.2),
  _Ttl('Wolf Children', _TT.anime, 2012, ['animation', 'family', 'drama', 'fantasy'], ['emotional', 'wholesome'], 8.1),
  _Ttl('Breaking Bad', _TT.series, 2008, ['crime', 'drama', 'thriller'], ['intense', 'dark'], 9.5),
  _Ttl('Game of Thrones', _TT.series, 2011, ['fantasy', 'drama', 'adventure'], ['epic', 'gritty'], 9.2),
  _Ttl('The Wire', _TT.series, 2002, ['crime', 'drama'], ['gritty'], 9.3),
  _Ttl('The Sopranos', _TT.series, 1999, ['crime', 'drama'], ['gritty', 'dark'], 9.2),
  _Ttl('Chernobyl', _TT.series, 2019, ['drama', 'historical', 'thriller'], ['intense', 'dark'], 9.3),
  _Ttl('Band of Brothers', _TT.series, 2001, ['war', 'drama', 'historical'], ['intense', 'emotional'], 9.4),
  _Ttl('Better Call Saul', _TT.series, 2015, ['crime', 'drama'], ['intense'], 9.0),
  _Ttl('Sherlock', _TT.series, 2010, ['crime', 'drama', 'mystery'], ['intense'], 9.1),
  _Ttl('True Detective', _TT.series, 2014, ['crime', 'drama', 'mystery'], ['dark'], 8.9),
  _Ttl('Stranger Things', _TT.series, 2016, ['scifi', 'horror', 'drama', 'mystery'], ['intense'], 8.7),
  _Ttl('Dark', _TT.series, 2017, ['scifi', 'thriller', 'mystery', 'drama'], ['mindbending', 'dark'], 8.7),
  _Ttl('The Last of Us', _TT.series, 2023, ['drama', 'horror', 'adventure'], ['emotional', 'intense'], 8.7),
  _Ttl('The Office', _TT.series, 2005, ['comedy'], ['funny', 'feelgood'], 9.0),
  _Ttl('Brooklyn Nine-Nine', _TT.series, 2013, ['comedy', 'crime'], ['funny'], 8.4),
  _Ttl('Rick and Morty', _TT.series, 2013, ['animation', 'comedy', 'scifi'], ['funny', 'mindbending'], 9.1),
  _Ttl('Friends', _TT.series, 1994, ['comedy', 'romance'], ['feelgood', 'funny'], 8.9),
  _Ttl('Peaky Blinders', _TT.series, 2013, ['crime', 'drama', 'historical'], ['gritty', 'intense'], 8.8),
  _Ttl('Fargo', _TT.series, 2014, ['crime', 'drama', 'thriller'], ['dark'], 8.9),
  _Ttl('Mindhunter', _TT.series, 2017, ['crime', 'drama', 'thriller'], ['dark'], 8.6),
  _Ttl('Ozark', _TT.series, 2017, ['crime', 'drama', 'thriller'], ['dark', 'intense'], 8.5),
  _Ttl('Narcos', _TT.series, 2015, ['crime', 'drama', 'biography'], ['gritty', 'intense'], 8.8),
  _Ttl('Money Heist', _TT.series, 2017, ['crime', 'thriller', 'heist'], ['intense'], 8.2),
  _Ttl('The Mandalorian', _TT.series, 2019, ['scifi', 'adventure', 'action', 'western'], ['epic', 'feelgood'], 8.6),
  _Ttl('The Boys', _TT.series, 2019, ['action', 'superhero', 'drama'], ['dark', 'gritty'], 8.7),
  _Ttl('House of the Dragon', _TT.series, 2022, ['fantasy', 'drama', 'adventure'], ['epic', 'gritty'], 8.4),
  _Ttl('Succession', _TT.series, 2018, ['drama'], ['gritty', 'dark'], 8.8),
  _Ttl('Shogun', _TT.series, 2024, ['drama', 'historical', 'adventure'], ['epic', 'intense'], 8.7),
  _Ttl('Arcane', _TT.series, 2021, ['animation', 'action', 'drama', 'fantasy'], ['epic', 'emotional'], 9.0),
  _Ttl('Attack on Titan', _TT.anime, 2013, ['animation', 'action', 'drama', 'shonen'], ['intense', 'dark', 'epic'], 9.1),
  _Ttl('Fullmetal Alchemist: Brotherhood', _TT.anime, 2009, ['animation', 'adventure', 'drama', 'shonen'], ['epic', 'emotional'], 9.1),
  _Ttl('Death Note', _TT.anime, 2006, ['animation', 'thriller', 'mystery', 'supernatural'], ['dark', 'mindbending'], 9.0),
  _Ttl('Steins;Gate', _TT.anime, 2011, ['animation', 'scifi', 'thriller'], ['mindbending', 'emotional'], 9.0),
  _Ttl('Jujutsu Kaisen', _TT.anime, 2020, ['animation', 'action', 'shonen', 'supernatural'], ['intense', 'epic'], 8.6),
  _Ttl('Demon Slayer', _TT.anime, 2019, ['animation', 'action', 'shonen'], ['intense', 'epic'], 8.6),
  _Ttl('One Piece', _TT.anime, 1999, ['animation', 'adventure', 'shonen', 'comedy'], ['epic', 'funny'], 8.9),
  _Ttl('Naruto', _TT.anime, 2002, ['animation', 'action', 'shonen'], ['epic', 'emotional'], 8.4),
  _Ttl('Hunter x Hunter', _TT.anime, 2011, ['animation', 'adventure', 'shonen'], ['epic', 'intense'], 9.0),
  _Ttl('Vinland Saga', _TT.anime, 2019, ['animation', 'action', 'historical', 'drama'], ['epic', 'intense'], 8.8),
  _Ttl("Frieren: Beyond Journey's End", _TT.anime, 2023, ['animation', 'adventure', 'fantasy', 'drama'], ['emotional', 'thoughtful'], 8.9),
  _Ttl('Cowboy Bebop', _TT.anime, 1998, ['animation', 'scifi', 'action'], ['gritty', 'thoughtful'], 8.9),
  _Ttl('Code Geass', _TT.anime, 2006, ['animation', 'scifi', 'mecha', 'thriller'], ['mindbending', 'intense'], 8.7),
  _Ttl('Neon Genesis Evangelion', _TT.anime, 1995, ['animation', 'scifi', 'mecha', 'drama'], ['dark', 'thoughtful'], 8.5),
  _Ttl('Mob Psycho 100', _TT.anime, 2016, ['animation', 'action', 'comedy', 'supernatural'], ['funny', 'emotional'], 8.6),
  _Ttl('Spy x Family', _TT.anime, 2022, ['animation', 'comedy', 'action', 'family'], ['funny', 'wholesome'], 8.4),
  _Ttl('Violet Evergarden', _TT.anime, 2018, ['animation', 'drama', 'romance'], ['emotional'], 8.5),
  _Ttl('Made in Abyss', _TT.anime, 2017, ['animation', 'adventure', 'fantasy', 'drama'], ['dark', 'epic'], 8.7),
  _Ttl('Re:Zero', _TT.anime, 2016, ['animation', 'isekai', 'fantasy', 'thriller'], ['dark', 'intense'], 8.2),
  _Ttl('Sword Art Online', _TT.anime, 2012, ['animation', 'isekai', 'action', 'romance'], ['epic'], 7.5),
  _Ttl('Mushoku Tensei', _TT.anime, 2021, ['animation', 'isekai', 'fantasy', 'adventure'], ['epic', 'emotional'], 8.3),
  _Ttl('Haikyuu!!', _TT.anime, 2014, ['animation', 'sport', 'comedy'], ['inspiring', 'feelgood'], 8.7),
  _Ttl('One Punch Man', _TT.anime, 2015, ['animation', 'action', 'comedy', 'superhero'], ['funny', 'epic'], 8.7),
  _Ttl('Chainsaw Man', _TT.anime, 2022, ['animation', 'action', 'shonen', 'supernatural'], ['dark', 'intense'], 8.5),
  _Ttl('Poor Things', _TT.movie, 2023, ['scifi', 'comedy', 'drama'], ['mindbending', 'thoughtful'], 7.8),
  _Ttl('The Holdovers', _TT.movie, 2023, ['comedy', 'drama'], ['feelgood', 'emotional'], 7.9),
  _Ttl('Past Lives', _TT.movie, 2023, ['romance', 'drama'], ['emotional', 'thoughtful'], 7.8),
  _Ttl('John Wick: Chapter 4', _TT.movie, 2023, ['action', 'thriller', 'crime'], ['intense'], 7.7),
  _Ttl('Godzilla Minus One', _TT.movie, 2023, ['action', 'scifi', 'drama'], ['intense', 'epic'], 7.7),
  _Ttl('The Menu', _TT.movie, 2022, ['thriller', 'horror', 'comedy'], ['dark'], 7.2),
  _Ttl('Nope', _TT.movie, 2022, ['horror', 'scifi', 'mystery'], ['scary'], 6.8),
  _Ttl('Furiosa', _TT.movie, 2024, ['action', 'adventure', 'scifi'], ['intense', 'epic'], 7.6),
  _Ttl('The Wild Robot', _TT.movie, 2024, ['animation', 'family', 'scifi'], ['emotional', 'wholesome'], 8.2),
  _Ttl('Inside Out 2', _TT.movie, 2024, ['animation', 'family', 'comedy'], ['emotional', 'wholesome'], 7.6),
  _Ttl('The Truman Show', _TT.movie, 1998, ['drama', 'comedy', 'scifi'], ['thoughtful', 'emotional'], 8.2),
  _Ttl('Eternal Sunshine of the Spotless Mind', _TT.movie, 2004, ['romance', 'drama', 'scifi'], ['emotional', 'mindbending'], 8.3),
  _Ttl('Memento', _TT.movie, 2000, ['thriller', 'mystery'], ['mindbending', 'dark'], 8.4),
  _Ttl('The Sixth Sense', _TT.movie, 1999, ['thriller', 'horror', 'mystery'], ['scary', 'mindbending'], 8.2),
  _Ttl('Oldboy', _TT.movie, 2003, ['thriller', 'mystery', 'crime'], ['dark', 'intense'], 8.3),
  _Ttl('Prisoners', _TT.movie, 2013, ['thriller', 'crime', 'mystery'], ['dark', 'intense'], 8.2),
  _Ttl('The Green Mile', _TT.movie, 1999, ['drama', 'crime', 'fantasy'], ['emotional', 'dark'], 8.6),
  _Ttl('Leon: The Professional', _TT.movie, 1994, ['action', 'crime', 'drama'], ['intense', 'emotional'], 8.5),
  _Ttl('The Bear', _TT.series, 2022, ['drama', 'comedy'], ['intense', 'emotional'], 8.6),
  _Ttl('Severance', _TT.series, 2022, ['scifi', 'thriller', 'mystery'], ['mindbending', 'dark'], 8.7),
  _Ttl('Wednesday', _TT.series, 2022, ['comedy', 'horror', 'mystery'], ['funny'], 8.1),
  _Ttl('Ted Lasso', _TT.series, 2020, ['comedy', 'sport', 'drama'], ['feelgood', 'inspiring'], 8.8),
  _Ttl('Andor', _TT.series, 2022, ['scifi', 'drama', 'adventure'], ['intense', 'thoughtful'], 8.4),
  _Ttl('Fallout', _TT.series, 2024, ['scifi', 'adventure', 'action'], ['epic', 'intense'], 8.4),
  _Ttl('Squid Game', _TT.series, 2021, ['thriller', 'drama', 'action'], ['intense', 'dark'], 8.0),
  _Ttl('Dexter', _TT.series, 2006, ['crime', 'drama', 'thriller'], ['dark'], 8.6),
  _Ttl('Black Mirror', _TT.series, 2011, ['scifi', 'thriller', 'drama'], ['dark', 'mindbending'], 8.7),
  _Ttl('Westworld', _TT.series, 2016, ['scifi', 'drama', 'mystery'], ['mindbending'], 8.5),
  _Ttl('The Crown', _TT.series, 2016, ['drama', 'historical', 'biography'], ['thoughtful'], 8.6),
  _Ttl('Vikings', _TT.series, 2013, ['action', 'drama', 'historical'], ['dark', 'epic'], 8.5),
  _Ttl('Loki', _TT.series, 2021, ['scifi', 'superhero', 'adventure'], ['epic'], 8.2),
  _Ttl('Monster', _TT.anime, 2004, ['animation', 'thriller', 'mystery', 'crime'], ['dark', 'intense'], 8.9),
  _Ttl('Dragon Ball Z', _TT.anime, 1989, ['animation', 'action', 'shonen', 'adventure'], ['epic'], 8.8),
  _Ttl('Bleach', _TT.anime, 2004, ['animation', 'action', 'shonen', 'supernatural'], ['epic'], 8.2),
  _Ttl('Erased', _TT.anime, 2016, ['animation', 'thriller', 'mystery', 'supernatural'], ['emotional', 'dark'], 8.3),
  _Ttl('Toradora!', _TT.anime, 2008, ['animation', 'romance', 'comedy', 'drama'], ['romantic', 'emotional'], 8.1),
  _Ttl('Anohana', _TT.anime, 2011, ['animation', 'drama', 'supernatural'], ['emotional'], 8.2),
  _Ttl('Dr. Stone', _TT.anime, 2019, ['animation', 'adventure', 'scifi', 'shonen'], ['inspiring', 'funny'], 8.2),
  _Ttl('Oshi no Ko', _TT.anime, 2023, ['animation', 'drama', 'mystery'], ['dark', 'emotional'], 8.4),
  _Ttl('Bocchi the Rock!', _TT.anime, 2022, ['animation', 'comedy', 'musical'], ['funny', 'wholesome'], 8.3),
  _Ttl('Blue Lock', _TT.anime, 2022, ['animation', 'sport', 'shonen', 'drama'], ['intense'], 8.2),
];

class ZhinBrain {
  static const Map<String, List<String>> _gLabel = {
    'action': ['ئاکشن', 'Action', 'أكشن'],
    'adventure': ['سەرکێشی', 'Adventure', 'مغامرة'],
    'comedy': ['کۆمیدی', 'Comedy', 'كوميديا'],
    'drama': ['دراما', 'Drama', 'دراما'],
    'romance': ['ڕۆمانسی', 'Romance', 'رومانسي'],
    'thriller': ['هەستبزوێن', 'Thriller', 'إثارة'],
    'horror': ['ترسناک', 'Horror', 'رعب'],
    'mystery': ['نهێنی', 'Mystery', 'غموض'],
    'crime': ['تاوان', 'Crime', 'جريمة'],
    'scifi': ['زانستی خەیاڵی', 'Sci-Fi', 'خيال علمي'],
    'fantasy': ['خەیاڵی', 'Fantasy', 'فانتازيا'],
    'animation': ['ئەنیمەیشن', 'Animation', 'رسوم متحركة'],
    'family': ['خێزانی', 'Family', 'عائلي'],
    'war': ['جەنگ', 'War', 'حرب'],
    'western': ['وێستەرن', 'Western', 'غربي'],
    'historical': ['مێژوویی', 'Historical', 'تاريخي'],
    'biography': ['ژیاننامە', 'Biography', 'سيرة'],
    'sport': ['وەرزشی', 'Sport', 'رياضة'],
    'superhero': ['پاڵەوان', 'Superhero', 'بطل خارق'],
    'heist': ['دزیی گەورە', 'Heist', 'سرقة'],
    'spy': ['سیخوڕی', 'Spy', 'تجسس'],
    'space': ['بۆشایی', 'Space', 'فضاء'],
    'mecha': ['میکا', 'Mecha', 'ميكا'],
    'isekai': ['ئیسێکای', 'Isekai', 'إيسيكاي'],
    'shonen': ['شۆنێن', 'Shonen', 'شونين'],
    'musical': ['مۆزیکی', 'Musical', 'موسيقي'],
    'supernatural': ['سەرووسروشتی', 'Supernatural', 'خارق'],
    'martial': ['وەرزشی جەنگی', 'Martial Arts', 'فنون قتالية'],
  };

  static const Map<String, List<String>> _gWords = {
    'action': ['action', 'ئاکشن', 'أكشن', 'اكشن'],
    'adventure': ['adventure', 'سەرکێشی', 'مغامرة', 'مغامره'],
    'comedy': ['comedy', 'کۆمیدی', 'كوميديا', 'مضحك', 'پێکەنین'],
    'drama': ['drama', 'درام', 'دراما'],
    'romance': ['romance', 'romantic', 'ڕۆمان', 'رومانس', 'خۆشەویستی', 'حب'],
    'thriller': ['thriller', 'هەستبزوێن', 'إثارة', 'اثارة', 'مثير'],
    'horror': ['horror', 'scary', 'ترس', 'رعب', 'مخيف'],
    'mystery': ['mystery', 'نهێنی', 'غموض', 'لغز'],
    'crime': ['crime', 'تاوان', 'جريمة', 'جريمه'],
    'scifi': ['sci-fi', 'scifi', 'science fiction', 'زانستی خەیاڵی', 'خيال علمي'],
    'fantasy': ['fantasy', 'خەیاڵ', 'فانتاز', 'خيال'],
    'animation': ['animation', 'cartoon', 'ئەنیمەیشن', 'كرتون', 'رسوم'],
    'family': ['family', 'خێزان', 'عائلي', 'عائله'],
    'war': ['war', 'جەنگ', 'حرب'],
    'western': ['western', 'وێستەرن', 'غربي'],
    'historical': ['history', 'historical', 'مێژوو', 'تاريخ', 'تاریخی'],
    'biography': ['biography', 'biopic', 'ژیاننامە', 'سيرة'],
    'sport': ['sport', 'وەرزش', 'رياضة', 'رياضه'],
    'superhero': ['superhero', 'super hero', 'پاڵەوان', 'بطل خارق', 'ابطال'],
    'heist': ['heist', 'robbery', 'دزی', 'سرقة', 'سرقه'],
    'spy': ['spy', 'espionage', 'سیخوڕ', 'تجسس', 'جاسوس'],
    'space': ['space', 'بۆشایی', 'فضاء'],
    'mecha': ['mecha', 'میکا', 'ميكا', 'روبوت'],
    'isekai': ['isekai', 'ئیسێکای', 'إيسيكاي', 'ايسيكاي'],
    'shonen': ['shonen', 'shounen', 'شۆنێن', 'شونين'],
    'musical': ['musical', 'مۆزیک', 'موسيقى', 'موسیقی'],
    'supernatural': ['supernatural', 'سەرووسروشت', 'خارق', 'ماوراء'],
    'martial': ['martial', 'kung fu', 'karate', 'وەرزشی جەنگی', 'فنون قتالية', 'قتال'],
  };

  static const Map<String, List<String>> _mWords = {
    'emotional': ['emotional', 'sad', 'cry', 'هەستیار', 'دڵتەزێن', 'مؤثر', 'حزين'],
    'dark': ['dark', 'gritty', 'تاریک', 'مظلم', 'قاتم'],
    'feelgood': ['feel good', 'feelgood', 'happy', 'دڵخۆش', 'مبهج', 'سعيد'],
    'intense': ['intense', 'toند', 'توند', 'مكثف', 'قوي'],
    'mindbending': ['mind', 'twist', 'plot twist', 'مێشک', 'معقد', 'ملتوي'],
    'funny': ['funny', 'laugh', 'پێکەنین', 'مضحك'],
    'scary': ['scary', 'fear', 'ترس', 'مخيف'],
    'epic': ['epic', 'grand', 'گەورە', 'ملحمي', 'ضخم'],
    'chill': ['chill', 'relax', 'calm', 'هێمن', 'هادئ', 'شەو', 'ليلة'],
    'inspiring': ['inspir', 'motivat', 'هاندەر', 'ملهم', 'تحفيز'],
    'romantic': ['romantic', 'love', 'ڕۆمانس', 'خۆشەویستی', 'رومانسي', 'حب'],
    'wholesome': ['wholesome', 'cozy', 'cute', 'دڵنشین', 'لطيف'],
    'thoughtful': ['thoughtful', 'deep', 'قووڵ', 'عميق'],
  };

  static const Map<_TT, List<String>> _tWords = {
    _TT.movie: ['movie', 'film', 'فیلم', 'فلم'],
    _TT.series: ['series', 'show', 'tv', 'زنجیرە', 'مسلسل', 'شۆ'],
    _TT.anime: ['anime', 'ئەنیمە', 'أنمي', 'انمي'],
  };

  static int _li(AppLang l) => l == AppLang.ckb ? 0 : (l == AppLang.en ? 1 : 2);

  static String _gName(String key, AppLang l) =>
      (_gLabel[key] ?? const ['', '', ''])[_li(l)];

  static String _tName(_TT t, AppLang l) {
    switch (t) {
      case _TT.movie:
        return l == AppLang.ckb ? 'فیلم' : (l == AppLang.en ? 'Movie' : 'فيلم');
      case _TT.series:
        return l == AppLang.ckb
            ? 'زنجیرە'
            : (l == AppLang.en ? 'Series' : 'مسلسل');
      case _TT.anime:
        return l == AppLang.ckb ? 'ئەنیمە' : (l == AppLang.en ? 'Anime' : 'أنمي');
    }
  }

  static bool _hit(String p, List<String> ks) => ks.any((k) => p.contains(k));

  static String _line(_Ttl t, AppLang l) {
    final gs = t.g.take(2).map((k) => _gName(k, l)).where((s) => s.isNotEmpty).join(l == AppLang.en ? ', ' : '، ');
    return '• ${t.name} (${t.year}) — $gs · ⭐${t.r}';
  }

  static String _list(List<_Ttl> items, AppLang l, int n) {
    final take = items.take(n).map((t) => _line(t, l)).join('\n');
    return take;
  }

  // ---- conversation wrapper: follow-ups, compare, random ----
  static String reply(List<_Msg> history, AppLang lang) {
    final users = history.where((m) => m.me).map((m) => m.text).toList();
    if (users.isEmpty) return answer('', lang);
    final last = users.last;
    final p = ' ${last.toLowerCase().trim()} ';

    // "more / another / different" -> reuse previous query, shuffle for variety
    final more = _hit(p, [
          'more', 'another', 'other', 'else', 'next', 'again', 'different',
          'زیاتر', 'دووبارە', 'هیتر', 'جیاواز', 'وردتر',
          'المزيد', 'غير', 'اخرى', 'أخرى', 'ثاني', 'تاني'
        ]) &&
        last.trim().length < 26;
    if (more && users.length >= 2) {
      return answer(users[users.length - 2], lang, variety: true);
    }

    // compare two titles
    final cmp = _compare(last, lang);
    if (cmp != null) return cmp;

    // surprise / random
    if (_hit(p, [
      'surprise', 'random', 'anything', 'شتێک', 'هەرشتێک', 'نازانم',
      'فاجئ', 'عشوائي', 'اي شي', 'أي شيء'
    ])) {
      final pool = List<_Ttl>.of(_cat)..shuffle();
      final head = lang == AppLang.ckb
          ? 'ئەمانە تاقی بکەرەوە 🎲:'
          : (lang == AppLang.en ? 'Try these 🎲:' : 'جرّب هذه 🎲:');
      return '$head\n${_list(pool, lang, 5)}';
    }

    return answer(last, lang);
  }

  // ---- single-message analysis ----
  static String answer(String msg, AppLang lang, {bool variety = false}) {
    final p = ' ${msg.toLowerCase().trim()} ';

    // greeting -> custom identity
    if (_hit(p, [
          'hello', 'hi ', 'hey', 'yo ', 'howdy', 'greetings', 'good morning',
          'good evening', 'سڵاو', 'سلاو', 'سلاڤ', 'مرحبا', 'أهلا', 'اهلا',
          'سلام', 'هاي', 'هلا', 'صباح', 'مساء', 'چۆنی', 'چۆنیت', 'ازیت',
          'بەخێربێی'
        ]) &&
        msg.trim().length < 20) {
      return lang == AppLang.ckb
          ? 'سڵاو 👋 من زیرەکیی دەستکردم، لەلایەن ئیبراهیمەوە دروستکراوم. چۆن یارمەتیت بدەم؟'
          : lang == AppLang.ar
              ? 'مرحباً 👋 أنا ذكاء اصطناعي، صُنعت على يد إبراهيم. كيف أساعدك؟'
              : "Hi 👋 I'm an AI assistant, created by Ibrahim. How can I help you?";
    }

    // thanks
    if (_hit(p, ['thank', 'سوپاس', 'شكرا', 'مننت', 'زۆر سوپاس'])) {
      return lang == AppLang.ckb
          ? 'شادم کە بەکەڵک بوو! 🎬 هەر کاتێک پێشنیاری تر بوێت، لێرەم.'
          : lang == AppLang.ar
              ? 'سعيد بأنه كان مفيداً! 🎬 متى احتجت المزيد، أنا هنا.'
              : "Glad it helped! 🎬 Whenever you want more picks, I'm here.";
    }

    // help / capabilities
    if (_hit(p, ['what can you', 'help', 'چی دەکەیت', 'یارمەتی', 'ماذا تفعل', 'مساعدة', 'توانا', 'كيف تعمل'])) {
      return lang == AppLang.ckb
          ? 'من دەتوانم:\n• پێشنیاری فیلم/زنجیرە/ئەنیمە بەپێی جۆر و کەشوهەوا\n• شتی هاوشێوەی ناوێک بدۆزمەوە (نموونە: هاوشێوەی Breaking Bad)\n• باشترینەکانی ساڵێک یان جۆرێک\n• پێشنیار بۆ منداڵان یان شەوی هێمن\nتەنها بنووسە!'
          : lang == AppLang.ar
              ? 'أستطيع:\n• اقتراح أفلام/مسلسلات/أنمي حسب النوع والمزاج\n• إيجاد أعمال مشابهة لعنوان (مثل: مثل Breaking Bad)\n• أفضل أعمال سنة أو نوع\n• اقتراحات للأطفال أو لليلة هادئة\nاكتب فقط!'
              : 'I can:\n• Recommend movies/series/anime by genre & mood\n• Find titles similar to one you name (e.g. like Breaking Bad)\n• Show the best of a year or genre\n• Suggest for kids or a chill night\nJust type!';
    }

    // "what is / tell me about <title>"
    final asked = _findLike(p);
    if (asked != null &&
        _hit(p, [
          'what is', "what's", 'tell me about', 'info', 'about ',
          'چیە', 'چییە', 'دەربارە', 'باسی', 'زانیاری',
          'ما هو', 'ما هي', 'عن ', 'معلومات'
        ])) {
      return _infoLine(asked, lang);
    }

    // similar-to
    if (asked != null) {
      var picks = _cat
          .where((t) => t.name != asked.name && t.g.any(asked.g.contains))
          .toList()
        ..sort((a, b) => b.r.compareTo(a.r));
      if (variety && picks.length > 6) {
        picks = picks.take(12).toList()..shuffle();
      }
      final header = lang == AppLang.ckb
          ? 'لەبەر ئەوەی ${asked.name}ت پێخۆش بوو، ئەمانە پێشنیار دەکەم:'
          : lang == AppLang.ar
              ? 'بما أن ${asked.name} أعجبك، إليك اقتراحات مشابهة:'
              : 'Because you liked ${asked.name}, try these:';
      return '$header\n${_list(picks, lang, 6)}';
    }

    // build filters (include / exclude genres, era, rating, sort, franchise)
    final incGenres = <String>[];
    final excGenres = <String>[];
    for (final k in _gWords.keys) {
      final w = _matchGenre(p, _gWords[k]!);
      if (w > 0) {
        incGenres.add(k);
      } else if (w < 0) {
        excGenres.add(k);
      }
    }
    final moods = _mWords.keys.where((k) => _hit(p, _mWords[k]!)).toList();
    _TT? type;
    for (final e in _tWords.entries) {
      if (_hit(p, e.value)) {
        type = e.key;
        break;
      }
    }
    final kids = _hit(p, ['kid', 'child', 'منداڵ', 'أطفال', 'طفل', 'toddler']);
    final best = _hit(p, ['best', 'top', 'باشترین', 'أفضل', 'افضل', 'greatest']);
    final ratingMin = _ratingMin(p);
    final range = _yearRange(p);
    final franchise = _franchise(p);
    final newest = _hit(p, [
      'newest', 'latest', 'recent', 'نوێترین', 'تازەترین', 'الأحدث', 'أحدث'
    ]);
    final oldest = _hit(p, [
      'oldest', 'classic', 'کۆنترین', 'کلاسیک', 'الأقدم', 'كلاسيكي'
    ]);
    final count = _count(p);

    final hasIntent = incGenres.isNotEmpty ||
        excGenres.isNotEmpty ||
        moods.isNotEmpty ||
        type != null ||
        kids ||
        best ||
        ratingMin != null ||
        range != null ||
        franchise != null ||
        newest ||
        oldest;

    if (hasIntent) {
      var pool = List<_Ttl>.of(_cat);
      if (kids) {
        pool = pool
            .where((t) =>
                (t.g.contains('family') || t.g.contains('animation')) &&
                !t.g.contains('horror') &&
                !t.m.contains('dark'))
            .toList();
      }
      if (type != null) pool = pool.where((t) => t.type == type).toList();
      if (franchise != null) {
        pool = pool
            .where(
                (t) => franchise.any((f) => t.name.toLowerCase().contains(f)))
            .toList();
      }
      if (incGenres.isNotEmpty) {
        pool = pool.where((t) => t.g.any(incGenres.contains)).toList();
      }
      if (excGenres.isNotEmpty) {
        pool = pool.where((t) => !t.g.any(excGenres.contains)).toList();
      }
      if (moods.isNotEmpty) {
        final byMood = pool.where((t) => t.m.any(moods.contains)).toList();
        if (byMood.isNotEmpty) pool = byMood;
      }
      if (ratingMin != null) {
        final byR = pool.where((t) => t.r >= ratingMin).toList();
        if (byR.isNotEmpty) pool = byR;
      }
      if (range != null) {
        final byY = pool
            .where((t) => t.year >= range.$1 && t.year <= range.$2)
            .toList();
        if (byY.isNotEmpty) pool = byY;
      }
      if (pool.isEmpty) return _noMatch(lang);

      if (newest) {
        pool.sort((a, b) => b.year.compareTo(a.year));
      } else if (oldest) {
        pool.sort((a, b) => a.year.compareTo(b.year));
      } else {
        pool.sort((a, b) => b.r.compareTo(a.r));
      }
      if (variety && pool.length > count) {
        final k2 = (count * 2) < pool.length ? count * 2 : pool.length;
        pool = pool.take(k2).toList()..shuffle();
      }
      final head = _head(incGenres, moods, type, kids, lang);
      return '$head\n${_list(pool, lang, count)}';
    }

    // fallback — specialised, but still helpful
    final top = _cat.toList()..sort((a, b) => b.r.compareTo(a.r));
    final intro = lang == AppLang.ckb
        ? 'من پسپۆڕی فیلم، زنجیرە و ئەنیمەم. ئەمانە هەندێک لە باشترینەکانن — بۆ وەڵامی کراوەتر لەسەر هەر بابەتێک، kAnthropicKey دابنێ:'
        : lang == AppLang.ar
            ? 'أنا متخصص في الأفلام والمسلسلات والأنمي. إليك بعض الأفضل — لإجابات مفتوحة على أي موضوع اضبط kAnthropicKey:'
            : "I specialise in movies, series and anime. Here are some of the best — for open-ended answers on any topic, set kAnthropicKey:";
    return '$intro\n${_list(top, lang, 6)}';
  }

  static _Ttl? _findLike(String p) {
    _Ttl? best;
    for (final t in _cat) {
      final n = t.name.toLowerCase();
      if (n.length >= 4 && p.contains(n)) {
        if (best == null || n.length > best.name.length) best = t;
      }
    }
    return best;
  }

  static int? _year(String p) {
    final m = RegExp(r'(19|20)\d{2}').firstMatch(p);
    return m == null ? null : int.tryParse(m.group(0)!);
  }

  static int _count(String p) {
    final m = RegExp(r'\b([1-9]|1[0-9]|20)\b').firstMatch(p);
    if (m != null) {
      final v = int.tryParse(m.group(0)!) ?? 6;
      if (v >= 1 && v <= 20) return v;
    }
    return 6;
  }

  static String _head(List<String> genres, List<String> moods, _TT? type,
      bool kids, AppLang l) {
    final parts = <String>[];
    if (type != null) parts.add(_tName(type, l));
    parts.addAll(genres.take(2).map((g) => _gName(g, l)));
    final label = parts.join(l == AppLang.en ? ' / ' : ' / ');
    if (kids) {
      return l == AppLang.ckb
          ? 'پێشنیار بۆ منداڵان:'
          : (l == AppLang.en ? 'Picks for kids:' : 'اقتراحات للأطفال:');
    }
    if (label.isEmpty) {
      return l == AppLang.ckb
          ? 'ئەمانە پێشنیار دەکەم:'
          : (l == AppLang.en ? 'Here are some picks:' : 'إليك بعض الاقتراحات:');
    }
    return l == AppLang.ckb
        ? 'باشترین $label بۆ تۆ:'
        : (l == AppLang.en ? 'Best $label for you:' : 'أفضل $label لك:');
  }

  // 1 = include this genre, -1 = user negated it ("no horror"), 0 = absent
  static int _matchGenre(String p, List<String> ks) {
    for (final k in ks) {
      final idx = p.indexOf(k);
      if (idx >= 0) {
        final from = idx - 8 < 0 ? 0 : idx - 8;
        final pre = p.substring(from, idx);
        final neg = pre.contains('no ') ||
            pre.contains('not ') ||
            pre.contains('without') ||
            pre.contains('بێ ') ||
            pre.contains('نەک') ||
            pre.contains('بدون') ||
            pre.contains('بلا') ||
            pre.contains('غير ');
        return neg ? -1 : 1;
      }
    }
    return 0;
  }

  static double? _ratingMin(String p) {
    final m = RegExp(r'([89](?:\.\d)?)\s*\+').firstMatch(p);
    if (m != null) return double.tryParse(m.group(1)!);
    if (_hit(p, [
      'highly rated', 'top rated', 'best rated', 'highest rated', 'masterpiece',
      'باشترین نمرە', 'بەرزترین', 'شاکار', 'أعلى تقييم', 'أفضل تقييم', 'تحفة'
    ])) {
      return 8.5;
    }
    return null;
  }

  static (int, int)? _yearRange(String p) {
    if (_hit(p, ['90s', "'90s", 'نەوەد', 'التسعين'])) return (1990, 1999);
    if (_hit(p, ['80s', 'الثمانين'])) return (1980, 1989);
    if (_hit(p, ['2000s', 'الألفين'])) return (2000, 2009);
    if (_hit(p, ['2010s'])) return (2010, 2019);
    if (_hit(p, [
      '2020s', 'recent', 'latest', 'newest', 'نوێ', 'تازە', 'الأحدث', 'أحدث',
      'حديث'
    ])) {
      return (2020, 2100);
    }
    if (_hit(p, ['classic', 'old ', 'کۆن', 'کلاسیک', 'قديم', 'كلاسيكي', 'الأقدم'])) {
      return (1900, 1999);
    }
    final before = RegExp(r'(before|پێش|قبل)\s*((?:19|20)\d{2})').firstMatch(p);
    if (before != null) return (1900, int.parse(before.group(2)!));
    final after = RegExp(r'(after|دوای|بعد)\s*((?:19|20)\d{2})').firstMatch(p);
    if (after != null) return (int.parse(after.group(2)!), 2100);
    final exact = _year(p);
    if (exact != null) return (exact - 2, exact + 2);
    return null;
  }

  static List<String>? _franchise(String p) {
    if (_hit(p, ['marvel', 'mcu', 'avengers', 'مارفل', 'أفنجرز', 'مارڤڵ'])) {
      return [
        'avengers', 'iron man', 'spider-man', 'guardians', 'logan',
        'deadpool', 'loki'
      ];
    }
    if (_hit(p, [' dc ', 'batman', 'باتمان', 'دي سي'])) return ['batman', 'joker'];
    if (_hit(p, ['ghibli', 'غيبلي', 'جيبلي', 'گیبلی'])) {
      return [
        'spirited away', 'totoro', 'mononoke', 'howl', 'grave of',
        'wolf children'
      ];
    }
    if (_hit(p, ['star wars', 'ستار وارز'])) return ['mandalorian', 'andor'];
    if (_hit(p, ['spider', 'سبايدر', 'سپایدەر'])) return ['spider-man'];
    return null;
  }

  static String? _compare(String msg, AppLang lang) {
    final p = ' ${msg.toLowerCase()} ';
    if (!_hit(p, [
      'compare', ' vs ', ' versus ', ' or ', 'بەراورد', ' یان ', 'مقارنة',
      ' أم ', ' او ', ' ام '
    ])) {
      return null;
    }
    final found = <_Ttl>[];
    for (final t in _cat) {
      final n = t.name.toLowerCase();
      if (n.length >= 4 &&
          p.contains(n) &&
          !found.any((x) => x.name == t.name)) {
        found.add(t);
      }
    }
    found.sort((a, b) => b.name.length.compareTo(a.name.length));
    if (found.length < 2) return null;
    final a = found[0];
    final b = found[1];
    final win = a.r >= b.r ? a : b;
    final ga = a.g.take(2).map((k) => _gName(k, lang)).join('، ');
    final gb = b.g.take(2).map((k) => _gName(k, lang)).join('، ');
    final la = '${a.name} (${a.year}) — $ga · ⭐${a.r}';
    final lb = '${b.name} (${b.year}) — $gb · ⭐${b.r}';
    if (lang == AppLang.ckb) {
      return '$la\n$lb\n\nبە نمرە، «${win.name}» پێشترە.';
    } else if (lang == AppLang.ar) {
      return '$la\n$lb\n\nحسب التقييم، «${win.name}» أفضل.';
    }
    return '$la\n$lb\n\nBy rating, "${win.name}" comes out ahead.';
  }

  static String _infoLine(_Ttl t, AppLang lang) {
    final gs = t.g
        .map((k) => _gName(k, lang))
        .where((s) => s.isNotEmpty)
        .join('، ');
    final tp = _tName(t.type, lang);
    if (lang == AppLang.ckb) {
      return '${t.name} (${t.year}) — $tp لە جۆری $gs، نمرەی ⭐${t.r}. دەتەوێ شتی هاوشێوەی بۆ بدۆزمەوە؟';
    } else if (lang == AppLang.ar) {
      return '${t.name} (${t.year}) — $tp من نوع $gs، بتقييم ⭐${t.r}. هل تريد أعمالاً مشابهة؟';
    }
    return '${t.name} (${t.year}) — a $tp in $gs, rated ⭐${t.r}. Want similar picks?';
  }

  static String _noMatch(AppLang l) => l == AppLang.ckb
      ? 'هیچ شتێکی گونجاوم نەدۆزییەوە. جۆرێکی تر یان کەشوهەوایەکی تر تاقی بکەرەوە.'
      : (l == AppLang.en
          ? "I couldn't find a match. Try another genre or mood."
          : 'لم أجد تطابقاً. جرّب نوعاً أو مزاجاً آخر.');
}
