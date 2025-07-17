import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../services/bd_service.dart';
import 'ajouter_etudiant.dart';
import 'details_etudiant.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State createState() => _AccueilPageState();
}

class _AccueilPageState extends State {
  final BDService _bd = BDService();
  List<Etudiant> _etudiants = [];

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
    if (resultat == true) {
      await _chargerEtudiants();
    }
  }

  void _ouvrirDetailsEtudiant(Etudiant etudiant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsEtudiantPage(etudiant: etudiant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Étudiants",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body:
          _etudiants.isEmpty
              ? const Center(
                child: Text(
                  "Aucun étudiant trouvé.",
                  style: TextStyle(fontSize: 17),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                itemCount: _etudiants.length,
                itemBuilder: (context, index) {
                  final e = _etudiants[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          e.nom[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "${e.nom} ${e.postnom}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        size: 28,
                        color: Colors.blueAccent,
                      ),
                      onTap: () => _ouvrirDetailsEtudiant(e),
                    ),
                  );
                },
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
