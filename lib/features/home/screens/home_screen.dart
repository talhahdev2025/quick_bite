import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_shadows.dart';
import 'package:quick_bite/core/constants/app_sizes.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/features/home/widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVerticalList = false;
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
        child: CustomScrollView(
          // crossAxisAlignment: .start,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                // color: Colors.amber,
                height: MediaQuery.heightOf(context) * 0.3,
                padding: AppInsets.hXl,
                child: Column(
                  crossAxisAlignment: .start,
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
                      style: TextStyle(fontSize: 42, fontWeight: .bold),
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
            ),
            //list view
            // Spacer(),
            SliverToBoxAdapter(
              child: Container(
                // color: Colors.brown,
                height: MediaQuery.heightOf(context) * 0.05,
                padding: AppInsets.hXl,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text('Items', style: AppTextStyles.headlineMedium),
                    IconButton(
                      icon: Icon(Icons.list_rounded, size: 25),
                      onPressed: () => setState(() {
                        isVerticalList = !isVerticalList;
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // Spacer(),
            isVerticalList
                ? SliverToBoxAdapter(child: SizedBox())
                : SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          MediaQuery.heightOf(context) * 0.6 -
                          kBottomNavigationBarHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Center(
                            child: HomeCard(
                              itemName: 'Burger',
                              imageUrl:
                                  'https://cdn.dummyjson.com/recipe-images/6.webp',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
