import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modeles/etudiant.dart';
import '../modeles/paiement.dart';

class BDService {
  static Database? _bd;

  Future<Database> get database async {
    if (_bd != null) return _bd!;
    _bd = await _initBD();
    return _bd!;
  }

  Future<Database> _initBD() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gestion_frais.db');

    return await openDatabase(path, version: 1, onCreate: _creerBD);
  }

  Future<void> _creerBD(Database db, int version) async {
    await db.execute('''
      CREATE TABLE etudiants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        postnom TEXT,
        prenom TEXT,
        matricule TEXT,
        sexe TEXT,
        classe TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE paiements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        etudiantId INTEGER,
        montant REAL,
        motif TEXT,
        date TEXT,
        FOREIGN KEY (etudiantId) REFERENCES etudiants (id)
      )
    ''');
  }

  Future<int> ajouterEtudiant(Etudiant etudiant) async {
    final db = await database;
    return await db.insert('etudiants', etudiant.toMap());
  }

  Future<List<Etudiant>> getEtudiants() async {
    final db = await database;
    final resultats = await db.query('etudiants');
    return resultats.map((e) => Etudiant.fromMap(e)).toList();
  }

  Future<int> supprimerEtudiant(int id) async {
    final db = await database;
    return await db.delete('etudiants', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> ajouterPaiement(Paiement paiement) async {
    final db = await database;
    return await db.insert('paiements', paiement.toMap());
  }

  Future<List<Paiement>> getPaiementsParEtudiant(int etudiantId) async {
    final db = await database;
    final resultats = await db.query(
      'paiements',
      where: 'etudiantId = ?',
      whereArgs: [etudiantId],
    );
    return resultats.map((e) => Paiement.fromMap(e)).toList();
  }
}
