// Classe Product : représente un produit dans l'application

// À quoi servent toMap() et fromMap() ?
// Quand on travaille avec SQLite en Flutter/Dart :
// SQLite ne comprend pas les objets Dart
// SQLite travaille seulement avec des Map (Map<String, dynamic>)
// Exemple : { "id": 1, "name": "Stylo", "quantity": 10, "price": 2.5 }

// 👉 Donc :
// toMap() : convertit un objet Dart → Map (pour SQLite)
// fromMap() : convertit une Map (SQLite) → objet Dart

class Product {

  // Identifiant du produit (clé primaire dans SQLite)
  // int? car il peut être null avant l'insertion dans la BD
  int? id;
  // Nom du produit
  String name;
  // Quantité en stock
  int quantity;
  // Prix du produit
  double price;
  // Constructeur
  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  // ==============================
  // 🔄 Dart → SQLite
  // ==============================
  // Cette méthode transforme un objet Product
  // en Map<String, dynamic>
  // SQLite utilise uniquement des Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,           // colonne id
      'name': name,       // colonne name
      'quantity': quantity, // colonne quantity
      'price': price,     // colonne price
    };
  }

  // ==============================
  // 🔄 SQLite → Dart
  // ==============================
  // Cette méthode crée un objet Product
  // à partir d'une Map venant de SQLite
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],              // récupère id
      name: map['name'],          // récupère name
      quantity: map['quantity'],  // récupère quantity
      price: map['price'],        // récupère price
    );
  }
}
