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
  double _accessibilityRating = 0.0;
  final _comments = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.markerData != null) {
      _nameController.text = widget.markerData!['name'] ?? '';
      _hasStairs = widget.markerData!['hasStairs'] ?? false;
      _hasRampsOrElevators = widget.markerData!['hasRampsOrElevators'] ?? false;
      _accessibilityRating =
          widget.markerData!['accessibilityRating']?.toDouble() ?? 0.0;
      _comments.text = widget.markerData!['comments'] ?? '';
    }
  }

  void _save() {
    final name = _nameController.text;
    final hasStairs = _hasStairs;
    final hasRampsOrElevators = _hasRampsOrElevators;
    final accessibilityRating = _accessibilityRating;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o nome.')),
      );
      return;
    }

    Navigator.of(context).pop({
      'latLng': widget.markerData?['latLng'] ?? const LatLng(0, 0),
      'name': name,
      'hasStairs': hasStairs,
      'hasRampsOrElevators': hasRampsOrElevators,
      'accessibilityRating': accessibilityRating,
      'comments': _comments.text
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
            ElevatedButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
            ElevatedButton(
              onPressed: _cancel,
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
