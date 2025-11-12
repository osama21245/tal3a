import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../controllers/events_cubit.dart';
import '../../controllers/events_state.dart';
import 'event_card_widget.dart';

class EventsListWidget extends StatefulWidget {
  const EventsListWidget({super.key});

  @override
  State<EventsListWidget> createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsCubit>().loadEvents();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<EventsCubit>().loadMoreEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        print('🎯 EventsListWidget: Current state is ${state.runtimeType}');
        if (state is EventsLoaded) {
          print(
            '🎯 EventsListWidget: EventsLoaded with ${state.events.length} events',
          );
        } else if (state is EventsError) {
          print('🎯 EventsListWidget: EventsError - ${state.message}');
        }
        if (state is EventsLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF2BB8FF),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'events.loading_events'.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is EventsError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'events.error_loading_events'.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EventsCubit>().refreshEvents();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BB8FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'common.retry'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is EventsLoaded && state.events.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'events.no_events'.tr(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is EventsLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<EventsCubit>().refreshEvents();
            },
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                // Section Title
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    'events.popular_in_barcelona'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF262627),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                ),

                // Events List
                ...state.events.asMap().entries.map((entry) {
                  final index = entry.key;
                  final event = entry.value;

                  return Column(
                    children: [
                      EventCardWidget(
                        event: event,
                        isFeatured: index == 0, // First event is featured
                      ),
                      if (index < state.events.length - 1)
                        SizedBox(height: 12.h),
                    ],
                  );
                }).toList(),

                // Loading indicator for pagination
                if (state.hasMoreData)
                  Container(
                    padding: EdgeInsets.all(20.h),
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                SizedBox(height: 20.h),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
