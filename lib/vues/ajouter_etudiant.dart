import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../services/bd_service.dart';

class AjouterEtudiantPage extends StatefulWidget {
  const AjouterEtudiantPage({super.key});

  @override
  State<AjouterEtudiantPage> createState() => _AjouterEtudiantPageState();
}

class _AjouterEtudiantPageState extends State<AjouterEtudiantPage> {
  final _formKey = GlobalKey<FormState>();
  final _bd = BDService();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController postnomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController sexeController = TextEditingController();
  final TextEditingController classeController = TextEditingController();

  bool _isSaving = false;

  Future<void> _enregistrerEtudiant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Étudiant ajouté avec succès !')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout : $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator:
            (value) =>
                value == null || value.trim().isEmpty
                    ? 'Ce champ est requis'
                    : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un étudiant'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(label: 'Nom', controller: nomController),
              _buildTextField(label: 'Postnom', controller: postnomController),
              _buildTextField(label: 'Prénom', controller: prenomController),
              _buildTextField(
                label: 'Matricule',
                controller: matriculeController,
              ),
              _buildTextField(label: 'Sexe', controller: sexeController),
              _buildTextField(label: 'Classe', controller: classeController),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon:
                      _isSaving
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _isSaving ? null : _enregistrerEtudiant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
