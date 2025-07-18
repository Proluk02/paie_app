import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../services/bd_service.dart';
import 'ajouter_etudiant.dart';
import 'details_etudiant.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final BDService _bd = BDService();
  List<Etudiant> _etudiants = [];
  String _recherche = '';

  @override
  void initState() {
    super.initState();
    _chargerEtudiants();
  }

  Future<void> _chargerEtudiants() async {
    final liste = await _bd.getEtudiants();
    setState(() {
      _etudiants = liste;
    });
  }

  Future<void> _ouvrirAjouterEtudiant() async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterEtudiantPage()),
    );
    if (resultat == true) await _chargerEtudiants();
  }

  void _ouvrirDetailsEtudiant(Etudiant etudiant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsEtudiantPage(etudiant: etudiant),
      ),
    );
  }

  void _modifierEtudiant(Etudiant etudiant) {
    // TODO: Implémenter l'écran de modification
    // Exemple : Navigator.push vers une page ModifierEtudiantPage
  }

  void _supprimerEtudiant(int? id) async {
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID étudiant invalide, suppression impossible'),
        ),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: const Text(
              'Voulez-vous vraiment supprimer cet étudiant ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _bd.supprimerEtudiant(id);
      await _chargerEtudiants();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Étudiant supprimé avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final etudiantsFiltres =
        _etudiants.where((e) {
          final rechercheLower = _recherche.toLowerCase();
          return e.nom.toLowerCase().contains(rechercheLower) ||
              e.postnom.toLowerCase().contains(rechercheLower) ||
              e.matricule.toLowerCase().contains(rechercheLower);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des étudiants'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher un étudiant...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
              onChanged: (val) => setState(() => _recherche = val),
            ),
          ),
          Expanded(
            child:
                etudiantsFiltres.isEmpty
                    ? const Center(
                      child: Text(
                        "Aucun étudiant trouvé.",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: etudiantsFiltres.length,
                      itemBuilder: (context, index) {
                        final e = etudiantsFiltres[index];
                        return Card(
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Text(
                                e.nom.isNotEmpty ? e.nom[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              "${e.nom} ${e.postnom}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Matricule : ${e.matricule}"),
                                Text(
                                  "Classe : ${e.classe}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  e.sexe.toLowerCase() == 'f'
                                      ? Icons.female
                                      : Icons.male,
                                  color: Colors.blueAccent,
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'modifier') {
                                      _modifierEtudiant(e);
                                    } else if (value == 'supprimer') {
                                      _supprimerEtudiant(e.id);
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                        PopupMenuItem(
                                          value: 'modifier',
                                          child: Text('Modifier'),
                                        ),
                                        PopupMenuItem(
                                          value: 'supprimer',
                                          child: Text('Supprimer'),
                                        ),
                                      ],
                                ),
                              ],
                            ),
                            onTap: () => _ouvrirDetailsEtudiant(e),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ouvrirAjouterEtudiant,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add),
        label: const Text(
          'Ajouter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
