import 'dart:async';

import 'package:altimetre/data/barometer_repository.dart';
import 'package:altimetre/data/settings_repository.dart';
import 'package:altimetre/domain/blocs/barometer_cubit.dart';
import 'package:altimetre/domain/blocs/settings_cubit.dart';
import 'package:altimetre/domain/models/units.dart';
import 'package:altimetre/presentation/home_page/widgets/gauge.dart';
import 'package:altimetre/presentation/paddings.dart';
import 'package:altimetre/presentation/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../utils/convert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _pressure = 0.0;
  StreamSubscription<BarometerEvent>? _subscription;

  @override
  void initState() {
    _subscription = barometerEventStream().listen((event) {
      setState(() {
        _pressure = event.pressure;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => BarometerCubit(
          barometerRepository: context.read<BarometerRepository>())
        ..listenUpdates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Voluptuaria'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RepositoryProvider(
                      create: (context) => SettingsRepository(),
                      child: BlocProvider(
                          create: (context) => SettingsCubit(
                              settingsRepository:
                                  context.read<SettingsRepository>())
                            ..loadSettings(),
                          child: const SettingsPage()),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<BarometerCubit, BarometerState>(
              builder: (context, barometerState) {
            return BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (barometerState.pressure != null) ...[
                    Gauge(value: barometerState.pressure!),
                    Text(
                      settingsState.pressure == PressureUnit.hPa
                          ? '${barometerState.pressure}hpa'
                          : '${hectopascalToInchesMercury(barometerState.pressure!)}inHg',
                      style: textTheme.displayMedium,
                    ),
                  ] else
                    Text(
                      "No data available",
                      style: textTheme.bodyLarge,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (barometerState.elevation != null)
                        Text(
                          "Measured: ${settingsState.elevation == ElevationUnit.m ? '${barometerState.elevation}m' : '${metersToFeet(barometerState.elevation!)}ft'}",
                          style: textTheme.bodyLarge,
                        )
                      else
                        Text(
                          "Measured: No data available",
                          style: textTheme.bodyLarge,
                        ),
                      const SizedBox(width: Paddings.large),
                      if (barometerState.gpsElevation != null)
                        Text(
                          "GPS: ${settingsState.elevation == ElevationUnit.m ? '${barometerState.gpsElevation}m' : '${metersToFeet(barometerState.gpsElevation!)}ft'}",
                          style: textTheme.bodyLarge,
                        )
                      else
                        Text(
                          "GPS: No data available",
                          style: textTheme.bodyLarge,
                        ),
                    ],
                  ),
                  if (barometerState.temperature != null)
                    Text(
                      "Temperature: ${settingsState.temperature == TemperatureUnit.celsius ? '${barometerState.temperature} °C' : '${celsiusToFahrenheit(barometerState.temperature!)} °F'}",
                      style: textTheme.bodyLarge,
                    )
                  else
                    Text(
                      "Temperature: No data available",
                      style: textTheme.bodyLarge,
                    )
                ],
              );
            });
          }),
        ),
      ),
    );
  }
}
