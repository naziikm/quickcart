import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  SeedService(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> seedProducts() async {
    final collection = _firestore.collection('products');
    final snapshot = await collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // already seeded

    final products = _sampleProducts;
    final batch = _firestore.batch();
    for (final product in products) {
      batch.set(collection.doc(), product);
    }
    await batch.commit();
  }

  static final List<Map<String, dynamic>> _sampleProducts = [
    // Vegetables
    {
      'name': 'Fresh Tomatoes',
      'description': 'Farm-fresh red tomatoes, perfect for salads and cooking.',
      'price': 40.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1546470427-0d4db154ceb8?w=400',
      'category': 'Vegetables',
      'unit': '500g',
      'isAvailable': true,
    },
    {
      'name': 'Green Capsicum',
      'description': 'Crisp green bell peppers, great for stir-fry.',
      'price': 35.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      'category': 'Vegetables',
      'unit': '250g',
      'isAvailable': true,
    },
    {
      'name': 'Onions',
      'description': 'Fresh onions for everyday cooking.',
      'price': 30.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400',
      'category': 'Vegetables',
      'unit': '1kg',
      'isAvailable': true,
    },
    {
      'name': 'Potatoes',
      'description': 'Premium quality potatoes.',
      'price': 45.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1518977676601-b53f82ber630?w=400',
      'category': 'Vegetables',
      'unit': '1kg',
      'isAvailable': true,
    },
    {
      'name': 'Spinach',
      'description': 'Fresh green spinach leaves.',
      'price': 25.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      'category': 'Vegetables',
      'unit': '250g',
      'isAvailable': true,
    },
    {
      'name': 'Carrots',
      'description': 'Crunchy orange carrots, rich in vitamins.',
      'price': 38.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      'category': 'Vegetables',
      'unit': '500g',
      'isAvailable': true,
    },
    // Fruits
    {
      'name': 'Bananas',
      'description': 'Fresh yellow bananas, naturally sweet.',
      'price': 50.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
      'category': 'Fruits',
      'unit': '1 dozen',
      'isAvailable': true,
    },
    {
      'name': 'Apples',
      'description': 'Kashmiri red apples, crispy and juicy.',
      'price': 160.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      'category': 'Fruits',
      'unit': '1kg',
      'isAvailable': true,
    },
    {
      'name': 'Oranges',
      'description': 'Nagpur oranges, sweet and tangy.',
      'price': 80.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
      'category': 'Fruits',
      'unit': '1kg',
      'isAvailable': true,
    },
    {
      'name': 'Watermelon',
      'description': 'Fresh and sweet watermelon.',
      'price': 45.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
      'category': 'Fruits',
      'unit': '1 piece',
      'isAvailable': true,
    },
    {
      'name': 'Grapes',
      'description': 'Seedless green grapes.',
      'price': 90.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400',
      'category': 'Fruits',
      'unit': '500g',
      'isAvailable': true,
    },
    // Dairy
    {
      'name': 'Amul Toned Milk',
      'description': 'Fresh toned milk, pasteurized.',
      'price': 30.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
      'category': 'Dairy',
      'unit': '500ml',
      'isAvailable': true,
    },
    {
      'name': 'Paneer',
      'description': 'Fresh cottage cheese block.',
      'price': 90.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400',
      'category': 'Dairy',
      'unit': '200g',
      'isAvailable': true,
    },
    {
      'name': 'Curd',
      'description': 'Thick and creamy natural curd.',
      'price': 35.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      'category': 'Dairy',
      'unit': '400g',
      'isAvailable': true,
    },
    {
      'name': 'Butter',
      'description': 'Amul salted butter.',
      'price': 56.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400',
      'category': 'Dairy',
      'unit': '100g',
      'isAvailable': true,
    },
    {
      'name': 'Cheese Slices',
      'description': 'Processed cheese slices for sandwiches.',
      'price': 120.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400',
      'category': 'Dairy',
      'unit': '200g',
      'isAvailable': true,
    },
    // Snacks
    {
      'name': "Lay's Classic Salted",
      'description': 'Crispy potato chips with classic salt flavor.',
      'price': 20.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400',
      'category': 'Snacks',
      'unit': '52g',
      'isAvailable': true,
    },
    {
      'name': 'Maggi Noodles',
      'description': '2-minute masala noodles.',
      'price': 14.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=400',
      'category': 'Snacks',
      'unit': '70g',
      'isAvailable': true,
    },
    {
      'name': 'Oreo Biscuits',
      'description': 'Chocolate sandwich cookies with cream filling.',
      'price': 30.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=400',
      'category': 'Snacks',
      'unit': '120g',
      'isAvailable': true,
    },
    {
      'name': 'Kurkure Masala Munch',
      'description': 'Spicy puffed corn snack.',
      'price': 20.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1621447504864-d8686e12698c?w=400',
      'category': 'Snacks',
      'unit': '90g',
      'isAvailable': true,
    },
    {
      'name': 'Dark Fantasy',
      'description': 'Choco-filled premium cookies.',
      'price': 40.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400',
      'category': 'Snacks',
      'unit': '100g',
      'isAvailable': true,
    },
    // Beverages
    {
      'name': 'Coca-Cola',
      'description': 'Chilled cola carbonated drink.',
      'price': 40.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
      'category': 'Beverages',
      'unit': '750ml',
      'isAvailable': true,
    },
    {
      'name': 'Tropicana Orange Juice',
      'description': '100% pure orange juice.',
      'price': 60.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400',
      'category': 'Beverages',
      'unit': '1L',
      'isAvailable': true,
    },
    {
      'name': 'Tata Tea Gold',
      'description': 'Premium assam tea leaves.',
      'price': 150.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
      'category': 'Beverages',
      'unit': '500g',
      'isAvailable': true,
    },
    {
      'name': 'Nescafe Classic Coffee',
      'description': 'Instant coffee powder.',
      'price': 175.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400',
      'category': 'Beverages',
      'unit': '200g',
      'isAvailable': true,
    },
    // Bakery
    {
      'name': 'White Bread',
      'description': 'Soft white sandwich bread.',
      'price': 40.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1549931319-a545753467c8?w=400',
      'category': 'Bakery',
      'unit': '400g',
      'isAvailable': true,
    },
    {
      'name': 'Pav Buns',
      'description': 'Soft dinner rolls, pack of 6.',
      'price': 30.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
      'category': 'Bakery',
      'unit': '6 pcs',
      'isAvailable': true,
    },
    {
      'name': 'Chocolate Cake',
      'description': 'Rich chocolate truffle cake.',
      'price': 350.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
      'category': 'Bakery',
      'unit': '500g',
      'isAvailable': true,
    },
    // Household
    {
      'name': 'Vim Dishwash Gel',
      'description': 'Lemon fresh dishwash liquid.',
      'price': 99.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?w=400',
      'category': 'Household',
      'unit': '500ml',
      'isAvailable': true,
    },
    {
      'name': 'Surf Excel Detergent',
      'description': 'Easy wash detergent powder.',
      'price': 135.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400',
      'category': 'Household',
      'unit': '1kg',
      'isAvailable': true,
    },
  ];
}
