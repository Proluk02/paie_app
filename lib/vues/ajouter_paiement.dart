import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modeles/etudiant.dart';
import '../modeles/paiement.dart';
import '../services/bd_service.dart';
import '../widgets/formulaire_paiement.dart';

class AjouterPaiementPage extends StatefulWidget {
  final Etudiant etudiant;
  const AjouterPaiementPage({super.key, required this.etudiant});

  @override
  State<AjouterPaiementPage> createState() => _AjouterPaiementPageState();
}

class _AjouterPaiementPageState extends State<AjouterPaiementPage> {
  final _bd = BDService();
  final montantController = TextEditingController();
  final motifController = TextEditingController();
  final dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  Future<void> _ajouterPaiement() async {
    final paiement = Paiement(
      etudiantId: widget.etudiant.id!,
      montant: double.tryParse(montantController.text) ?? 0.0,
      motif: motifController.text,
      date: dateController.text,
    );
    try {
      await _bd.ajouterPaiement(paiement);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  @override
  void dispose() {
    montantController.dispose();
    motifController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un paiement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormulairePaiement(
          montantController: montantController,
          motifController: motifController,
          dateController: dateController,
          onSubmit: _ajouterPaiement,
        ),
      ),
    );
  }
}
