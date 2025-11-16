import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/const/color_pallete.dart';
import '../../../../../../core/const/text_style.dart';
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/utils/animation_helper.dart';
import '../../../controllers/biking_cubit.dart';
import '../../../controllers/biking_state.dart';
import '../../../../data/models/biking_friend_model.dart';
import '../../../screens/biking/biking_choose_location_screen.dart';

class BikingChooseFriendFormWidget extends StatefulWidget {
  const BikingChooseFriendFormWidget({super.key});

  @override
  State<BikingChooseFriendFormWidget> createState() =>
      _BikingChooseFriendFormWidgetState();
}

class _BikingChooseFriendFormWidgetState
    extends State<BikingChooseFriendFormWidget> {
  BikingFriendModel? _selectedBikingFriend;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BikingCubit>().loadBikingFriends();
    });
  }

  void _selectBikingFriend(BikingFriendModel bikingFriend) {
    setState(() {
      _selectedBikingFriend = bikingFriend;
      _isButtonEnabled = true;
    });
  }

  void _continue() {
    if (_isButtonEnabled && _selectedBikingFriend != null) {
      // Update BikingCubit with selected biking friend
      context.read<BikingCubit>().selectBikingFriend(_selectedBikingFriend!);

      // Add navigation history
      context.read<BikingCubit>().addNavigationNode(
        'BikingChooseFriendScreen',
        data: {'selectedBikingFriend': _selectedBikingFriend!.toJson()},
      );

      // Navigate to next screen
      final bikingCubit = context.read<BikingCubit>();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: bikingCubit,
                child: const BikingChooseLocationScreen(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BikingCubit, BikingState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: ColorPalette.primaryBlue),
          );
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state.bikingFriends.isEmpty) {
          return const Center(
            child: Text('No friends found for the selected preference.'),
          );
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
              itemCount: state.bikingFriends.length,
              itemBuilder: (context, index) {
                final friend = state.bikingFriends[index];
                final isSelected = _selectedBikingFriend?.id == friend.id;

                return AnimationHelper.cardAnimation(
                  index: index,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectBikingFriend(friend),
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
                                  image: _buildFriendImage(friend.imageUrl),
                                ),
                                child:
                                    friend.imageUrl == null ||
                                            friend.imageUrl!.isEmpty
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
                                          friend.age.toString(),
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
                                          friend.weight.toString(),
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
                isVisible: _selectedBikingFriend != null,
              ),
            ),
          ],
        );
      },
    );
  }
}

DecorationImage? _buildFriendImage(String? imageUrl) {
  final provider = _createImageProvider(imageUrl);
  if (provider == null) {
    return null;
  }

  return DecorationImage(image: provider, fit: BoxFit.cover);
}

ImageProvider? _createImageProvider(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(imageUrl);
  if (uri != null && uri.hasScheme) {
    return NetworkImage(imageUrl);
  }

  return AssetImage(imageUrl);
}
