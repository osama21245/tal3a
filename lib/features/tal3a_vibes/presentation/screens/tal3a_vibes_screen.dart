import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/core/const/color_pallete.dart';
import 'package:tal3a/core/controller/user_controller.dart';
import 'package:tal3a/features/tal3a_vibes/presentation/widgets/tal3a_vibes_body.dart';
import 'package:tal3a/features/tal3a_vibes/presentation/widgets/tal3a_vibes_header.dart';
import 'package:flutter/material.dart';
import 'package:tal3a/features/videos/presentation/controllers/video_cubit.dart';

class Tal3aVibesScreen extends StatefulWidget {
  const Tal3aVibesScreen({super.key});

  @override
  State<Tal3aVibesScreen> createState() => _Tal3aVibesScreenState();
}

class _Tal3aVibesScreenState extends State<Tal3aVibesScreen> {
  final PageController _pageController = PageController();
  double _headerOffset = 0;

  void _onScroll() {
    setState(() {
      _headerOffset =
          _pageController.hasClients ? _pageController.offset / 1 : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId = context.watch<UserController>().state.user!.id;

    return Scaffold(
      backgroundColor: ColorPalette.homeMainBg,
      body: Stack(
        children: [
          BlocProvider(
            create:
                (_) => VideoCubit(
                  userId: userId
                )..loadVideos(),
            child: Tal3aVibesBody(pageController: _pageController),
          ),
          Positioned(
            top: -_headerOffset,
            left: 0,
            right: 0,
            child: const Tal3aVibesHeader(title: "Tal3a Vibes"),
          ),
        ],
      ),
    );
  }
}
// ======>>>> Other User Experience Swipe The Header To Hide <<<<======



// class Tal3aVibesScreen extends StatefulWidget {
//   const Tal3aVibesScreen({super.key});

//   @override
//   State<Tal3aVibesScreen> createState() => _Tal3aVibesScreenState();
// }

// class _Tal3aVibesScreenState extends State<Tal3aVibesScreen> {
//   final PageController _pageController = PageController();

//   double _headerTop = 0;
//   final double _headerHeight = 229.h;

//   double _dragStartY = 0;
//   double _dragCurrentTop = 0;





//   void _animateHeaderTo(double target) {
//     setState(() {
//       _headerTop = target;
//     });
//   }

//   void _onHeaderDragStart(DragStartDetails details) {
//     _dragStartY = details.globalPosition.dy;
//     _dragCurrentTop = _headerTop;
//   }

//   void _onHeaderDragUpdate(DragUpdateDetails details) {
//     double delta = details.globalPosition.dy - _dragStartY;
//     setState(() {
//       _headerTop = (_dragCurrentTop + delta).clamp(-_headerHeight, 0);
//     });
//   }

//   void _onHeaderDragEnd(DragEndDetails details) {
//     if (_headerTop < -_headerHeight / 2) {
//       _animateHeaderTo(-_headerHeight);
//     } else {
//       _animateHeaderTo(0);
//     }
//   }

//   void _onArrowPressed() {
//     _animateHeaderTo(0);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorPalette.homeMainBg,
//       body: Stack(
//         children: [
//           Tal3aVibesBody(pageController: _pageController),

//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 350),
//             curve: Curves.easeOutCubic,
//             top: _headerTop,
//             left: 0,
//             right: 0,
//             child: GestureDetector(
//               onVerticalDragStart: _onHeaderDragStart,
//               onVerticalDragUpdate: _onHeaderDragUpdate,
//               onVerticalDragEnd: _onHeaderDragEnd,
//               child: const Tal3aVibesHeader(title: "Tal3a Vibes"),
//             ),
//           ),

//           if (_headerTop <= -_headerHeight + 10)
//             Positioned(
//               top: 30.h,
//               left: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: _onArrowPressed,
//                 child: Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white.withOpacity(0.7),
//                   size: 28,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
