import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FormScreen extends StatefulWidget {
  final LatLng latLng;

  const FormScreen({Key? key, required this.latLng}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  bool hasStairs = false;
  bool hasRampsOrElevators = false;
  double accessibilityRating = 0;
  String? comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Local'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value;
                },
              ),
              SwitchListTile(
                title: const Text('O local possui escadas?'),
                value: hasStairs,
                onChanged: (value) {
                  setState(() {
                    hasStairs = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('O local possui rampas ou elevadores?'),
                value: hasRampsOrElevators,
                onChanged: (value) {
                  setState(() {
                    hasRampsOrElevators = value;
                  });
                },
              ),
              const Text('Termômetro de acessibilidade'),
              Slider(
                value: accessibilityRating,
                onChanged: (value) {
                  setState(() {
                    accessibilityRating = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 10,
                label: accessibilityRating.round().toString(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Comentários'),
                maxLines: 3,
                onSaved: (value) {
                  comments = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.of(context).pop({
                          'name': name,
                          'hasStairs': hasStairs,
                          'hasRampsOrElevators': hasRampsOrElevators,
                          'accessibilityRating': accessibilityRating,
                          'comments': comments,
                          'latLng': widget.latLng,
                        });
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
