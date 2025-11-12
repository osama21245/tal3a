import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

/// Centralized animation helper class for consistent animations across the app
class AnimationHelper {
  // Private constructor to prevent instantiation
  AnimationHelper._();

  // Animation duration constants
  static const Duration _baseDuration = Duration(milliseconds: 500);
  static const Duration _fastDuration = Duration(milliseconds: 300);
  static const Duration _slowDuration = Duration(milliseconds: 800);
  static const Duration _staggerDelay = Duration(milliseconds: 100);
  static const Duration _staggerDuration = Duration(milliseconds: 200);

  // Animation delay constants
  static const Duration _baseDelay = Duration(milliseconds: 100);
  static const Duration _separatorDelay = Duration(milliseconds: 200);

  /// Title animations - FadeInDown
  static Widget titleAnimation({required Widget child, Duration? delay}) {
    return FadeInDown(
      duration: Duration(milliseconds: 600),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Subtitle animations - FadeInDown with delay
  static Widget subtitleAnimation({required Widget child, Duration? delay}) {
    return FadeInDown(
      duration: Duration(milliseconds: 800),
      delay: delay ?? Duration(milliseconds: 200),
      child: child,
    );
  }

  /// Section animations - FadeInDown with longer delay
  static Widget sectionAnimation({required Widget child, Duration? delay}) {
    return FadeInDown(
      duration: Duration(milliseconds: 1000),
      delay: delay ?? Duration(milliseconds: 400),
      child: child,
    );
  }

  /// Node animations - Used in header widgets for activity nodes
  static Widget nodeAnimation({
    required Widget child,
    required int index,
    Duration? customDelay,
  }) {
    final delay =
        customDelay ??
        Duration(milliseconds: index * _baseDelay.inMilliseconds);
    return FadeInLeft(
      duration: Duration(
        milliseconds:
            _baseDuration.inMilliseconds +
            (index * _staggerDuration.inMilliseconds),
      ),
      delay: delay,
      child: SlideInLeft(
        duration: Duration(
          milliseconds:
              _baseDuration.inMilliseconds +
              (index * _staggerDuration.inMilliseconds),
        ),
        delay: delay,
        child: BounceInLeft(
          duration: Duration(
            milliseconds:
                _slowDuration.inMilliseconds +
                (index * _staggerDuration.inMilliseconds),
          ),
          delay: delay,
          child: child,
        ),
      ),
    );
  }

  /// Separator line animations - Used between nodes
  static Widget separatorAnimation({
    required Widget child,
    required int index,
  }) {
    return FadeIn(
      duration: _fastDuration,
      delay: Duration(
        milliseconds:
            (index + 1) * _baseDelay.inMilliseconds +
            _separatorDelay.inMilliseconds,
      ),
      child: child,
    );
  }

  /// Card animations - FadeInUp, SlideInUp, BounceInUp combination
  static Widget cardAnimation({
    required Widget child,
    required int index,
    Duration? customDelay,
  }) {
    final delay =
        customDelay ??
        Duration(milliseconds: index * _baseDelay.inMilliseconds);
    return FadeInUp(
      duration: Duration(
        milliseconds:
            _baseDuration.inMilliseconds +
            (index * _staggerDuration.inMilliseconds),
      ),
      delay: delay,
      child: SlideInUp(
        duration: Duration(
          milliseconds:
              _baseDuration.inMilliseconds +
              (index * _staggerDuration.inMilliseconds),
        ),
        delay: delay,
        child: BounceInUp(
          duration: Duration(
            milliseconds:
                _slowDuration.inMilliseconds +
                (index * _staggerDuration.inMilliseconds),
          ),
          delay: delay,
          child: child,
        ),
      ),
    );
  }

  /// Left card animations - FadeInLeft, SlideInLeft, BounceInLeft combination
  static Widget leftCardAnimation({
    required Widget child,
    required int index,
    Duration? customDelay,
  }) {
    final delay =
        customDelay ??
        Duration(milliseconds: index * _baseDelay.inMilliseconds);
    return FadeInLeft(
      duration: Duration(
        milliseconds:
            _baseDuration.inMilliseconds +
            (index * _staggerDuration.inMilliseconds),
      ),
      delay: delay,
      child: SlideInLeft(
        duration: Duration(
          milliseconds:
              _baseDuration.inMilliseconds +
              (index * _staggerDuration.inMilliseconds),
        ),
        delay: delay,
        child: BounceInLeft(
          duration: Duration(
            milliseconds:
                _slowDuration.inMilliseconds +
                (index * _staggerDuration.inMilliseconds),
          ),
          delay: delay,
          child: child,
        ),
      ),
    );
  }

  /// Right card animations - FadeInRight, SlideInRight, BounceInRight combination
  static Widget rightCardAnimation({
    required Widget child,
    required int index,
    Duration? customDelay,
  }) {
    final delay =
        customDelay ??
        Duration(milliseconds: index * _baseDelay.inMilliseconds);
    return FadeInRight(
      duration: Duration(
        milliseconds:
            _baseDuration.inMilliseconds +
            (index * _staggerDuration.inMilliseconds),
      ),
      delay: delay,
      child: SlideInRight(
        duration: Duration(
          milliseconds:
              _baseDuration.inMilliseconds +
              (index * _staggerDuration.inMilliseconds),
        ),
        delay: delay,
        child: BounceInRight(
          duration: Duration(
            milliseconds:
                _slowDuration.inMilliseconds +
                (index * _staggerDuration.inMilliseconds),
          ),
          delay: delay,
          child: child,
        ),
      ),
    );
  }

  /// Button animations - AnimatedScale and AnimatedOpacity combination
  static Widget buttonAnimation({
    required Widget child,
    required bool isVisible,
    Duration? duration,
  }) {
    return AnimatedScale(
      scale: isVisible ? 1.0 : 0.0,
      duration: duration ?? Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: duration ?? Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  /// Simple fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeIn(
      duration: duration ?? _fastDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Simple slide up animation
  static Widget slideUp({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInUp(
      duration: duration ?? _baseDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Simple slide down animation
  static Widget slideDown({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInDown(
      duration: duration ?? _baseDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Simple slide left animation
  static Widget slideLeft({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInLeft(
      duration: duration ?? _baseDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Simple slide right animation
  static Widget slideRight({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return SlideInRight(
      duration: duration ?? _baseDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Bounce in up animation
  static Widget bounceInUp({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInUp(
      duration: duration ?? _slowDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Bounce in down animation
  static Widget bounceInDown({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInDown(
      duration: duration ?? _slowDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Bounce in left animation
  static Widget bounceInLeft({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInLeft(
      duration: duration ?? _slowDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Bounce in right animation
  static Widget bounceInRight({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return BounceInRight(
      duration: duration ?? _slowDuration,
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Onboarding page view animation - FadeInUp with longer duration
  static Widget onboardingPageViewAnimation({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInUp(
      duration: duration ?? Duration(milliseconds: 1000),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Onboarding page indicators animation - FadeInUp with longer delay
  static Widget onboardingPageIndicatorsAnimation({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInUp(
      duration: duration ?? Duration(milliseconds: 1200),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Onboarding title animation - FadeInLeft with custom timing
  static Widget onboardingTitleAnimation({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInLeft(
      duration: duration ?? Duration(milliseconds: 800),
      delay: delay ?? Duration(milliseconds: 200),
      child: child,
    );
  }

  /// Onboarding description animation - FadeInLeft with longer delay
  static Widget onboardingDescriptionAnimation({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInLeft(
      duration: duration ?? Duration(milliseconds: 1000),
      delay: delay ?? Duration(milliseconds: 400),
      child: child,
    );
  }

  /// Onboarding navigation buttons animation - FadeInUp with longest delay
  static Widget onboardingNavigationAnimation({
    required Widget child,
    Duration? duration,
    Duration? delay,
  }) {
    return FadeInUp(
      duration: duration ?? Duration(milliseconds: 1200),
      delay: delay ?? Duration.zero,
      child: child,
    );
  }

  /// Custom animation with all parameters
  static Widget custom({
    required Widget child,
    Duration? duration,
    Duration? delay,
    String? type,
  }) {
    switch (type?.toLowerCase()) {
      case 'fadein':
        return FadeIn(
          duration: duration ?? _fastDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'fadeindown':
        return FadeInDown(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'fadeinup':
        return FadeInUp(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'fadeinleft':
        return FadeInLeft(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'fadeinright':
        return FadeInRight(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'slideinup':
        return SlideInUp(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'slideindown':
        return SlideInDown(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'slideinleft':
        return SlideInLeft(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'slideinright':
        return SlideInRight(
          duration: duration ?? _baseDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'bounceinup':
        return BounceInUp(
          duration: duration ?? _slowDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'bounceindown':
        return BounceInDown(
          duration: duration ?? _slowDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'bounceinleft':
        return BounceInLeft(
          duration: duration ?? _slowDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      case 'bounceinright':
        return BounceInRight(
          duration: duration ?? _slowDuration,
          delay: delay ?? Duration.zero,
          child: child,
        );
      default:
        return child;
    }
  }
}
