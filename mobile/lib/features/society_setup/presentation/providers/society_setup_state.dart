import 'package:equatable/equatable.dart';
import '../../domain/entities/house_unit.dart';
import '../../domain/entities/maintenance_config.dart';
import '../../domain/entities/society_profile.dart';
import '../../domain/entities/wing_config.dart';

/// Master State representation for Multi-Step Society Setup Wizard.
class SocietySetupState extends Equatable {
  final int currentStep; // 0 to 7
  final bool isLoading;
  final bool isSubmitting;
  final bool isDraftSaved;
  final SocietyProfile profile;
  final List<WingConfig> wings;
  final List<HouseUnit> generatedHouses;
  final MaintenanceConfig maintenanceConfig;
  final String? errorMessage;
  final bool isCompleted;

  const SocietySetupState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isDraftSaved = false,
    required this.profile,
    this.wings = const [
      WingConfig(id: 'wing_a', name: 'Wing A', totalFloors: 4, flatsPerFloor: 4, displayOrder: 0),
      WingConfig(id: 'wing_b', name: 'Wing B', totalFloors: 4, flatsPerFloor: 4, displayOrder: 1),
    ],
    this.generatedHouses = const [],
    this.maintenanceConfig = const MaintenanceConfig(),
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
    bool? isDraftSaved,
    SocietyProfile? profile,
    List<WingConfig>? wings,
    List<HouseUnit>? generatedHouses,
    MaintenanceConfig? maintenanceConfig,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return SocietySetupState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      profile: profile ?? this.profile,
      wings: wings ?? this.wings,
      generatedHouses: generatedHouses ?? this.generatedHouses,
      maintenanceConfig: maintenanceConfig ?? this.maintenanceConfig,
      errorMessage: errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        isSubmitting,
        isDraftSaved,
        profile,
        wings,
        generatedHouses,
        maintenanceConfig,
        errorMessage,
        isCompleted,
      ];
}
