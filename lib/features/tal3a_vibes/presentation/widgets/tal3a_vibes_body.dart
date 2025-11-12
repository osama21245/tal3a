import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';
import 'package:tal3a/features/videos/presentation/screens/video_show.dart';

class Tal3aVibesBody extends StatefulWidget {
  const Tal3aVibesBody({super.key});

  @override
  State<Tal3aVibesBody> createState() => _Tal3aVibesBodyState();
}


class _Tal3aVibesBodyState extends State<Tal3aVibesBody> {
  @override
  Widget build(BuildContext context) {
     return Expanded(
       child: BlocProvider(
         create: (_) => VideoCubit()..loadVideos(),
         child: const VideoShow(),
       ),
     );

  }
}