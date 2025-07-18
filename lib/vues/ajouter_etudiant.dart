import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../services/bd_service.dart';
import '../widgets/formulaire_etudiant.dart';

class AjouterEtudiantPage extends StatefulWidget {
  const AjouterEtudiantPage({super.key});

  @override
  State<AjouterEtudiantPage> createState() => _AjouterEtudiantPageState();
}

class _AjouterEtudiantPageState extends State<AjouterEtudiantPage> {
  final _bd = BDService();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController postnomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController sexeController = TextEditingController();
  final TextEditingController classeController = TextEditingController();

  bool _isSaving = false;

  Future<void> _enregistrerEtudiant() async {
    setState(() => _isSaving = true);
    final etudiant = Etudiant(
      nom: nomController.text.trim(),
      postnom: postnomController.text.trim(),
      prenom: prenomController.text.trim(),
      matricule: matriculeController.text.trim(),
      sexe: sexeController.text.trim(),
      classe: classeController.text.trim(),
    );
    try {
      await _bd.ajouterEtudiant(etudiant);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    postnomController.dispose();
    prenomController.dispose();
    matriculeController.dispose();
    sexeController.dispose();
    classeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un étudiant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormulaireEtudiant(
          nomController: nomController,
          postnomController: postnomController,
          prenomController: prenomController,
          matriculeController: matriculeController,
          sexeController: sexeController,
          classeController: classeController,
          onSubmit: _isSaving ? () {} : _enregistrerEtudiant,
        ),
      ),
    );
  }
}
