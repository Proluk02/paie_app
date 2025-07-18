import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../services/bd_service.dart';

class ModifierEtudiantPage extends StatefulWidget {
  final Etudiant etudiant;
  const ModifierEtudiantPage({super.key, required this.etudiant});

  @override
  State<ModifierEtudiantPage> createState() => _ModifierEtudiantPageState();
}

class _ModifierEtudiantPageState extends State<ModifierEtudiantPage> {
  final _formKey = GlobalKey<FormState>();
  late String nom;
  late String postnom;
  late String prenom;
  late String matricule;
  late String sexe;
  late String classe;

  final BDService _bd = BDService();

  @override
  void initState() {
    super.initState();
    nom = widget.etudiant.nom;
    postnom = widget.etudiant.postnom;
    prenom = widget.etudiant.prenom;
    matricule = widget.etudiant.matricule;
    sexe = widget.etudiant.sexe;
    classe = widget.etudiant.classe;
  }

  Future<void> _enregistrer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final etudiantModifie = Etudiant(
        id: widget.etudiant.id,
        nom: nom,
        postnom: postnom,
        prenom: prenom,
        matricule: matricule,
        sexe: sexe,
        classe: classe,
      );
      await _bd.modifierEtudiant(etudiantModifie);
      Navigator.pop(context, true); // retourne true pour indiquer succès
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier Étudiant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: nom,
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (val) => nom = val ?? '',
                validator:
                    (val) => val == null || val.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                initialValue: postnom,
                decoration: const InputDecoration(labelText: 'Postnom'),
                onSaved: (val) => postnom = val ?? '',
                validator:
                    (val) => val == null || val.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                initialValue: prenom,
                decoration: const InputDecoration(labelText: 'Prénom'),
                onSaved: (val) => prenom = val ?? '',
                validator:
                    (val) => val == null || val.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                initialValue: matricule,
                decoration: const InputDecoration(labelText: 'Matricule'),
                onSaved: (val) => matricule = val ?? '',
                validator:
                    (val) => val == null || val.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                initialValue: sexe,
                decoration: const InputDecoration(labelText: 'Sexe (M/F)'),
                onSaved: (val) => sexe = val ?? '',
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Requis';
                  if (!['M', 'F', 'm', 'f'].contains(val))
                    return 'M ou F uniquement';
                  return null;
                },
              ),
              TextFormField(
                initialValue: classe,
                decoration: const InputDecoration(labelText: 'Classe'),
                onSaved: (val) => classe = val ?? '',
                validator:
                    (val) => val == null || val.isEmpty ? 'Requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enregistrer,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
