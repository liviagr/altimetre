part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.temperature = TemperatureUnit.celsius,
    this.pressure = PressureUnit.hPa,
    this.elevation = ElevationUnit.m,
  });

  final TemperatureUnit temperature;
  final PressureUnit pressure;
  final ElevationUnit elevation;

  @override
  List<Object> get props => [temperature, pressure, elevation];

  SettingsState copyWith({
    TemperatureUnit? temperature,
    PressureUnit? pressure,
    ElevationUnit? elevation,
  }) {
    return SettingsState(
      temperature: temperature ?? this.temperature,
      pressure: pressure ?? this.pressure,
      elevation: elevation ?? this.elevation,
    );
  }
}
