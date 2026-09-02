import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/dashed_border.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/section_header.dart';
import 'package:quick_bite/features/favorite/presentation/providers/providers.dart';
import 'package:quick_bite/features/home/data/models/recipe_model.dart';
import 'package:quick_bite/features/home/presentation/provider/providers.dart';

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

class RecipeTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const RecipeTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD4E0F2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servingsController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();

  // Recipe data
  String? _selectedDifficulty = 'Easy';
  String? _selectedCuisine;
  String? _selectedMealType;
  bool _isSaving = false;

  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];

  final List<TextEditingController> _instructionControllers = [
    TextEditingController(),
  ];

  final List<String> _selectedTags = [];

  final List<String> _cuisines = [
    'Italian',
    'Indian',
    'Mexican',
    'Chinese',
    'Japanese',
    'American',
    'Mediterranean',
    'Other',
  ];

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Dessert',
  ];

  final List<String> _availableTags = [
    'Pizza',
    'Healthy',
    'Quick',
    'Vegetarian',
    'Vegan',
    'Italian',
    'Spicy',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _servingsController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();

    for (final controller in _ingredientControllers) {
      controller.dispose();
    }

    for (final controller in _instructionControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length == 1) return;

    _ingredientControllers[index].dispose();
    setState(() {
      _ingredientControllers.removeAt(index);
    });
  }

  void _addInstruction() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    if (_instructionControllers.length == 1) return;

    _instructionControllers[index].dispose();
    setState(() {
      _instructionControllers.removeAt(index);
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _servingsController.clear();
    _prepTimeController.clear();
    _cookTimeController.clear();

    for (final c in _ingredientControllers) {
      c.dispose();
    }
    for (final c in _instructionControllers) {
      c.dispose();
    }

    setState(() {
      _ingredientControllers.clear();
      _ingredientControllers.add(TextEditingController());
      _instructionControllers.clear();
      _instructionControllers.add(TextEditingController());
      _selectedTags.clear();
      _selectedDifficulty = 'Easy';
      _selectedCuisine = null;
      _selectedMealType = null;
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((v) => v.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    final instructions = _instructionControllers
        .map((c) => c.text.trim())
        .where((v) => v.isNotEmpty)
        .toList();

    if (instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one instruction step')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final recipeModel = RecipeModel(
        id: DateTime.now().millisecondsSinceEpoch % 1000000,
        name: _nameController.text.trim(),
        ingredients: ingredients,
        instructions: instructions,
        prepTimeMinutes: int.tryParse(_prepTimeController.text) ?? 10,
        cookTimeMinutes: int.tryParse(_cookTimeController.text) ?? 20,
        servings: int.tryParse(_servingsController.text) ?? 2,
        difficulty: _selectedDifficulty ?? 'Easy',
        cuisine: _selectedCuisine ?? 'Other',
        tags: _selectedTags.isNotEmpty ? _selectedTags : ['Homemade'],
        image: 'https://cdn.dummyjson.com/recipe-images/1.webp',
        rating: 5.0,
        reviewCount: 1,
        mealType: _selectedMealType != null ? [_selectedMealType!] : ['Dinner'],
      );

      // Save to SQLite Favorites/Saved recipes
      await ref.read(recipeLocalDataSourceProvider).addFavorite(recipeModel);
      ref.invalidate(favoriteNotifierProvider);
      ref.invalidate(recipeProvider);

      if (mounted) {
        _resetForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            content: const Text(
              '🎉 Recipe saved successfully to your collection!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Failed to save recipe: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverPadding(
                    padding: AppInsets.hXl,
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _buildCoverPhoto(),
                          AppSpacing.vLg,
                          _buildRecipeName(),
                          AppSpacing.vLg,
                          _buildDescription(),
                          AppSpacing.vLg,
                          _buildDifficulty(),
                          AppSpacing.vLg,
                          _buildServings(),
                          AppSpacing.vLg,
                          _buildCookingTime(),
                          AppSpacing.vLg,
                          _buildCuisine(),
                          AppSpacing.vLg,
                          _buildMealType(),
                          AppSpacing.vLg,
                          _buildIngredients(),
                          AppSpacing.vLg,
                          _buildInstructions(),
                          AppSpacing.vLg,
                          _buildTags(),
                          AppSpacing.vXl,
                          _buildAddButton(),
                          AppSpacing.vXl,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: const Text(
        'Create Recipe',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetForm,
          child: const Text(
            'Reset',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverPhoto() {
    return DashedBorder(
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              size: 44,
              color: AppColors.primary,
            ),
            AppSpacing.vSm,
            Text(
              'Add Recipe Photo',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            AppSpacing.vXs,
            Text(
              'Supports PNG, JPG up to 10MB',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Recipe Name'),
        AppSpacing.vSm,
        RecipeTextField(
          controller: _nameController,
          hintText: 'e.g. Classic Margherita Pizza',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Recipe name is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Description'),
        AppSpacing.vSm,
        RecipeTextField(
          controller: _descriptionController,
          hintText: 'Tell a little about your recipe...',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDifficulty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Difficulty'),
        AppSpacing.vSm,
        DifficultySelector(
          selectedDifficulty: _selectedDifficulty,
          onChanged: (value) {
            setState(() {
              _selectedDifficulty = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildServings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Servings'),
        AppSpacing.vSm,
        RecipeTextField(
          controller: _servingsController,
          hintText: 'e.g. 4',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.people_outline),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter servings';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCookingTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Cooking Time'),
        AppSpacing.vSm,
        Row(
          children: [
            Expanded(
              child: RecipeTextField(
                controller: _prepTimeController,
                hintText: 'Prep time',
                keyboardType: TextInputType.number,
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(widthFactor: 1, child: Text('min')),
                ),
              ),
            ),
            AppSpacing.hSm,
            Expanded(
              child: RecipeTextField(
                controller: _cookTimeController,
                hintText: 'Cook time',
                keyboardType: TextInputType.number,
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Center(widthFactor: 1, child: Text('min')),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCuisine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Cuisine'),
        AppSpacing.vSm,
        DropdownButtonFormField<String>(
          initialValue: _selectedCuisine,
          decoration: _dropdownDecoration(hintText: 'Select cuisine'),
          items: _cuisines.map((cuisine) {
            return DropdownMenuItem(
              value: cuisine,
              child: Text(cuisine),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCuisine = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMealType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Meal Type'),
        AppSpacing.vSm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _mealTypes.map((mealType) {
            final selected = _selectedMealType == mealType;

            return ChoiceChip(
              label: Text(mealType),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) {
                setState(() {
                  _selectedMealType = mealType;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: selected ? AppColors.primary : const Color(0xFFD4E0F2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Ingredients'),
        AppSpacing.vSm,
        ...List.generate(
          _ingredientControllers.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RecipeTextField(
                controller: _ingredientControllers[index],
                hintText: 'e.g. 2 cups flour',
                suffixIcon: IconButton(
                  onPressed: () => _removeIngredient(index),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: _addIngredient,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add ingredient'),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Instructions'),
        AppSpacing.vSm,
        ...List.generate(
          _instructionControllers.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  AppSpacing.hSm,
                  Expanded(
                    child: RecipeTextField(
                      controller: _instructionControllers[index],
                      hintText: 'Describe step ${index + 1}...',
                      maxLines: 3,
                      suffixIcon: IconButton(
                        onPressed: () => _removeInstruction(index),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: _addInstruction,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add instruction step'),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader.name(header: 'Tags'),
        AppSpacing.vSm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final selected = _selectedTags.contains(tag);

            return FilterChip(
              label: Text(tag),
              selected: selected,
              showCheckmark: false,
              onSelected: (_) => _toggleTag(tag),
              selectedColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: selected ? AppColors.primary : const Color(0xFFD4E0F2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveRecipe,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save Recipe',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  InputDecoration _dropdownDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD4E0F2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}