import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';

class RejectReasonBottomSheet extends StatefulWidget {
  final Function(String reason) onConfirm;

  const RejectReasonBottomSheet({super.key, required this.onConfirm});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.xxl),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: RejectReasonBottomSheet(
            onConfirm: (reason) => Navigator.pop(context, reason),
          ),
        ),
      ),
    );
  }

  @override
  State<RejectReasonBottomSheet> createState() =>
      _RejectReasonBottomSheetState();
}

class _RejectReasonBottomSheetState extends State<RejectReasonBottomSheet> {
  String? selectedPreset;
  final TextEditingController _controller = TextEditingController();

  final List<String> presets = [
    'Incomplete instructions',
    'Low-quality or improper image',
    'Duplicate recipe',
    'Inaccurate nutrition / ingredients',
  ];

  String get finalReason {
    if (selectedPreset != null) return selectedPreset!;
    return _controller.text.trim();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.dialog,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: AppSizes.imageSmall,
              height: AppSizes.xs,
              margin: AppInsets.vSm,
              decoration: const BoxDecoration(
                color: AppColors.divider,
                borderRadius: AppRadius.pill,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.sm),

          // Header
          const Text(
            'Reason for Rejection',
            style: TextStyle(
              fontSize: AppSizes.xl,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          const Text(
            'Select a quick reason or type custom feedback for the creator.',
            style: TextStyle(
              fontSize: AppSizes.md,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // Quick Reason Chips
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: presets.map((preset) {
              final isSelected = selectedPreset == preset;
              return ChoiceChip(
                label: Text(
                  preset,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.medium,
                ),
                padding: AppInsets.hSm,
                onSelected: (selected) {
                  setState(() {
                    selectedPreset = selected ? preset : null;
                    if (selected) _controller.clear();
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppSizes.lg),

          // Custom Reason Input
          TextField(
            controller: _controller,
            maxLines: 3,
            cursorColor: AppColors.primary,
            decoration: const InputDecoration(
              hintText: 'Additional details (optional)...',
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: AppInsets.md,
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.medium,
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.medium,
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            onChanged: (val) {
              if (val.isNotEmpty && selectedPreset != null) {
                setState(() => selectedPreset = null);
              } else {
                setState(() {});
              }
            },
          ),

          const SizedBox(height: AppSizes.xl),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: AppInsets.button,
                    side: const BorderSide(color: AppColors.divider),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: AppSizes.lg,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.error,
                    disabledBackgroundColor: AppColors.error.withOpacity(0.4),
                    padding: AppInsets.button,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                  onPressed: finalReason.isNotEmpty
                      ? () => widget.onConfirm(finalReason)
                      : null,
                  child: const Text(
                    'Reject Recipe',
                    style: TextStyle(
                      fontSize: AppSizes.lg,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}