import 'package:equatable/equatable.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/entities/wing_config.dart';

/// State representation for Multi-Step Society Setup Wizard.
class SocietySetupState extends Equatable {
  final int currentStep; // 0 to 5
  final bool isLoading;
  final bool isSubmitting;
  final SocietyProfile profile;
  final List<WingConfig> wings;
  final List<HouseUnit> generatedHouses;
  final double defaultMaintenanceAmount;
  final int maintenanceDueDate;
  final String? errorMessage;
  final bool isCompleted;

  const SocietySetupState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isSubmitting = false,
    required this.profile,
    this.wings = const [
      WingConfig(id: 'wing_a', name: 'Wing A', totalFloors: 4, flatsPerFloor: 4),
      WingConfig(id: 'wing_b', name: 'Wing B', totalFloors: 4, flatsPerFloor: 4),
    ],
    this.generatedHouses = const [],
    this.defaultMaintenanceAmount = 2500.0,
    this.maintenanceDueDate = 5,
    this.errorMessage,
    this.isCompleted = false,
  });

  factory SocietySetupState.initial() {
    return SocietySetupState(
      profile: SocietyProfile.initial(),
    );
  }

  SocietySetupState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isSubmitting,
    SocietyProfile? profile,
    List<WingConfig>? wings,
    List<HouseUnit>? generatedHouses,
    double? defaultMaintenanceAmount,
    int? maintenanceDueDate,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return SocietySetupState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      profile: profile ?? this.profile,
      wings: wings ?? this.wings,
      generatedHouses: generatedHouses ?? this.generatedHouses,
      defaultMaintenanceAmount: defaultMaintenanceAmount ?? this.defaultMaintenanceAmount,
      maintenanceDueDate: maintenanceDueDate ?? this.maintenanceDueDate,
      errorMessage: errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        isSubmitting,
        profile,
        wings,
        generatedHouses,
        defaultMaintenanceAmount,
        maintenanceDueDate,
        errorMessage,
        isCompleted,
      ];
}
