import 'package:evently_c20_online/core/app_provider/app_provider.dart';
import 'package:evently_c20_online/l10n/app_localizations.dart';
import 'package:evently_c20_online/modules/auth/screens/login_screen.dart';
import 'package:evently_c20_online/modules/onboarding/widgets/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData(this.image, this.title, this.description);
}

class OnboardingScreen extends StatefulWidget {
  static const String routeName = "onboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  void goTo(int index) {
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void finish() {
    Provider.of<AppProvider>(context, listen: false).finishOnboarding();
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var local = AppLocalizations.of(context)!;

    List<OnboardingData> pages = [
      OnboardingData("assets/images/onboarding1.png", local.onboardingTitle1, local.onboardingDesc1),
      OnboardingData("assets/images/onboarding2.png", local.onboardingTitle2, local.onboardingDesc2),
      OnboardingData("assets/images/onboarding3.png", local.onboardingTitle3, local.onboardingDesc3),
    ];
    bool isLast = currentIndex == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: currentIndex > 0
                          ? Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton(
                          onPressed: () => goTo(currentIndex - 1),
                          icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                        ),
                      )
                          : null,
                    ),
                    Expanded(
                      child: Image.asset(
                        "assets/logo/app_logo.png",
                        height: 28,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: !isLast
                          ? Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: InkWell(
                          onTap: finish,
                          child: Text(
                            local.skip,
                            style: theme.textTheme.titleMedium!
                                .copyWith(color: theme.primaryColor),
                          ),
                        ),
                      )
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // الصفحات
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (index) => setState(() => currentIndex = index),
                  itemBuilder: (context, index) {
                    var page = pages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.asset(page.image, color: theme.primaryColorLight),
                          ),
                        ),
                        const SizedBox(height: 24),
                        DotsIndicator(count: pages.length, currentIndex: index),
                        const SizedBox(height: 24),
                        Text(page.title, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(page.description, style: theme.textTheme.bodyMedium),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLast ? finish : () => goTo(currentIndex + 1),
                  child: Center(child: Text(isLast ? local.getStarted : local.next)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}