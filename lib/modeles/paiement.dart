class Paiement {
  final int? id;
  final int etudiantId;
  final double montant;
  final String motif;
  final String date;

  Paiement({
    this.id,
    required this.etudiantId,
    required this.montant,
    required this.motif,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'etudiantId': etudiantId,
      'montant': montant,
      'motif': motif,
      'date': date,
    };
  }

  factory Paiement.fromMap(Map<String, dynamic> map) {
    return Paiement(
      id: map['id'],
      etudiantId: map['etudiantId'],
      montant: map['montant'],
      motif: map['motif'],
      date: map['date'],
    );
  }
}
