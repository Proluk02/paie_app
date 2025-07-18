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
        matricule TEXT UNIQUE,
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
        FOREIGN KEY (etudiantId) REFERENCES etudiants (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> ajouterEtudiant(Etudiant etudiant) async {
    final db = await database;
    return await db.insert(
      'etudiants',
      etudiant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Etudiant>> getEtudiants() async {
    final db = await database;
    final resultats = await db.query('etudiants', orderBy: 'nom ASC');
    return resultats.map((e) => Etudiant.fromMap(e)).toList();
  }

  Future<int> supprimerEtudiant(int id) async {
    final db = await database;
    return await db.delete('etudiants', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> modifierEtudiant(Etudiant etudiant) async {
    final db = await database;
    return await db.update(
      'etudiants',
      etudiant.toMap(),
      where: 'id = ?',
      whereArgs: [etudiant.id],
    );
  }

  Future<int> ajouterPaiement(Paiement paiement) async {
    final db = await database;
    return await db.insert('paiements', paiement.toMap());
  }

  Future<int> modifierPaiement(Paiement paiement) async {
    final db = await database;
    return await db.update(
      'paiements',
      paiement.toMap(),
      where: 'id = ?',
      whereArgs: [paiement.id],
    );
  }

  Future<int> supprimerPaiement(int id) async {
    final db = await database;
    return await db.delete('paiements', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Paiement>> getPaiementsParEtudiant(int etudiantId) async {
    final db = await database;
    final resultats = await db.query(
      'paiements',
      where: 'etudiantId = ?',
      whereArgs: [etudiantId],
      orderBy: 'date DESC',
    );
    return resultats.map((e) => Paiement.fromMap(e)).toList();
  }

  Future<List<Paiement>> getPaiementsParMatricule(String matricule) async {
    final db = await database;
    final etudiantResult = await db.query(
      'etudiants',
      where: 'matricule = ?',
      whereArgs: [matricule],
    );

    if (etudiantResult.isEmpty) return [];

    final etudiantId = etudiantResult.first['id'] as int;

    final paiementsResult = await db.query(
      'paiements',
      where: 'etudiantId = ?',
      whereArgs: [etudiantId],
      orderBy: 'date DESC',
    );

    return paiementsResult.map((e) => Paiement.fromMap(e)).toList();
  }

  Future<double> getMontantTotalParEtudiant(int etudiantId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(montant) as total FROM paiements WHERE etudiantId = ?',
      [etudiantId],
    );
    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }

  Future<double> getMontantTotalParMatricule(String matricule) async {
    final db = await database;
    final etudiant = await getEtudiantParMatricule(matricule);
    if (etudiant == null) return 0.0;
    return await getMontantTotalParEtudiant(etudiant.id!);
  }

  Future<Etudiant?> getEtudiantParMatricule(String matricule) async {
    final db = await database;
    final result = await db.query(
      'etudiants',
      where: 'matricule = ?',
      whereArgs: [matricule],
    );
    if (result.isNotEmpty) {
      return Etudiant.fromMap(result.first);
    }
    return null;
  }

  Future<double> getMontantTotalTousPaiements() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(montant) as total FROM paiements',
    );
    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }

  Future<int> getNombreTotalEtudiants() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM etudiants');
    return result.first['count'] != null ? result.first['count'] as int : 0;
  }

  Future<int> getNombreTotalPaiements() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM paiements');
    return result.first['count'] != null ? result.first['count'] as int : 0;
  }
}
