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
  ObservableList<Map<String, dynamic>> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableList<Map<String, dynamic>> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  late final _$adicionarMarkerAsyncAction =
      AsyncAction('_MyAppStore.adicionarMarker', context: context);

  @override
  Future<void> adicionarMarker(Map<String, dynamic> marker) {
    return _$adicionarMarkerAsyncAction
        .run(() => super.adicionarMarker(marker));
  }

  late final _$updateMarkerAsyncAction =
      AsyncAction('_MyAppStore.updateMarker', context: context);

  @override
  Future<void> updateMarker(
      Map<String, dynamic> oldMarker, Map<String, dynamic> newMarkerData) {
    return _$updateMarkerAsyncAction
        .run(() => super.updateMarker(oldMarker, newMarkerData));
  }

  late final _$adicionarCurrentLocationMarkerAsyncAction = AsyncAction(
      '_MyAppStore.adicionarCurrentLocationMarker',
      context: context);

  @override
  Future<void> adicionarCurrentLocationMarker(LatLng latLng) {
    return _$adicionarCurrentLocationMarkerAsyncAction
        .run(() => super.adicionarCurrentLocationMarker(latLng));
  }

  late final _$loadMarkersAsyncAction =
      AsyncAction('_MyAppStore.loadMarkers', context: context);

  @override
  Future<void> loadMarkers() {
    return _$loadMarkersAsyncAction.run(() => super.loadMarkers());
  }

  late final _$saveMarkersAsyncAction =
      AsyncAction('_MyAppStore.saveMarkers', context: context);

  @override
  Future<void> saveMarkers() {
    return _$saveMarkersAsyncAction.run(() => super.saveMarkers());
  }

  @override
  String toString() {
    return '''
markers: ${markers}
    ''';
  }
}
