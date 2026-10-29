import 'package:evently_c20_online/core/app_provider/app_provider.dart';
import 'package:evently_c20_online/core/theme/app_theme.dart';
import 'package:evently_c20_online/modules/auth/screens/forget_password_screen.dart';
import 'package:evently_c20_online/modules/auth/screens/login_screen.dart';
import 'package:evently_c20_online/modules/auth/screens/resgister_screen.dart';
import 'package:evently_c20_online/modules/splash/screens/splash_screen.dart';
import 'package:evently_c20_online/modules/start/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'modules/add_event/screens/add_event_screen.dart';
import 'modules/event_details/screens/event_details_screen.dart';
import 'modules/layout/screens/layout_screen.dart';
import 'modules/onboarding/screens/onboarding_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppProvider.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      builder: (context, child) {
        var provider = Provider.of<AppProvider>(context);
        return MaterialApp(
          routes: {
            SplashScreen.routeName : (_) => SplashScreen(),
            OnboardingScreen.routeName : (_) => const OnboardingScreen(),
            EventDetailsScreen.routeName : (_) => const EventDetailsScreen(),
            StartScreen.routeName : (_) => StartScreen(),
            LoginScreen.routeName : (_) => LoginScreen(),
            RegisterScreen.routeName : (_) => RegisterScreen(),
            ForgetPasswordScreen.routeName : (_) => ForgetPasswordScreen(),
            LayoutScreen.routeName : (_) => LayoutScreen(),
            AddEventScreen.routeName : (_) => AddEventScreen(),
          },
          initialRoute:SplashScreen.routeName,
          locale: Locale(provider.locale),
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            ...GlobalMaterialLocalizations.delegates,
          ],          supportedLocales: [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
          themeMode: provider.themeMode,
          // light theme
          theme: AppTheme.lightTheme,
          // dark theme
          darkTheme: AppTheme.darkTheme,
          title: 'Flutter Demo',
        );
      },
    );
  }
}
