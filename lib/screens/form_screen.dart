import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FormScreen extends StatefulWidget {
  final Map<String, dynamic>? markerData;

  const FormScreen({Key? key, this.markerData}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _nameController = TextEditingController();
  bool _hasStairs = false;
  bool _hasRampsOrElevators = false;
  bool _hasAccessibleBathrooms = false;
  bool _hasGoodSpaceForMovement = false;
  double _accessibilityRating = 0.0;
  final _comments = TextEditingController();
  List<Map<String, dynamic>> _ratings = [];

  @override
  void initState() {
    super.initState();

    if (widget.markerData != null) {
      _nameController.text = widget.markerData!['name'] ?? '';
      _hasStairs = widget.markerData!['hasStairs'] ?? false;
      _hasRampsOrElevators = widget.markerData!['hasRampsOrElevators'] ?? false;
      _hasAccessibleBathrooms =
          widget.markerData!['hasAccessibleBathrooms'] ?? false;
      _hasGoodSpaceForMovement =
          widget.markerData!['hasGoodSpaceForMovement'] ?? false;
      _accessibilityRating =
          widget.markerData!['accessibilityRating']?.toDouble() ?? 0.0;
      _comments.text = '';
      _ratings =
          List<Map<String, dynamic>>.from(widget.markerData!['ratings'] ?? []);
    }
  }

  void _save() {
    final name = _nameController.text;
    final hasStairs = _hasStairs;
    final hasRampsOrElevators = _hasRampsOrElevators;
    final hasAccessibleBathrooms = _hasAccessibleBathrooms;
    final hasGoodSpaceForMovement = _hasGoodSpaceForMovement;
    final accessibilityRating = _accessibilityRating;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o nome.')),
      );
      return;
    }

    _ratings.add({
      'rating': accessibilityRating,
      'comment': _comments.text,
      'hasStairs': hasStairs,
      'hasRampsOrElevators': hasRampsOrElevators,
      'hasAccessibleBathrooms': hasAccessibleBathrooms,
      'hasGoodSpaceForMovement': hasGoodSpaceForMovement,
    });

    Navigator.of(context).pop({
      'latLng': widget.markerData?['latLng'] ?? const LatLng(0, 0),
      'name': name,
      'hasStairs': hasStairs,
      'hasRampsOrElevators': hasRampsOrElevators,
      'hasAccessibleBathrooms': hasAccessibleBathrooms,
      'hasGoodSpaceForMovement': hasGoodSpaceForMovement,
      'accessibilityRating': accessibilityRating,
      'comments': _comments.text,
      'ratings': _ratings,
    });
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            Row(
              children: [
                const Text('O local possui escadas?'),
                Switch(
                  value: _hasStairs,
                  onChanged: (value) {
                    setState(() {
                      _hasStairs = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('O local possui rampas ou elevadores?'),
                Switch(
                  value: _hasRampsOrElevators,
                  onChanged: (value) {
                    setState(() {
                      _hasRampsOrElevators = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('O local possui banheiros acessíveis?'),
                Switch(
                  value: _hasAccessibleBathrooms,
                  onChanged: (value) {
                    setState(() {
                      _hasAccessibleBathrooms = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('O local possui bom espaço para movimentação?'),
                Switch(
                  value: _hasGoodSpaceForMovement,
                  onChanged: (value) {
                    setState(() {
                      _hasGoodSpaceForMovement = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text('Termômetro de acessibilidade'),
                Expanded(
                  child: Slider(
                    value: _accessibilityRating,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _accessibilityRating.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _accessibilityRating = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Comentários'),
              maxLines: 3,
              controller: _comments,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Salvar'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _cancel,
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _ratings.length,
                itemBuilder: (context, index) {
                  final rating = _ratings[index];
                  return ListTile(
                    title: Text('Nota: ${rating['rating']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comentário: ${rating['comment']}'),
                        Text(
                            'Possui escadas: ${rating['hasStairs'] ? "Sim" : "Não"}'),
                        Text(
                            'Possui rampas ou elevadores: ${rating['hasRampsOrElevators'] ? "Sim" : "Não"}'),
                        Text(
                            'Possui banheiros acessíveis: ${rating['hasAccessibleBathrooms'] ? "Sim" : "Não"}'),
                        Text(
                            'Bom espaço para movimentação: ${rating['hasGoodSpaceForMovement'] ? "Sim" : "Não"}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
