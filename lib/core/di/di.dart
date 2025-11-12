import 'package:tal3a/features/activites/presentation/controllers/tal3a_type_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/training_cubit.dart';
import 'package:tal3a/features/activites/presentation/controllers/choose_tal3a_type_cubit.dart';

// Factory functions for creating cubits for different features
Tal3aTypeCubit createTal3aTypeCubit() => Tal3aTypeCubit();
Tal3aTypeCubit createWalkingCubit() => Tal3aTypeCubit();
Tal3aTypeCubit createBikingCubit() => Tal3aTypeCubit();

// Training-specific cubit
TrainingCubit createTrainingCubit() => TrainingCubit();

// Feature selection cubit
ChooseTal3aTypeCubit createChooseTal3aTypeCubit() => ChooseTal3aTypeCubit();
