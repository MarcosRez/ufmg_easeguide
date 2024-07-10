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

    // Verifica se o serviço de localização está habilitado
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

    // Retorna a posição atual do dispositivo
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    // Função para lidar com o toque no mapa
    Future<void> handleTap(TapPosition tapPosition, LatLng latLng) async {
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FormScreen(latLng: latLng),
      ));

      if (result != null) {
        _store.adicionarMarker(
          Marker(
            width: 150.0,
            height: 150.0,
            point: latLng,
            child: Column(
              children: [
                Text(result['name']),
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 35.0,
                ),
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map App'),
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
                    markers: _store.markers,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
