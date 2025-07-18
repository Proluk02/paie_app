// lib/widgets/formulaire_paiement.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormulairePaiement extends StatelessWidget {
  final TextEditingController montantController;
  final TextEditingController motifController;
  final TextEditingController dateController;
  final VoidCallback onSubmit;

  const FormulairePaiement({
    super.key,
    required this.montantController,
    required this.motifController,
    required this.dateController,
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
              controller: montantController,
              decoration: const InputDecoration(
                labelText: 'Montant',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: motifController,
              decoration: const InputDecoration(
                labelText: 'Motif',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date (aaaa-mm-jj)',
                prefixIcon: Icon(Icons.date_range),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.tryParse(dateController.text) ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dateController.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                label: const Text(
                  'Valider Paiement',
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
