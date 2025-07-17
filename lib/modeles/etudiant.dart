class Etudiant {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String matricule;
  final String sexe;
  final String classe;

  Etudiant({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.matricule,
    required this.sexe,
    required this.classe,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'matricule': matricule,
      'sexe': sexe,
      'classe': classe,
    };
  }

  factory Etudiant.fromMap(Map<String, dynamic> map) {
    return Etudiant(
      id: map['id'],
      nom: map['nom'],
      postnom: map['postnom'],
      prenom: map['prenom'],
      matricule: map['matricule'],
      sexe: map['sexe'],
      classe: map['classe'],
    );
  }
}
