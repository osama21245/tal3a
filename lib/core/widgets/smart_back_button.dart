import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_state.dart';

class SmartBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const SmartBackButton({super.key, this.onPressed, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Tal3aTypeCubit, Tal3aTypeState>(
      builder: (context, state) {
        // If there's navigation history, use smart back functionality
        if (state.canGoBack) {
          return GestureDetector(
            onTap: () => _handleSmartBack(context, state),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: color ?? Colors.white,
                size: size ?? 24,
              ),
            ),
          );
        }

        // Default back button behavior
        return GestureDetector(
          onTap: onPressed ?? () => Navigator.pop(context),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: color ?? Colors.white,
              size: size ?? 24,
            ),
          ),
        );
      },
    );
  }

  void _handleSmartBack(BuildContext context, Tal3aTypeState state) {
    // Remove the last navigation node
    context.read<Tal3aTypeCubit>().removeLastNavigationNode();

    // Navigate back
    Navigator.pop(context);
  }
}

// Alternative implementation that shows a confirmation dialog
class SmartBackButtonWithConfirmation extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? confirmationMessage;

  const SmartBackButtonWithConfirmation({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.confirmationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Tal3aTypeCubit, Tal3aTypeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _handleSmartBackWithConfirmation(context, state),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: color ?? Colors.white,
              size: size ?? 24,
            ),
          ),
        );
      },
    );
  }

  void _handleSmartBackWithConfirmation(
    BuildContext context,
    Tal3aTypeState state,
  ) {
    if (state.canGoBack) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Go Back?'),
            content: Text(
              confirmationMessage ??
                  'Are you sure you want to go back? Your current selection will be lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<Tal3aTypeCubit>().removeLastNavigationNode();
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
}
