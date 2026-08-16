import 'package:flutter/material.dart';
import 'package:quick_bite/core/constants/app_colors.dart';
import 'package:quick_bite/screens/login/login_container.dart';
import 'package:quick_bite/screens/login/sign_up_container.dart';

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
                        Expanded(
                          flex: 2,
                          //tab bar
                          child: TabBar(
                            dividerHeight: 0,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelStyle: TextStyle(fontWeight: .bold),
                            unselectedLabelColor: AppColors.black,
                            labelColor: AppColors.primary,
                            indicatorColor: AppColors.primary,
                            physics: CarouselScrollPhysics(),
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Login'),
                              Tab(text: 'SignUp'),
                            ],
                          ),
                        ),                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [LoginContainer(), SignUpContainer()],
            ),
          ),
        ],
      ),
    );
  }
}
