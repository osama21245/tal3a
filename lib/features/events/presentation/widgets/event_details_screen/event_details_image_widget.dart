import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/event_details_cubit.dart';
import '../../controllers/event_details_state.dart';

class EventDetailsImageWidget extends StatelessWidget {
  const EventDetailsImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsCubit, EventDetailsState>(
      builder: (context, state) {
        if (state is EventDetailsLoaded) {
          return Container(
            height: 230.h,
            width: double.infinity,
            child: Stack(
              children: [
                // Event Image
                Container(
                  height: 230.h,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: state.eventDetails.eventIcon,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                  ),
                ),

                // Action Buttons Overlay
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: Row(
                    children: [
                      // Bookmark Button
                      GestureDetector(
                        onTap: () {
                          // Handle bookmark
                        },
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          child: SvgPicture.asset(
                            'assets/icons/bookmark.svg',
                            width: 24.w,
                            height: 24.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 11.w),
                      // Share Button
                      GestureDetector(
                        onTap: () {
                          // Handle share
                        },
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          child: SvgPicture.asset(
                            'assets/icons/share.svg',
                            width: 24.w,
                            height: 24.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Loading state
        return Container(
          height: 230.h,
          width: double.infinity,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
