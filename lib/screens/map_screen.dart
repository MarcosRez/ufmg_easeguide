import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import '../stores/store.dart';
import 'form_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MyAppStore _store = MyAppStore();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _store.loadMarkers(); // Carrega os marcadores salvos
    _determinePosition().then((position) {
      final currentLocation = LatLng(position.latitude, position.longitude);
      _store.adicionarCurrentLocationMarker(currentLocation);
      _mapController.move(
          currentLocation, 15.0); // Move o mapa para a localização atual
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização está desabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização negada permanentemente.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> handleTap(TapPosition tapPosition, LatLng latLng) async {
    final result = await Navigator.of(context)
        .push<Map<String, dynamic>>(MaterialPageRoute(
      builder: (context) => FormScreen(markerData: {'latLng': latLng}),
    ));

    if (result != null) {
      // Define a cor do ícone com base no valor do slider
      Color markerColor;
      double sliderValue = result['accessibilityRating'];

      markerColor = _store.getMarkerColor(sliderValue) ?? Colors.red;

      _store.adicionarMarker({
        ...result,
        'color': _store.getMarkerColor(result['accessibilityRating'])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ease Guide'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-19.869877, -43.963891),
              initialZoom: 9.2,
              onTap: handleTap,
            ),
            mapController: _mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              Observer(
                builder: (context) {
                  return MarkerLayer(
                    key: ValueKey(_store.markers.length),
                    markers: _store.markers.map((marker) {
                      return Marker(
                        width: marker['width'] ?? 150.0,
                        height: marker['height'] ?? 150.0,
                        point: marker['latLng'],
                        child: GestureDetector(
                          onTap: () => handleMarkerTap(marker),
                          child: Icon(
                            Icons.location_on,
                            color: marker['color'] ?? Colors.red,
                            size: 35.0,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> handleMarkerTap(Map<String, dynamic> markerData) async {
    final result = await Navigator.of(context)
        .push<Map<String, dynamic>>(MaterialPageRoute(
      builder: (context) => FormScreen(markerData: markerData),
    ));

    if (result != null) {
      _store.updateMarker(markerData, {
        ...result,
        'color': _store.getMarkerColor(result['accessibilityRating'])
      });
    }
  }
}
