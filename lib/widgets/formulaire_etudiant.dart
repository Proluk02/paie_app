// lib/widgets/formulaire_etudiant.dart

import 'package:flutter/material.dart';

class FormulaireEtudiant extends StatelessWidget {
  final TextEditingController nomController;
  final TextEditingController postnomController;
  final TextEditingController prenomController;
  final TextEditingController matriculeController;
  final TextEditingController sexeController;
  final TextEditingController classeController;
  final VoidCallback onSubmit;

  const FormulaireEtudiant({
    super.key,
    required this.nomController,
    required this.postnomController,
    required this.prenomController,
    required this.matriculeController,
    required this.sexeController,
    required this.classeController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: postnomController,
              decoration: const InputDecoration(
                labelText: 'Postnom',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: matriculeController,
              decoration: const InputDecoration(
                labelText: 'Matricule',
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value:
                  sexeController.text.isNotEmpty ? sexeController.text : null,
              items:
                  ['Masculin', 'Féminin']
                      .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)),
                      )
                      .toList(),
              onChanged: (val) {
                sexeController.text = val!;
              },
              decoration: const InputDecoration(
                labelText: 'Sexe',
                prefixIcon: Icon(Icons.wc),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value:
                  classeController.text.isNotEmpty
                      ? classeController.text
                      : null,
              items:
                  ['G1 Info', 'G2 Info', 'L1 Info', 'L2 Info']
                      .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)),
                      )
                      .toList(),
              onChanged: (val) {
                classeController.text = val!;
              },
              decoration: const InputDecoration(
                labelText: 'Promotion',
                prefixIcon: Icon(Icons.class_),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_alt),
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                label: const Text(
                  'Enregistrer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
