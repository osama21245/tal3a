import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/auth/presentation/screens/choose_verification_way_screen.dart';
import 'package:tal3a/features/auth/presentation/screens/select_interests_screen.dart';
import 'package:tal3a/features/auth/presentation/screens/select_more_data_screen.dart';
import 'package:tal3a/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tal3a/features/tal3a_vibes/presentation/screens/tal3a_vibes_screen.dart';
import 'package:tal3a/features/walk_with_ai/presentation/screens/aI_walk_meta.dart';
import 'package:tal3a/start_screen.dart';

// Import all screens
import '../../features/auth/presentation/screens/signin_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_input_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/new_password_screen.dart';
import '../../features/auth/presentation/screens/select_weight_screen.dart';
import '../../features/auth/presentation/screens/select_gender_screen.dart';

import '../../features/activites/presentation/screens/choose_tal3a_type_screen.dart';
import '../../features/activites/presentation/screens/traning/training_choose_coach_screen.dart';
import '../../features/activites/presentation/screens/traning/training_choose_mode_screen.dart';
import '../../features/activites/presentation/screens/traning/training_screen.dart';

// Walk screens
import '../../features/activites/presentation/screens/walk/walk_choose_type_screen.dart';
import '../../features/activites/presentation/screens/walk/walk_choose_gender_screen.dart';
import '../../features/activites/presentation/screens/walk/walk_choose_friend_screen.dart';
import '../../features/activites/presentation/screens/walk/walk_choose_time_screen.dart';
import '../../features/activites/presentation/screens/walk/group/group_choose_type_screen.dart';
import '../../features/activites/presentation/screens/walk/group/group_choose_location_screen.dart';
import '../../features/activites/presentation/screens/walk/group/group_choose_time_screen.dart';

// Biking screens
import '../../features/activites/presentation/screens/biking/biking_choose_type_screen.dart';
import '../../features/activites/presentation/screens/biking/biking_choose_gender_screen.dart';
import '../../features/activites/presentation/screens/biking/biking_choose_friend_screen.dart';
import '../../features/activites/presentation/screens/biking/biking_choose_time_screen.dart';
import '../../features/activites/presentation/screens/biking/group/biking_group_choose_type_screen.dart';
import '../../features/activites/presentation/screens/biking/group/biking_group_choose_location_screen.dart';
import '../../features/activites/presentation/screens/biking/group/biking_group_choose_time_screen.dart';

// Import controllers/cubits
import '../../features/activites/presentation/controllers/training_cubit.dart';
import '../../features/activites/presentation/controllers/walk_cubit.dart';
import '../../features/activites/presentation/controllers/biking_cubit.dart';

// Story Feature Imports
import '../../features/story/presentation/screens/story_main_screen.dart';
import '../../features/story/presentation/screens/camera/camera_screen.dart';
import '../../features/story/presentation/screens/photo_selection/photo_selection_screen.dart';
import '../../features/story/presentation/screens/add_comment/add_comment_screen.dart';
import '../../features/story/presentation/screens/view_own_story/view_own_story_screen.dart';
import '../../features/story/presentation/screens/view_others_story/view_others_story_screen.dart';
import '../../features/story/presentation/controllers/story_cubit.dart';

// Home Feature Imports
import '../../features/home/presentation/screens/home_screen.dart';

// Events Feature Imports
import '../../features/events/events_feature.dart';
import '../../features/events/event_details_feature.dart';
import '../../features/events/ticket_purchase_feature.dart';

// Settings and Profile Feature Imports
import '../../features/settings_and_profile/settings_and_profile_feature.dart';

// Import routes
import 'routes.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startScreen:
        return MaterialPageRoute(builder: (context) => const StartScreen());

      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );

      // Authentication Routes
      case Routes.signInScreen:
        return MaterialPageRoute(builder: (context) => const SignInScreen());

      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder:
              (context) =>
                  const SignInScreen(), // Using SignInScreen for both sign in and sign up
        );

      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );

      case Routes.forgotPasswordInputScreen:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordInputScreen(),
        );

      case Routes.selectIntentsScreen:
        return MaterialPageRoute(
          builder: (context) => const SelectInterestsScreen(),
        );

      case Routes.selectGenderScreen:
        return MaterialPageRoute(
          builder: (context) => const SelectGenderScreen(),
        );

      case Routes.selectMoreDataScreen:
        return MaterialPageRoute(
          builder: (context) => const SelectMoreDataScreen(),
        );

      case Routes.chooseVerificationWayScreen:
        return MaterialPageRoute(
          builder:
              (context) => ChooseVerificationWayScreen(
                isFromForgotPassword: settings.arguments as bool? ?? false,
              ),
        );

      case Routes.otpVerificationScreen:
        return MaterialPageRoute(
          builder:
              (context) => OtpVerificationScreen(
                email: settings.arguments as String? ?? '',
                isFromForgotPassword: settings.arguments as bool? ?? false,
              ),
        );

      case Routes.newPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => const NewPasswordScreen(),
          settings: settings, // Pass the settings to preserve arguments
        );

      case Routes.selectWeightScreen:
        return MaterialPageRoute(
          builder: (context) => const SelectWeightScreen(),
        );

      // Activities Routes
      case Routes.chooseTal3aTypeScreen:
        return MaterialPageRoute(
          builder: (context) => const ChooseTal3aTypeScreen(),
        );

      case Routes.trainingChooseCoachScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Fallback: create new cubit if none provided
            return BlocProvider(
              create: (context) => TrainingCubit(),
              child: const TrainingChooseCoachScreen(),
            );
          },
        );

      case Routes.trainingChooseModeScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Get the cubit from the previous screen
            final cubit = settings.arguments as TrainingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const TrainingChooseModeScreen(),
              );
            }
            // Fallback: create new cubit if none provided
            return BlocProvider(
              create: (context) => TrainingCubit(),
              child: const TrainingChooseModeScreen(),
            );
          },
        );

      case Routes.trainingScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Get the cubit from the previous screen
            final cubit = settings.arguments as TrainingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const TrainingScreen(),
              );
            }
            // Fallback: create new cubit if none provided
            return BlocProvider(
              create: (context) => TrainingCubit(),
              child: const TrainingScreen(),
            );
          },
        );

      // Walk Routes
      case Routes.walkChooseTypeScreen:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const WalkChooseTypeScreen(),
            );
          },
        );

      case Routes.walkChooseGenderScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const WalkChooseGenderScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const WalkChooseGenderScreen(),
            );
          },
        );

      case Routes.walkChooseFriendScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const WalkChooseFriendScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const WalkChooseFriendScreen(),
            );
          },
        );

      case Routes.walkChooseTimeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const WalkChooseTimeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const WalkChooseTimeScreen(),
            );
          },
        );

      case Routes.walkGroupChooseTypeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const GroupChooseTypeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const GroupChooseTypeScreen(),
            );
          },
        );

      case Routes.walkGroupChooseLocationScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const GroupChooseLocationScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const GroupChooseLocationScreen(),
            );
          },
        );

      case Routes.walkGroupChooseTimeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as WalkCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const GroupChooseTimeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => WalkCubit(),
              child: const GroupChooseTimeScreen(),
            );
          },
        );

      // Biking Routes
      case Routes.bikingChooseTypeScreen:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingChooseTypeScreen(),
            );
          },
        );

      case Routes.bikingChooseGenderScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingChooseGenderScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingChooseGenderScreen(),
            );
          },
        );

      case Routes.bikingChooseFriendScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingChooseFriendScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingChooseFriendScreen(),
            );
          },
        );

      case Routes.bikingChooseTimeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingChooseTimeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingChooseTimeScreen(),
            );
          },
        );

      case Routes.bikingGroupChooseTypeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingGroupChooseTypeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingGroupChooseTypeScreen(),
            );
          },
        );

      case Routes.bikingGroupChooseLocationScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingGroupChooseLocationScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingGroupChooseLocationScreen(),
            );
          },
        );

      case Routes.bikingGroupChooseTimeScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as BikingCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const BikingGroupChooseTimeScreen(),
              );
            }
            return BlocProvider(
              create: (context) => BikingCubit(),
              child: const BikingGroupChooseTimeScreen(),
            );
          },
        );

      // Home Feature Routes
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      // Settings and Profile Feature Routes
      case Routes.settingsScreen:
        return MaterialPageRoute(
          builder: (context) => SettingsAndProfileFeature.getSettingsScreen(),
        );

      case Routes.changePasswordScreen:
        return MaterialPageRoute(
          builder:
              (context) => SettingsAndProfileFeature.getChangePasswordScreen(),
        );

      // Events Feature Routes
      case Routes.eventsScreen:
        return MaterialPageRoute(
          builder: (context) => EventsFeature.getEventsScreen(),
        );

      case Routes.eventDetailsScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Handle both old format (just eventId string) and new format (map with isFromTicketsScreen)
            if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              final eventId = args['eventId'] as String? ?? '';
              final isFromTicketsScreen =
                  args['isFromTicketsScreen'] as bool? ?? false;
              return EventDetailsFeature.getEventDetailsScreen(
                eventId,
                isFromTicketsScreen: isFromTicketsScreen,
              );
            } else {
              // Fallback for old navigation style (just eventId string)
              final eventId = settings.arguments as String? ?? '';
              return EventDetailsFeature.getEventDetailsScreen(eventId);
            }
          },
        );

      case Routes.ticketPurchaseScreen:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments is Map<String, dynamic>) {
              final args = settings.arguments as Map<String, dynamic>;
              final eventId = args['eventId'] as String? ?? '';
              final eventDetails = args['eventDetails'];
              return TicketPurchaseFeature.getTicketPurchaseScreen(
                eventId,
                eventDetails: eventDetails,
              );
            } else {
              // Fallback for old navigation style
              final eventId = settings.arguments as String? ?? '';
              return TicketPurchaseFeature.getTicketPurchaseScreen(eventId);
            }
          },
        );

      // Story Feature Routes
      case Routes.storyMainScreen:
        return MaterialPageRoute(builder: (context) => const StoryMainScreen());

      case Routes.storyCameraScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as StoryCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const CameraScreen(),
              );
            }
            return BlocProvider(
              create: (context) => StoryCubit()..loadFilters(),
              child: const CameraScreen(),
            );
          },
        );

      case Routes.storyPhotoSelectionScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as StoryCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const PhotoSelectionScreen(),
              );
            }
            return BlocProvider(
              create: (context) => StoryCubit(),
              child: const PhotoSelectionScreen(),
            );
          },
        );

      case Routes.storyAddCommentScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as StoryCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const AddCommentScreen(),
              );
            }
            return BlocProvider(
              create: (context) => StoryCubit(),
              child: const AddCommentScreen(),
            );
          },
        );

      case Routes.storyViewOwnScreen:
        return MaterialPageRoute(
          builder: (context) {
            final cubit = settings.arguments as StoryCubit?;
            if (cubit != null) {
              return BlocProvider.value(
                value: cubit,
                child: const ViewOwnStoryScreen(),
              );
            }
            return BlocProvider(
              create: (context) => StoryCubit()..loadStories(),
              child: const ViewOwnStoryScreen(),
            );
          },
        );

      case Routes.storyViewOthersScreen:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments as Map<String, dynamic>?;
            final userId = args?['userId'] as String? ?? '';
            final userName = args?['userName'] as String? ?? '';
            final userProfilePic = args?['userProfilePic'] as String?;

            return BlocProvider(
              create: (context) => StoryCubit()..loadUserStories(userId),
              child: ViewOthersStoryScreen(
                userId: userId,
                userName: userName,
                userProfilePic: userProfilePic,
              ),
            );
          },
        );
      case Routes.aiWalkMeta:
        return MaterialPageRoute(
          builder: (context) {
            return AIWalkMeta();
          },
        );
          case Routes.tal3aVibes:
        return MaterialPageRoute(
          builder: (context) {
            return Tal3aVibesScreen();
          },
        );
      // Default route (Splash/Onboarding)
      case Routes.splashScreen:
      default:
        return MaterialPageRoute(
          builder:
              (context) => const Scaffold(
                body: Center(
                  child: Text(
                    'Tal3a App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        );
    }
  }
}
