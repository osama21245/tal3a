import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';
import '../../../../data/models/biking_friend_model.dart';
import '../../../screens/biking/biking_choose_time_screen.dart';

class BikingChooseFriendFormWidget extends StatelessWidget {
  const BikingChooseFriendFormWidget({super.key});

  // Static biking friends data
  static const List<BikingFriendModel> _bikingFriends = [
    BikingFriendModel(
      id: 'friend4',
      name: 'Capt.Ahmed M.',
      age: 25,
      weight: 70,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    BikingFriendModel(
      id: 'friend6',
      name: 'Capt.Ahmed M.',
      age: 25,
      weight: 70,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    BikingFriendModel(
      id: 'friend3',
      name: 'Capt.Ahmed M.',
      age: 25,
      weight: 70,
      imageUrl: 'assets/images/fitness_partner.png',
    ),
    // BikingFriendModel(
    //   id: 'friend5',
    //   name: 'Capt.Ahmed M.',
    //   age: 25,
    //   weight: 70,
    //   imageUrl: 'assets/images/fitness_partner.png',
    // ),
    // BikingFriendModel(
    //   id: 'friend12',
    //   name: 'Capt.Ahmed M.',
    //   age: 25,
    //   weight: 70,
    //   imageUrl: 'assets/images/fitness_partner.png',
    // ),
    // BikingFriendModel(
    //   id: 'friend1',
    //   name: 'Capt.Ahmed M.',
    //   age: 25,
    //   weight: 70,
    //   imageUrl: 'assets/images/fitness_partner.png',
    // ),
    // BikingFriendModel(
    //   id: 'friend2',
    //   name: 'Capt.Sara A.',
    //   age: 23,
    //   weight: 55,
    //   imageUrl: 'assets/images/certified_coaches.png',
    // ),
  ];

  void _selectBikingFriend(
    BuildContext context,
    BikingFriendModel bikingFriend,
  ) {
    context.read<BikingCubit>().selectBikingFriend(bikingFriend);
  }

  void _continue(BuildContext context) {
    final bikingCubit = context.read<BikingCubit>();
    final selectedBikingFriend = bikingCubit.state.selectedBikingFriend;
    if (selectedBikingFriend != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: bikingCubit,
                child: const BikingChooseTimeScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        final selectedBikingFriend = state.selectedBikingFriend;

        return Stack(
          children: [
            // Scrollable content area - takes full space
            ListView.builder(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 9),
              itemCount: _bikingFriends.length,
              itemBuilder: (context, index) {
                final bikingFriend = _bikingFriends[index];
                final isSelected = selectedBikingFriend?.id == bikingFriend.id;

                return AnimationHelper.cardAnimation(
                  index: index,
                  child: GestureDetector(
                    onTap: () => _selectBikingFriend(context, bikingFriend),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? ColorPalette.coachCardSelected
                                : ColorPalette.cardGrey,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: ColorPalette.coachCardSelected
                                        .withOpacity(0.35),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 4,
                                  ),
                                ]
                                : null,
                      ),
                      child: Row(
                        children: [
                          // Friend Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                              child: Image.asset(
                                bikingFriend.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Friend Info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bikingFriend.name,
                                    style: AppTextStyles.coachNameBoldStyle
                                        .copyWith(
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : ColorPalette
                                                      .activityTextGrey,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${bikingFriend.age} years • ${bikingFriend.weight}kg',
                                    style: AppTextStyles.coachTitleSelectedStyle
                                        .copyWith(
                                          color:
                                              isSelected
                                                  ? Colors.white.withOpacity(
                                                    0.8,
                                                  )
                                                  : ColorPalette
                                                      .activityTextGrey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Floating Continue Button - appears in front of the list
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: AnimationHelper.buttonAnimation(
                child: SafeArea(
                  child: PrimaryButtonWidget(
                    text: 'Continue',
                    onPressed:
                        selectedBikingFriend != null
                            ? () => _continue(context)
                            : null,
                    isEnabled: selectedBikingFriend != null,
                  ),
                ),
                isVisible: selectedBikingFriend != null,
              ),
            ),
          ],
        );
      },
    );
  }
}
