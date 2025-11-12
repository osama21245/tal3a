import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/routing/app_router.dart';
import 'package:tal3a/core/routing/routes.dart';
import 'package:tal3a/core/di/dependency_injection.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/core/controller/profile_setup_controller.dart';
import 'package:tal3a/core/widgets/global_error_handler.dart';
import 'package:tal3a/core/widgets/custom_error_screen.dart';
import 'features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Initialize dependencies
  setupDependencies();

  // Set up custom error handling
  ErrorWidget.builder = customErrorScreen;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'), // Default to Arabic for Saudi Arabia
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserController()),
        BlocProvider(create: (context) => ProfileSetupController()),
        BlocProvider(create: (context) => OnboardingController()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844), // Figma design dimensions
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GlobalErrorHandler(
            child: MaterialApp(
              title: 'Tal3a',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              initialRoute: Routes.onboardingScreen,
              onGenerateRoute: AppRouter.generateRoute,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}
