// Settings Status Enum
enum SettingsStatus {
  initial,
  loading,
  success,
  error,
  notificationToggled,
  logout,
}

// Extension for easy state checking
extension SettingsStateExtension on SettingsState {
  bool get isInitial => status == SettingsStatus.initial;
  bool get isLoading => status == SettingsStatus.loading;
  bool get isSuccess => status == SettingsStatus.success;
  bool get isError => status == SettingsStatus.error;
  bool get isNotificationToggled =>
      status == SettingsStatus.notificationToggled;
  bool get isLogout => status == SettingsStatus.logout;
}

// Settings State Class
class SettingsState {
  final SettingsStatus status;
  final String? error;
  final bool isNotificationEnabled;
  final bool isLoggingOut;

  SettingsState({
    this.status = SettingsStatus.initial,
    this.error,
    this.isNotificationEnabled = true,
    this.isLoggingOut = false,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    String? error,
    bool? isNotificationEnabled,
    bool? isLoggingOut,
  }) {
    return SettingsState(
      status: status ?? this.status,
      error: error ?? this.error,
      isNotificationEnabled:
          isNotificationEnabled ?? this.isNotificationEnabled,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  String toString() =>
      'SettingsState(status: $status, error: $error, isNotificationEnabled: $isNotificationEnabled, isLoggingOut: $isLoggingOut)';
}
