import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/story_cubit.dart';
import 'enhanced_camera_preview_widget.dart';

class CameraFormWidget extends StatelessWidget {
  const CameraFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StoryCubit()..loadFilters()),
      ],
      child: const EnhancedCameraPreviewWidget(),
    );
  }
}
