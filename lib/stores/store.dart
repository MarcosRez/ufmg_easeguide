import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Código gerado será incluído neste arquivo
part 'store.g.dart';

// Anotação para indicar que esta é uma classe de MobX store
class MyAppStore = _MyAppStore with _$MyAppStore;

abstract class _MyAppStore with Store {
  @observable
  ObservableList<Marker> markers = ObservableList<Marker>();

  @action
  void adicionarMarker(Marker marker) {
    markers.add(marker);
  }

  @action
  void adicionarCurrentLocationMarker(LatLng latLng) {
    markers.add(
      Marker(
        width: 150.0,
        height: 150.0,
        point: latLng,
        child: const Icon(
          Icons.my_location,
          color: Colors.blue,
          size: 35.0,
        ),
      ),
    );
  }
}
