import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';

class SubmissionCard extends StatelessWidget {
  final Recipe submission;
  final VoidCallback onEditPressed;

  const SubmissionCard({
    super.key,
    required this.submission,
    required this.onEditPressed,
  });

  Color _getStatusColor() {
    switch (submission.status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   submission.status.toUpperCase(),
              //   style: AppTextStyles.bodySmall.copyWith(
              //     color: AppColors.textSecondary,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: 1.1,
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  submission.status[0].toUpperCase() +
                      submission.status.substring(1),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vXs,

          // Recipe Title
          Text(
            submission.name ?? '',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.vXs,

          // Info Row: Prep Time & Submission Date
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                submission.prepTimeMinutes.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              // const SizedBox(width: 16),
              // const Icon(
              //   Icons.calendar_today_rounded,
              //   size: 14,
              //   color: AppColors.textSecondary,
              // ),

              // const SizedBox(width: 4),
              // Text(
              //   // ' submission data missing...',
              //   submission.,
              //   style: AppTextStyles.bodySmall.copyWith(
              //     color: AppColors.textSecondary,
              //   ),
              // ),
            ],
          ),

          // Rejection Box & Edit Action Button (Only if Rejected)
          if (submission.status == 'rejected') ...[
            AppSpacing.vSm,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rejection Reason:',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    submission.rejectionReason ?? 'No reason provided.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vSm,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onEditPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Edit & Resubmit',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
