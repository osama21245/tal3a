import 'package:flutter_bloc/flutter_bloc.dart';

enum ChooseTal3aTypeStatus { initial, loading, success, error }

class ChooseTal3aTypeState {
  final ChooseTal3aTypeStatus status;
  final String? error;
  final String? selectedFeature; // 'training', 'walking', 'biking'

  ChooseTal3aTypeState({
    required this.status,
    this.error,
    this.selectedFeature,
  });

  ChooseTal3aTypeState copyWith({
    ChooseTal3aTypeStatus? status,
    String? error,
    String? selectedFeature,
  }) {
    return ChooseTal3aTypeState(
      status: status ?? this.status,
      error: error ?? this.error,
      selectedFeature: selectedFeature ?? this.selectedFeature,
    );
  }
}

class ChooseTal3aTypeCubit extends Cubit<ChooseTal3aTypeState> {
  ChooseTal3aTypeCubit()
    : super(ChooseTal3aTypeState(status: ChooseTal3aTypeStatus.initial));

  // Select feature (training, walking, biking)
  void selectFeature(String feature) {
    emit(
      state.copyWith(
        status: ChooseTal3aTypeStatus.success,
        selectedFeature: feature,
      ),
    );
  }

  // Reset state
  void reset() {
    emit(ChooseTal3aTypeState(status: ChooseTal3aTypeStatus.initial));
  }

  // Get selected feature
  String? getSelectedFeature() {
    return state.selectedFeature;
  }
}
