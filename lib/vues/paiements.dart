import 'package:flutter/material.dart';
import '../modeles/paiement.dart';
import '../services/bd_service.dart';

class PaiementsPage extends StatefulWidget {
  final String matricule; // Matricule de l'étudiant

  const PaiementsPage({super.key, required this.matricule});

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  final BDService _bd = BDService();
  List<Paiement> _paiements = [];

  @override
  void initState() {
    super.initState();
    _chargerPaiements();
  }

  Future<void> _chargerPaiements() async {
    final paiements = await _bd.getPaiementsParMatricule(widget.matricule);
    setState(() {
      _paiements = paiements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
        backgroundColor: Colors.blueAccent,
      ),
      body:
          _paiements.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Aucun paiement trouvé.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _paiements.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final p = _paiements[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.green),
                      title: Text('${p.montant} FC'),
                      subtitle: Text('Motif : ${p.motif}\nDate : ${p.date}'),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
    );
  }
}
