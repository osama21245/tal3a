import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../controllers/camera_cubit.dart';
import '../../controllers/camera_state.dart';
import '../../widgets/camera_screen/camera_form_widget.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent for full-screen camera
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return BlocProvider(
      create: (context) => CameraCubit()..initializeCamera(),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: BlocConsumer<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<CameraCubit>().clearError();
            }
          },
          builder: (context, state) {
            if (state.isLoading && !state.isCameraInitialized) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state.error != null && !state.isCameraInitialized) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          () => context.read<CameraCubit>().initializeCamera(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const CameraFormWidget();
          },
        ),
      ),
    );
  }
}
