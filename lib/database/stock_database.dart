import 'package:jour6/models/product.dart';
import 'package:sqflite/sqflite.dart'; // Package pour utiliser SQLite dans Flutter
import 'package:path/path.dart'; // Package pour gérer les chemins de fichiers

class StockDatabase {
  // Instance unique de la classe (Singleton)
  static final StockDatabase instance = StockDatabase._init();

  // Variable qui contiendra la base de données
  static Database? _database;

  // Constructeur privé pour empêcher la création
  // de plusieurs instances de la base de données
  StockDatabase._init();

  // Getter pour accéder à la base de données
  // Si elle existe déjà, on la retourne
  // Sinon, on l'initialise
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialisation de la base de données
    _database = await _initDB('stock.db');
    return _database!;
  }

  // Méthode privée pour créer ou ouvrir la base de données
  Future<Database> _initDB(String fileName) async {
    // Récupère le chemin du dossier des bases de données
    final dbPath = await getDatabasesPath();

    // Construit le chemin complet vers le fichier stock.db
    final path = join(dbPath, fileName);

    // Ouvre la base de données
    // Si elle n'existe pas, elle sera créée
    return await openDatabase(
      path,
      version: 1, // Version de la base de données
      onCreate: _createDB, // Appelée uniquement lors de la création
    );
  }

  // Méthode appelée lors de la création de la base de données
  // Elle sert à créer les tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      quantity INTEGER NOT NULL,
      price REAL NOT NULL
    )
  ''');
  }

  // =======================
// CREATE (AJOUTER)
// =======================
// Cette fonction ajoute un produit dans la base de données
Future<void> insertProduct(Product product) async {

  // Récupère la base de données (connexion)
  final db = await instance.database;

  // Insère le produit dans la table "products"
  // product.toMap() transforme l’objet Product en Map
  await db.insert(
    'products',
    product.toMap(),
  );
}

// =======================
// READ (LIRE)
// =======================
// Cette fonction récupère tous les produits de la base
Future<List<Product>> getProducts() async {

  // Récupère la base de données
  final db = await instance.database;

  // Récupère toutes les lignes de la table "products"
  final result = await db.query('products');

  // Transforme chaque ligne (Map) en objet Product
  // et retourne une liste de Product
  return result
      .map((e) => Product.fromMap(e))
      .toList();
}

// =======================
// UPDATE (MODIFIER)
// =======================
// Cette fonction met à jour un produit existant
Future<void> updateProduct(Product product) async {

  // Récupère la base de données
  final db = await instance.database;

  // Met à jour la table "products"
  await db.update(
    'products',

    // Nouvelles valeurs du produit
    product.toMap(),

    // Condition : on modifie le produit
    // dont l’id correspond
    where: 'id = ?',
    whereArgs: [product.id],
  );
}

// =======================
// DELETE (SUPPRIMER)
// =======================
// Cette fonction supprime un produit par son id
Future<void> deleteProduct(int id) async {

  // Récupère la base de données
  final db = await instance.database;

  // Supprime la ligne correspondant à l’id
  await db.delete(
    'products',
    where: 'id = ?',
    whereArgs: [id],
  );
}
}
