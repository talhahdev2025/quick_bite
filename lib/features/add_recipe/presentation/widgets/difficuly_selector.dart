
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quick_bite/core/constants/app_colors.dart';

class DifficultySelector extends StatelessWidget {
  final String? selectedDifficulty;
  final ValueChanged<String> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  static const difficulties = [
    'Easy',
    'Medium',
    'Hard',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: difficulties.map((difficulty) {
        final isSelected = selectedDifficulty == difficulty;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: difficulty != difficulties.last ? 8 : 0,
            ),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  difficulty,
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                onChanged(difficulty);
              },
              showCheckmark: false,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );
      }).toList(),
    );
  }
}