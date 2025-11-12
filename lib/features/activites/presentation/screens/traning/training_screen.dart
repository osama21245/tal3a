import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';

import 'package:tal3a/features/activites/presentation/controllers/training_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_state.dart';
import '../../widgets/traning/training_screen/training_form_widget.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          BlocBuilder<TrainingCubit, Tal3aTypeState>(
            builder: (context, state) {
              return CustomAppBar(
                title: 'training',
                onBackPressed: () => Navigator.of(context).pop(),
              );
            },
          ),
          // Content
          Expanded(child: const TrainingFormWidget()),
        ],
      ),
    );
  }
}
