import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subzero/common/constant/app_image.dart';
import 'package:subzero/common/widgets/k_text.dart';
import 'package:subzero/core/app_routers/app_routers.dart';
import 'package:subzero/core/app_routers/app_routers.gr.dart';
import 'package:subzero/core/injection/injection_service.dart';
import 'package:subzero/core/services/firebase/auth_firebase_service.dart';
import 'package:subzero/core/services/toast/toast_service.dart';

@RoutePage()
class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  bool _isDeleting = false;

  Future<void> _showDeleteConfirmation() async {
    if (_isDeleting) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: KText(
            text: 'Delete account?',
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          content: KText(
            text:
                'This will permanently delete your account, subscriptions, '
                'notifications, and other associated data. This action cannot '
                'be undone.',
            fontSize: 14.sp,
            color: Colors.grey.shade600,
            maxLines: 6,
          ),
          actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: KText(
                text: 'Cancel',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD93025),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: KText(
                  text: 'Delete',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    await _deleteAccount();
  }

  Future<void> _deleteAccount() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      debugPrint('🗑️ Starting account deletion...');

      final success = await locator<AuthFirebaseService>().deleteAccount();

      if (!mounted) return;

      if (!success) {
        debugPrint('❌ Account deletion returned false');

        setState(() {
          _isDeleting = false;
        });

        return;
      }

      debugPrint('✅ Account deleted successfully');

      locator<AppRouters>().pushAndPopUntil(
        const AuthGateView(),
        predicate: (_) => false,
      );
    } catch (error) {
      debugPrint('❌ Delete account failed: $error');

      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      locator<ToastService>().i(
        'Unable to delete your account. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _isDeleting
              ? null
              : () => locator<AppRouters>().popForced(),
        ),
        title: KText(
          text: 'Delete account',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildWarningIcon(),

              SizedBox(height: 24.h),

              KText(
                text: 'Delete your SubZero account?',
                fontSize: 27.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.8,
              ),

              SizedBox(height: 12.h),

              KText(
                text:
                    'Deleting your account permanently removes your '
                    'SubZero account and the data associated with it.',
                fontSize: 15.sp,
                color: Colors.grey.shade600,
                maxLines: 5,
              ),

              SizedBox(height: 30.h),

              _buildInformationCard(),

              const Spacer(),

              KText(
                text:
                    'This action cannot be undone. Your account cannot '
                    'be recovered after deletion.',
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningIcon() {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFEF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0).dg,
        child: Image.asset(AppImage.deleteIcon, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            title: 'Your account',
            subtitle: 'Your SubZero account will be permanently deleted.',
          ),
          SizedBox(height: 18.h),
          _buildInfoRow(
            icon: Icons.subscriptions_outlined,
            title: 'Subscriptions',
            subtitle:
                'All subscriptions stored in your account will be removed.',
          ),
          SizedBox(height: 18.h),
          _buildInfoRow(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Your notification data will also be deleted.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(icon, size: 21.sp, color: Colors.black),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: title,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              SizedBox(height: 3.h),
              KText(
                text: subtitle,
                textAlign: TextAlign.start,
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: _isDeleting ? null : _showDeleteConfirmation,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD93025),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xFFD93025,
          ).withValues(alpha: 0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _isDeleting
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_forever_rounded, size: 21.sp),
                  SizedBox(width: 8.w),
                  KText(
                    text: 'Delete Account Permanently',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
