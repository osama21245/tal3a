import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void toggleNotification(bool isEnabled) {
    emit(
      state.copyWith(
        status: SettingsStatus.notificationToggled,
        isNotificationEnabled: isEnabled,
      ),
    );
  }

  void logout() {
    emit(state.copyWith(status: SettingsStatus.logout, isLoggingOut: true));
  }

  void resetState() {
    emit(SettingsState());
  }
}
