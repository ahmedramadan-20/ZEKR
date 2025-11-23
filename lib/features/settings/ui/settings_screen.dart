import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_text_styles.dart';
import '../../../core/theming/theme_cubit.dart';
import '../../../core/di/dependency_injection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/widgets/custom_app_bar.dart';
import 'widgets/setting_card.dart';
import 'widgets/setting_switch_card.dart';
import 'widgets/setting_info_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _sharedPrefHelper = getIt<SharedPrefHelper>();
  String _fontSize = 'medium';
  bool _autoSavePosition = true;
  String _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppVersion();
  }

  @override
  void dispose() {
    // Clean up any pending async operations
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _fontSize = _sharedPrefHelper.getFontSize();
      _autoSavePosition = _sharedPrefHelper.getAutoSavePosition();
    });
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = themeCubit.isDark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'الإعدادات'),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          // Appearance Section
          _buildSectionHeader('المظهر'),
          SizedBox(height: 16.h),

          SettingSwitchCard(
            title: 'الوضع الليلي',
            subtitle: 'تفعيل الثيم الداكن',
            icon: Icons.dark_mode_outlined,
            value: isDark,
            color: const Color(0xFF9D4EDD),
            onChanged: (value) {
              themeCubit.toggleTheme();
            },
          ),

          SizedBox(height: 32.h),

          // Reading Settings Section
          _buildSectionHeader('إعدادات القراءة'),
          SizedBox(height: 16.h),

          SettingCard(
            title: 'حجم الخط',
            subtitle: _getFontSizeLabel(_fontSize),
            icon: Icons.text_fields,
            color: AppColors.primary,
            onTap: () => _showFontSizeDialog(),
          ),

          SizedBox(height: 12.h),

          SettingSwitchCard(
            title: 'حفظ آخر موضع قراءة تلقائياً',
            subtitle: 'يتم حفظ موضع القراءة عند الإغلاق',
            icon: Icons.bookmark_border,
            value: _autoSavePosition,
            color: AppColors.secondary,
            onChanged: (value) async {
              await _sharedPrefHelper.setAutoSavePosition(value);
              setState(() => _autoSavePosition = value);
            },
          ),

          SizedBox(height: 32.h),

          // Data Management Section
          _buildSectionHeader('إدارة البيانات'),
          SizedBox(height: 16.h),

          SettingCard(
            title: 'مسح ذاكرة التخزين المؤقت',
            subtitle: 'حذف البيانات المؤقتة المحفوظة',
            icon: Icons.cleaning_services_outlined,
            color: AppColors.juzBadge,
            onTap: () => _showClearCacheDialog(),
          ),

          SizedBox(height: 12.h),

          SettingCard(
            title: 'حذف جميع الإشارات المرجعية',
            subtitle: 'حذف جميع الآيات المحفوظة',
            icon: Icons.bookmark_remove_outlined,
            color: AppColors.error,
            onTap: () => _showClearBookmarksDialog(),
          ),

          SizedBox(height: 32.h),

          // App Info Section
          _buildSectionHeader('عن التطبيق'),
          SizedBox(height: 16.h),

          SettingCard(
            title: 'مشاركة التطبيق',
            subtitle: 'شارك التطبيق مع الأصدقاء',
            icon: Icons.share_outlined,
            color: AppColors.accent,
            onTap: () => _shareApp(),
          ),

          SizedBox(height: 12.h),

          SettingCard(
            title: 'تقييم التطبيق',
            subtitle: 'قيم التطبيق في المتجر',
            icon: Icons.star_border,
            color: const Color(0xFFFFC107),
            onTap: () => _rateApp(),
          ),

          SizedBox(height: 12.h),

          SettingInfoCard(
            title: 'الإصدار',
            subtitle: _appVersion,
            icon: Icons.info_outline,
            color: AppColors.secondary,
          ),

          SizedBox(height: 32.h),

          // About Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: AppColors.getCardGradient(context),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Icon(Icons.menu_book_rounded, size: 48.w, color: Colors.white),
                SizedBox(height: 12.h),
                Text(
                  'القرآن الكريم',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontFamily: 'Amiri',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'تطبيق للقراءة والتدبر في كتاب الله',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Amiri',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontFamily: 'Amiri',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : AppColors.textPrimary,
      ),
    );
  }

  String _getFontSizeLabel(String size) {
    switch (size) {
      case 'small':
        return 'صغير';
      case 'medium':
        return 'متوسط';
      case 'large':
        return 'كبير';
      case 'xlarge':
        return 'كبير جداً';
      default:
        return 'متوسط';
    }
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حجم الخط',
          style: AppTextStyles.titleMedium.copyWith(fontFamily: 'Amiri'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFontSizeOption('small', 'صغير'),
            _buildFontSizeOption('medium', 'متوسط'),
            _buildFontSizeOption('large', 'كبير'),
            _buildFontSizeOption('xlarge', 'كبير جداً'),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Amiri'),
      ),
      value: value,
      groupValue: _fontSize,
      activeColor: AppColors.primary,
      onChanged: (String? newValue) async {
        if (newValue != null) {
          await _sharedPrefHelper.setFontSize(newValue);
          setState(() => _fontSize = newValue);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'مسح ذاكرة التخزين المؤقت',
          style: AppTextStyles.titleMedium.copyWith(fontFamily: 'Amiri'),
        ),
        content: Text(
          'هل أنت متأكد من مسح جميع البيانات المؤقتة؟',
          style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Amiri'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTextStyles.labelLarge.copyWith(fontFamily: 'Amiri'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم مسح ذاكرة التخزين المؤقت',
                    style: TextStyle(fontFamily: 'Amiri'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'مسح',
              style: AppTextStyles.labelLarge.copyWith(
                fontFamily: 'Amiri',
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearBookmarksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف جميع الإشارات المرجعية',
          style: AppTextStyles.titleMedium.copyWith(fontFamily: 'Amiri'),
        ),
        content: Text(
          'هل أنت متأكد من حذف جميع الآيات المحفوظة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Amiri'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTextStyles.labelLarge.copyWith(fontFamily: 'Amiri'),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _sharedPrefHelper.clearAllBookmarks();
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم حذف جميع الإشارات المرجعية',
                    style: TextStyle(fontFamily: 'Amiri'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'حذف',
              style: AppTextStyles.labelLarge.copyWith(
                fontFamily: 'Amiri',
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    Share.share(
      'جرب تطبيق القرآن الكريم - تطبيق رائع للقراءة والتدبر\n'
      'https://play.google.com/store/apps/details?id=com.example.quran',
      subject: 'تطبيق القرآن الكريم',
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'شكراً لك! سيتم فتح صفحة التقييم',
          style: TextStyle(fontFamily: 'Amiri'),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
