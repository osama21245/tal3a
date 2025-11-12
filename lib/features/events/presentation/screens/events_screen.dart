import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/events_screen/events_tab_selector_widget.dart';
import '../widgets/events_screen/events_search_filter_widget.dart';
import '../widgets/events_screen/events_list_widget.dart';
import '../widgets/tickets_screen/tickets_empty_state_widget.dart';
import '../widgets/tickets_screen/purchased_ticket_card_widget.dart';
import '../controllers/purchased_tickets_cubit.dart';
import '../controllers/purchased_tickets_state.dart';
import '../../data/datasources/events_remote_datasource.dart';
import '../../data/repositories/events_repository_impl.dart';
import '../../../../core/network/api_client.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool isEventsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with Training App Bar
          CustomAppBar(
            title: 'events.title'.tr(),
            onBackPressed: () => Navigator.of(context).pop(),
          ),

          // Main Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Tab Selector
                  EventsTabSelectorWidget(
                    isEventsSelected: isEventsSelected,
                    onTabChanged: (selected) {
                      setState(() {
                        isEventsSelected = selected;
                      });
                    },
                  ),

                  // Search and Filter (for both tabs)
                  const EventsSearchFilterWidget(),

                  // Content based on selected tab
                  Expanded(
                    child:
                        isEventsSelected
                            ? const EventsListWidget()
                            : _buildTicketsContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsContent() {
    return BlocProvider<PurchasedTicketsCubit>(
      create: (context) {
        final remoteDataSource = EventsRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
        return PurchasedTicketsCubit(eventsRepository: repository)
          ..loadPurchasedTickets();
      },
      child: BlocBuilder<PurchasedTicketsCubit, PurchasedTicketsState>(
        builder: (context, state) {
          if (state is PurchasedTicketsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2BB8FF)),
            );
          } else if (state is PurchasedTicketsLoaded) {
            if (state.purchases.isEmpty) {
              return const TicketsEmptyStateWidget();
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: state.purchases.length, // +1 for section title
                itemBuilder: (context, index) {
                  return PurchasedTicketCardWidget(
                    purchase: state.purchases[index],
                  );
                },
              );
            }
          } else if (state is PurchasedTicketsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'events.error_loading_tickets'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF262627),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<PurchasedTicketsCubit>()
                          .loadPurchasedTickets();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2BB8FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            );
          }

          return const TicketsEmptyStateWidget();
        },
      ),
    );
  }
}
