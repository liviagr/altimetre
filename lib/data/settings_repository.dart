import 'dart:async';

import 'package:altimetre/domain/models/units.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  late final SharedPreferences _prefs;
  final Completer<void> _initCompleter = Completer();

  static const _temperatureUnitKey = 'temperature_unit';
  static const _pressureUnitKey = 'pressure_unit';
  static const _elevationUnitKey = 'elevation_unit';

  Future<void> _ensureInitialized() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _initCompleter.complete();
  }

  SettingsRepository({SharedPreferences? prefs}) {
    if (prefs != null) {
      _prefs = prefs;
      _initCompleter.complete();
    } else {
      _init();
    }
  }

  Future<TemperatureUnit> getTemperatureUnit() async {
    await _ensureInitialized();
    final unit =
        _prefs.getInt(_temperatureUnitKey) ?? TemperatureUnit.celsius.index;
    return TemperatureUnit.values[unit];
  }

  Future<PressureUnit> getPressureUnit() async {
    await _ensureInitialized();
    final unit = _prefs.getInt(_pressureUnitKey) ?? PressureUnit.inHg.index;
    return PressureUnit.values[unit];
  }

  Future<ElevationUnit> getElevationUnit() async {
    await _ensureInitialized();
    final unit = _prefs.getInt(_elevationUnitKey) ?? ElevationUnit.m.index;
    return ElevationUnit.values[unit];
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await _ensureInitialized();
    await _prefs.setInt(_temperatureUnitKey, unit.index);
  }

  Future<void> setPressureUnit(PressureUnit unit) async {
    await _ensureInitialized();
    await _prefs.setInt(_pressureUnitKey, unit.index);
  }

  Future<void> setElevationUnit(ElevationUnit unit) async {
    await _ensureInitialized();
    await _prefs.setInt(_elevationUnitKey, unit.index);
  }
}
