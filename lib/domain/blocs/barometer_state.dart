part of 'barometer_cubit.dart';

@immutable
class BarometerState extends Equatable {
  final double? pressure;
  final double? elevation;
  final double? gpsElevation;
  final double? temperature;

  const BarometerState({
    this.pressure,
    this.elevation,
    this.gpsElevation,
    this.temperature,
  });

  BarometerState copyWith({
    double? Function()? pressure,
    double? Function()? elevation,
    double? Function()? gpsElevation,
    double? Function()? temperature,
  }) {
    return BarometerState(
      pressure: pressure != null ? pressure() : this.pressure,
      elevation: elevation != null ? elevation() : this.elevation,
      gpsElevation: gpsElevation != null ? gpsElevation() : this.gpsElevation,
      temperature: temperature != null ? temperature() : this.temperature,
    );
  }

  @override
  List<Object?> get props => [pressure, elevation, gpsElevation, temperature];
}
