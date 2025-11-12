import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tal3a/features/activites/data/models/walk_friend_model.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/walk_cubit.dart';
import '../../../controllers/walk_state.dart';

import '../../../screens/walk/walk_choose_time_screen.dart';

class WalkChooseFriendFormWidget extends StatefulWidget {
  const WalkChooseFriendFormWidget({super.key});

  @override
  State<WalkChooseFriendFormWidget> createState() =>
      _WalkChooseFriendFormWidgetState();
}

class _WalkChooseFriendFormWidgetState
    extends State<WalkChooseFriendFormWidget> {
  WalkFriendModel? _selectedWalkFriend;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load data using cubit
    context.read<WalkCubit>().loadWalkFriends();
  }

  void _selectWalkFriend(WalkFriendModel walkFriend) {
    setState(() {
      _selectedWalkFriend = walkFriend;
      _isButtonEnabled = true;
    });
  }

  void _continue() {
    if (_isButtonEnabled && _selectedWalkFriend != null) {
      // Update WalkCubit with selected walk friend
      context.read<WalkCubit>().selectWalkFriend(_selectedWalkFriend!);

      // Add navigation history
      context.read<WalkCubit>().addNavigationNode(
        'WalkChooseFriendScreen',
        data: {'selectedWalkFriend': _selectedWalkFriend!.toJson()},
      );

      // Navigate to next screen
      final walkCubit = context.read<WalkCubit>();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: walkCubit,
                child: const WalkChooseTimeScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkCubit, WalkState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorPalette.primaryBlue),
          );
        }

        if (state.isError) {
          return Center(child: Text('Error: ${state.error}'));
        }

        return Stack(
          children: [
            // Scrollable content area - takes full space
            ListView.builder(
              padding: const EdgeInsets.only(
                left: 6,
                right: 6,
                top: 9,
                bottom: 100,
              ),
              itemCount: state.walkFriends.length,
              itemBuilder: (context, index) {
                final friend = state.walkFriends[index];
                final isSelected = _selectedWalkFriend?.id == friend.id;

                return AnimationHelper.cardAnimation(
                  index: index,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectWalkFriend(friend),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        height: 69,
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? ColorPalette.friendCardSelected
                                  : ColorPalette.friendCardUnselected,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: ColorPalette.friendCardSelected
                                          .withOpacity(0.35),
                                      blurRadius: 0,
                                      spreadRadius: 3,
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              // Profile Image
                              Container(
                                width: 53,
                                height: 53,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.26),
                                  image:
                                      friend.imageUrl != null
                                          ? DecorationImage(
                                            image: AssetImage(friend.imageUrl!),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    friend.imageUrl == null
                                        ? const Icon(
                                          Icons.person,
                                          color:
                                              ColorPalette.friendCardIconGrey,
                                          size: 24,
                                        )
                                        : null,
                              ),

                              const SizedBox(width: 11),

                              // Friend Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      friend.name,
                                      style:
                                          isSelected
                                              ? AppTextStyles
                                                  .friendCardNameSelectedStyle
                                              : AppTextStyles
                                                  .friendCardNameStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          friend.age,
                                          style:
                                              isSelected
                                                  ? AppTextStyles
                                                      .friendCardDetailsSelectedStyle
                                                  : AppTextStyles
                                                      .friendCardDetailsStyle,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'activities.years'.tr(),
                                          style:
                                              isSelected
                                                  ? AppTextStyles
                                                      .friendCardUnitSelectedStyle
                                                  : AppTextStyles
                                                      .friendCardUnitStyle,
                                        ),

                                        const SizedBox(width: 20),
                                        Text(
                                          friend.weight,
                                          style:
                                              isSelected
                                                  ? AppTextStyles
                                                      .friendCardDetailsSelectedStyle
                                                  : AppTextStyles
                                                      .friendCardDetailsStyle,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'activities.kg'.tr(),
                                          style:
                                              isSelected
                                                  ? AppTextStyles
                                                      .friendCardUnitSelectedStyle
                                                  : AppTextStyles
                                                      .friendCardUnitStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                    text: 'common.continue'.tr(),
                    onPressed: _isButtonEnabled ? _continue : null,
                    isEnabled: _isButtonEnabled,
                  ),
                ),
                isVisible: _selectedWalkFriend != null,
              ),
            ),
          ],
        );
      },
    );
  }
}
