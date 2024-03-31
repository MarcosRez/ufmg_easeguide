import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:proj_multidisciplinar_ufmg/src/screens/screens.dart';

class MyAppStore {
  @observable
  ObservableList<Marker> markers = ObservableList<Marker>();

  @action
  void adicionarMarker(Marker marker) {
    markers.add(marker);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyAppStore _store = MyAppStore();
  final screens = Screens();

  @override
  Widget build(BuildContext context) {
    void handleTap(TapPosition tapPosition, LatLng latLng) {
      _store.adicionarMarker(
        Marker(
            width: 150.0,
            height: 150.0,
            point: latLng,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 35.0,
            )),
      );
    }

    // return Column(
    //   children: [screens.home, screens.list],
    // );

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(51.509364, -0.128928),
            initialZoom: 9.2,
            onTap: handleTap,
          ),
          mapController: MapController(),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: _store.markers)
          ],
        )
      ],
    );
  }
}
