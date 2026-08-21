import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            // horizontal: AppSizes.xxxl,
            vertical: AppSizes.xl,
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: AppInsets.hXl,
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.shopping_cart_outlined),
                        ),
                      ],
                    ),
                    Text(
                      'Delicious\nfood for you',
                      style: AppTextStyles.displayLarge,
                    ),
                    AppSpacing.vXl,
                    //search text field
                    TextField(
                      decoration: InputDecoration(
                        hint: Text(
                          'search',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                        prefixIcon: Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: AppColors.background,
                        enabledBorder: OutlineInputBorder(
                          borderSide: .none,
                          borderRadius: AppRadius.xLarge,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: AppRadius.xLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
