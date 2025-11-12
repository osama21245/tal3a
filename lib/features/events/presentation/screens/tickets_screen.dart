import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/core/widgets/custom_app_bar.dart';
import '../../../../core/const/color_pallete.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/events_remote_datasource.dart';
import '../../data/repositories/events_repository_impl.dart';
import '../controllers/purchased_tickets_cubit.dart';
import '../controllers/purchased_tickets_state.dart';
import '../widgets/tickets_screen/tickets_empty_state_widget.dart';
import '../widgets/tickets_screen/purchased_ticket_card_widget.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PurchasedTicketsCubit>(
      create: (context) {
        final remoteDataSource = EventsRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = EventsRepositoryImpl(dataSource: remoteDataSource);
        return PurchasedTicketsCubit(eventsRepository: repository)
          ..loadPurchasedTickets();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header with Training App Bar
            CustomAppBar(
              title: 'events.my_tickets'.tr(),
              onBackPressed: () => Navigator.of(context).pop(),
            ),

            // Main Content
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child:
                    BlocBuilder<PurchasedTicketsCubit, PurchasedTicketsState>(
                      builder: (context, state) {
                        if (state is PurchasedTicketsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2BB8FF),
                            ),
                          );
                        } else if (state is PurchasedTicketsLoaded) {
                          if (state.purchases.isEmpty) {
                            return const TicketsEmptyStateWidget();
                          } else {
                            return ListView.builder(
                              padding: EdgeInsets.only(top: 20.h),
                              itemCount: state.purchases.length,
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
                                  color: ColorPalette.textGrey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'events.error_loading_tickets'.tr(),
                                  style: const TextStyle(
                                    color: ColorPalette.textDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: ColorPalette.textGrey,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
