import 'package:altimetre/data/settings_repository.dart';
import 'package:altimetre/domain/models/units.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsCubit({
    SettingsRepository? settingsRepository,
  })  : _settingsRepository = settingsRepository ?? SettingsRepository(),
        super(SettingsState());

  Future<void> loadSettings() async {
    final temperature = await _settingsRepository.getTemperatureUnit();
    final pressure = await _settingsRepository.getPressureUnit();
    final elevation = await _settingsRepository.getElevationUnit();

    emit(
      SettingsState(
        temperature: temperature,
        pressure: pressure,
        elevation: elevation,
      ),
    );
  }

  Future<void> updateTemperatureUnit(TemperatureUnit unit) async {
    await _settingsRepository.setTemperatureUnit(unit);
    emit(state.copyWith(temperature: unit));
  }

  Future<void> updatePressureUnit(PressureUnit unit) async {
    await _settingsRepository.setPressureUnit(unit);
    emit(state.copyWith(pressure: unit));
  }

  Future<void> updateElevationUnit(ElevationUnit unit) async {
    await _settingsRepository.setElevationUnit(unit);
    emit(state.copyWith(elevation: unit));
  }
}
