import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'store.g.dart';

class MyAppStore = _MyAppStore with _$MyAppStore;

abstract class _MyAppStore with Store {
  @observable
  ObservableList<Map<String, dynamic>> markers =
      ObservableList<Map<String, dynamic>>();

  @action
  Future<void> adicionarMarker(Map<String, dynamic> marker) async {
    markers.add(marker);
    await saveMarkers(); // Chamada assíncrona para salvar marcadores
  }

  @action
  Future<void> updateMarker(Map<String, dynamic> oldMarker,
      Map<String, dynamic> newMarkerData) async {
    markers.removeWhere((marker) =>
        marker['latLng'].latitude == oldMarker['latLng'].latitude &&
        marker['latLng'].longitude == oldMarker['latLng'].longitude);
    adicionarMarker(newMarkerData);
  }

  @action
  Future<void> adicionarCurrentLocationMarker(LatLng latLng) async {
    markers.add({
      'latLng': latLng,
      'width': 150.0,
      'height': 150.0,
      'icon': Icons.my_location,
      'color': Colors.blue,
      'name': '',
      'hasStairs': false,
      'hasRampsOrElevators': false
    });
    await saveMarkers();
  }

  @action
  Future<void> loadMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    final markersJson = prefs.getString('markers') ?? '[]';

    try {
      final List<dynamic> markerList = json.decode(markersJson);
      markers.clear();
      for (var markerData in markerList) {
        markers.add(markerData);
      }
    } catch (e) {
      markers.clear();
      print('Erro ao carregar marcadores: $e');
    }
  }

  @action
  Future<void> saveMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    print(markers);
    final Iterable<Map<String, dynamic>> markerList = markers.map((marker) {
      final latLng = marker['latLng'];
      final iconColor = marker['color'];
      return {
        'lat': latLng.latitude ?? 0,
        'lng': latLng.longitude ?? 0,
        'name': marker['name'] ?? '',
        'hasStairs': marker['hasStairs'] ?? false,
        'hasRampsOrElevators': marker['hasRampsOrElevators'] ?? false,
        'accessibilityThermometer': marker['accessibilityRating'] ?? 0,
        'comments': marker['comments']
      };
    });

    final markersJson = json.encode(markerList.toList());
    await prefs.setString('markers', markersJson);
  }

  // Converte a cor do ícone para um valor de termômetro
  double? _getThermometerValueFromColor(Color? color) {
    Map<Color, double> colorDict = {
      const Color.fromARGB(255, 171, 41, 41): 0,
      Colors.red: 1,
      const Color.fromARGB(255, 244, 101, 54): 2,
      const Color.fromARGB(255, 244, 139, 54): 3,
      const Color.fromARGB(255, 244, 174, 54): 4,
      const Color.fromARGB(255, 255, 234, 7): 5,
      const Color.fromARGB(255, 226, 255, 7): 6,
      const Color.fromARGB(255, 185, 255, 7): 7,
      const Color.fromARGB(255, 147, 255, 7): 8,
      const Color.fromARGB(255, 77, 255, 7): 9,
      const Color.fromARGB(255, 7, 255, 61): 10,
    };

    return colorDict[color];
  }

  // Converte o valor do termômetro para a cor do ícone
  Color? getMarkerColor(double value) {
    Map<double, Color> colorDict = {
      0: const Color.fromARGB(255, 171, 41, 41),
      1: Colors.red,
      2: const Color.fromARGB(255, 244, 101, 54),
      3: const Color.fromARGB(255, 244, 139, 54),
      4: const Color.fromARGB(255, 244, 174, 54),
      5: const Color.fromARGB(255, 255, 234, 7),
      6: const Color.fromARGB(255, 226, 255, 7),
      7: const Color.fromARGB(255, 185, 255, 7),
      8: const Color.fromARGB(255, 147, 255, 7),
      9: const Color.fromARGB(255, 77, 255, 7),
      10: const Color.fromARGB(255, 7, 255, 61)
    };

    return colorDict[value];
  }
}
