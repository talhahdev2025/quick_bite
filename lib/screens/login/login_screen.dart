import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/core/constants/app_insets.dart';
import 'package:quick_bite/core/constants/app_radius.dart';
import 'package:quick_bite/core/constants/app_spacing.dart';
import 'package:quick_bite/core/constants/app_text_styles.dart';
import 'package:quick_bite/core/widgets/custom_filled_button.dart';
import 'package:quick_bite/screens/login/authentication_container.dart';
import 'package:quick_bite/screens/login/login_custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Container(
              clipBehavior: .hardEdge,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Image.asset('assets/login_page_img.png'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        // Spacer(),
                        Expanded(
                          flex: 2,
                          child: TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Login'),
                              Tab(text: 'SignUp'),
                            ],
                          ),
                        ),
                        // Spacer(),
                        // Expanded(
                        //   flex: 2,
                        //   child: Container(
                        //     height: 100,
                        //     color: Colors.pinkAccent,
                        //   ),
                        // ),
                        // Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ,
          ),
        ],
      ),
    );
  }
}
