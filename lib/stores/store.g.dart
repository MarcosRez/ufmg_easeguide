// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MyAppStore on _MyAppStore, Store {
  late final _$markersAtom =
      Atom(name: '_MyAppStore.markers', context: context);

  @override
  ObservableList<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableList<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  late final _$_MyAppStoreActionController =
      ActionController(name: '_MyAppStore', context: context);

  @override
  void adicionarMarker(Marker marker) {
    final _$actionInfo = _$_MyAppStoreActionController.startAction(
        name: '_MyAppStore.adicionarMarker');
    try {
      return super.adicionarMarker(marker);
    } finally {
      _$_MyAppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void adicionarCurrentLocationMarker(LatLng latLng) {
    final _$actionInfo = _$_MyAppStoreActionController.startAction(
        name: '_MyAppStore.adicionarCurrentLocationMarker');
    try {
      return super.adicionarCurrentLocationMarker(latLng);
    } finally {
      _$_MyAppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
markers: ${markers}
    ''';
  }
}
