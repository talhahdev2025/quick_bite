import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/dashed_border.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/difficuly_selector.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/recipe_text_field.dart';
import 'package:quick_bite/features/add_recipe/presentation/widgets/section_header.dart';
import 'package:quick_bite/features/login/presentation/providers/auth_notifier.dart';
import 'package:quick_bite/features/recipe/domain/recipe.dart';
import 'package:quick_bite/features/recipe/presentation/providers/recipe_providers.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key, this.recipe});
  final Recipe? recipe;

  bool get isEditMode => recipe != null;

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  // final _descriptionController = TextEditingController();
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

  File? _selectedImage;
  bool _isImageRemoved = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                context.pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                context.pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;

    if (recipe != null) {
      _nameController.text = recipe.name ?? '';
      _servingsController.text = recipe.servings?.toString() ?? '';
      _prepTimeController.text = recipe.prepTimeMinutes?.toString() ?? '';
      _cookTimeController.text = recipe.cookTimeMinutes?.toString() ?? '';
      _selectedDifficulty = recipe.difficulty;
      _selectedCuisine = _cuisines.contains(recipe.cuisine)
          ? recipe.cuisine
          : null;
      _selectedMealType = recipe.mealType?.first;

      // recipe tags
      if (recipe.tags != null && recipe.tags!.isNotEmpty) {
        _selectedTags.addAll(recipe.tags!);
      }

      //recipe ingredients
      if (recipe.ingredients != null && recipe.ingredients!.isNotEmpty) {
        _ingredientControllers.clear();
        for (final ingredient in recipe.ingredients!) {
          _ingredientControllers.add(TextEditingController(text: ingredient));
        }
      }

      //recipe instructions
      if (recipe.instructions != null && recipe.instructions!.isNotEmpty) {
        _instructionControllers.clear();
        for (final instruction in recipe.instructions!) {
          _instructionControllers.add(TextEditingController(text: instruction));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _descriptionController.dispose();
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

    final controller = _ingredientControllers.removeAt(index);
    setState(() {});
    controller.dispose();
  }

  void _addInstruction() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstruction(int index) {
    if (_instructionControllers.length == 1) return;

    final controller = _instructionControllers.removeAt(index);
    setState(() {});
    controller.dispose();
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
    // _descriptionController.clear();
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

    if (!widget.isEditMode && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo for the recipe')),
      );
      return;
    }
    final user = ref.read(authProvider).user;
    final userId = user?.uid;
    if (user == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User session expired. Please log in again.'),
        ),
      );
      return;
    }

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one ingredient')),
      );
      return;
    }

    final instructions = _instructionControllers
        .map((c) => c.text.trim())
        .toList();

    if (instructions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one instruction step'),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isSaving = true);

    try {
      String? imageUrl = widget.recipe?.image;
      if (_selectedImage != null) {
        imageUrl = await ref
            .read(recipeRepositoryProvider)
            .uploadRecipeImage(imageFile: _selectedImage!, userId: userId);
      }
      final recipe = Recipe(
        id: widget.isEditMode ? widget.recipe?.id : null,
        name: _nameController.text.trim(),
        ingredients: ingredients,
        instructions: instructions,
        prepTimeMinutes: int.tryParse(_prepTimeController.text) ?? 10,
        cookTimeMinutes: int.tryParse(_cookTimeController.text) ?? 20,
        servings: int.tryParse(_servingsController.text) ?? 2,
        difficulty: _selectedDifficulty ?? 'Easy',
        cuisine: _selectedCuisine ?? 'Other',
        tags: _selectedTags.isNotEmpty ? _selectedTags : ['Homemade'],
        image: imageUrl,
        rating: widget.recipe?.rating ?? 0.0,
        reviewCount: widget.recipe?.reviewCount ?? 0,
        status: 'pending',
        rejectionReason: null,
        userId: userId,
        createdBy: user.name,
        mealType: _selectedMealType != null ? [_selectedMealType!] : ['Dinner'],
      );

      if (widget.isEditMode) {
        //TODO: dont use null aware assertion operator here
        await ref
            .read(recipeRepositoryProvider)
            .updateRecipe(recipe.id!, recipe);
      } else {
        await ref.read(recipeRepositoryProvider).saveRecipe(recipe);
      }

      if (!mounted) return;

      if (widget.isEditMode) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Recipe updated successfully!')),
        );
        context.pop();
      } else {
        _resetForm();
        messenger.showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
            content: Text(
              '🎉 Recipe submitted for admin review!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text('Failed to save recipe: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          widget.isEditMode ? 'Edit Recipe' : 'Create Recipe',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: widget.isEditMode
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
              )
            : null,
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: Text(
              'Reset',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              // _buildAppBar(),
              SliverPadding(
                padding: AppInsets.hXl,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildCoverPhoto(),
                    AppSpacing.vLg,
                    _buildRecipeName(),
                    AppSpacing.vLg,
                    // _buildDescription(),
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
                  ]),
                ),
              ),
            ],
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
      title: Text(
        widget.isEditMode ? 'Edit Recipe' : 'Create Recipe',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      leading: widget.isEditMode
          ? IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
            )
          : null,
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
    final existingImageUrl = widget.recipe?.image;
    final hasNewFile = _selectedImage != null;
    final hasExistingUrl =
        !_isImageRemoved &&
        existingImageUrl != null &&
        existingImageUrl.isNotEmpty;
    final hasImage = hasNewFile || hasExistingUrl;

    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(color: AppColors.surface),
          child: hasImage
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Render Image (File or Network)
                    if (hasNewFile)
                      Image.file(_selectedImage!, fit: BoxFit.cover)
                    else if (hasExistingUrl)
                      Image.network(
                        existingImageUrl,
                        fit: BoxFit.cover,
                        // Fallback if URL fails to load
                        errorBuilder: (context, error, stackTrace) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.broken_image_outlined,
                              size: 36,
                              color: AppColors.textHint,
                            ),
                            AppSpacing.vXs,
                            Text(
                              'Failed to load image',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        // Loading indicator while network image fetches
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                      ),

                    // 2. Remove Button (Top Right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Logic to clear the image
                          setState(() {
                            _selectedImage = null;
                            _isImageRemoved = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // 3. Edit Badge (Bottom Right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Change',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              // Empty State
              : DashedBorder(
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
        ),
      ),
    );
  }

  Widget _buildRecipeName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader.name(header: 'Recipe Name'),
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

  // Widget _buildDescription() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SectionHeader.name(header: 'Description'),
  //       AppSpacing.vSm,
  //       RecipeTextField(
  //         controller: _descriptionController,
  //         hintText: 'Tell a little about your recipe...',
  //         maxLines: 3,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDifficulty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader.name(header: 'Difficulty'),
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
        const SectionHeader.name(header: 'Servings'),
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
        const SectionHeader.name(header: 'Cooking Time'),
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
        const SectionHeader.name(header: 'Cuisine'),
        AppSpacing.vSm,
        DropdownButtonFormField<String>(
          initialValue: _selectedCuisine,
          decoration: _dropdownDecoration(hintText: 'Select cuisine'),
          items: _cuisines.map((cuisine) {
            return DropdownMenuItem(value: cuisine, child: Text(cuisine));
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
        const SectionHeader.name(header: 'Meal Type'),
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
        const SectionHeader.name(header: 'Ingredients'),
        AppSpacing.vSm,
        ...List.generate(_ingredientControllers.length, (index) {
          return Padding(
            key: ValueKey(_ingredientControllers[index]),
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
        }),
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
        const SectionHeader.name(header: 'Instructions'),
        AppSpacing.vSm,
        ...List.generate(_instructionControllers.length, (index) {
          return Padding(
            key: ValueKey(_instructionControllers[index]),
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
        }),
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
        const SectionHeader.name(header: 'Tags'),
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
                widget.isEditMode ? 'Resubmit Recipe' : 'Save Recipe',
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
