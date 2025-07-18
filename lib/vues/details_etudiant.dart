import 'package:flutter/material.dart';
import '../modeles/etudiant.dart';
import '../modeles/paiement.dart';
import '../services/bd_service.dart';
import 'ajouter_paiement.dart';

class DetailsEtudiantPage extends StatefulWidget {
  final Etudiant etudiant;
  const DetailsEtudiantPage({super.key, required this.etudiant});

  @override
  State<DetailsEtudiantPage> createState() => _DetailsEtudiantPageState();
}

class _DetailsEtudiantPageState extends State<DetailsEtudiantPage> {
  final _bd = BDService();
  List<Paiement> paiements = [];

  @override
  void initState() {
    super.initState();
    _chargerPaiements();
  }

  Future<void> _chargerPaiements() async {
    final liste = await _bd.getPaiementsParEtudiant(widget.etudiant.id!);
    setState(() {
      paiements = liste;
    });
  }

  void _allerAjoutPaiement() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AjouterPaiementPage(etudiant: widget.etudiant),
      ),
    );
    _chargerPaiements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.etudiant.nom} - Paiements')),
      body: ListView.builder(
        itemCount: paiements.length,
        itemBuilder: (context, index) {
          final p = paiements[index];
          return ListTile(
            title: Text('${p.montant.toStringAsFixed(2)} CDF'),
            subtitle: Text('${p.motif} - ${p.date}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _allerAjoutPaiement,
        child: const Icon(Icons.payment),
      ),
    );
  }
}
