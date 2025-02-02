// import 'dart:convert';

// import '../models/models.dart';
// import '../services/services.dart';


// import 'package:http/http.dart' as http;

// Future<List<Category>> fetchCategoriesAndItems() async {
//   var response = await http.get(
//     Uri.parse(
//         'https://afosfr-admin-v6lq.vercel.app/api/category_items'), // Modify the endpoint to fetch both categories and items
//   );

//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
//     if (data != null &&
//         data['data'] != null &&
//         data['data']['categories'] != null) {
//       List<dynamic> categoriesData = data['data']['categories'];
//       List<Category> categories = categoriesData.map((categoryData) {
//         return Category(
//           name: categoryData['name'],
//           items: List<Item>.from(categoryData['items'].map((itemData) {
//             return Item(
//               // id: itemData['_id'],
//               foodname: itemData['foodname'],
//               price: itemData['price'],
//               fooding: itemData['fooding'],
//               avlb: itemData['avlb'],
//               foodimg: itemData['foodimg']??"https://img.icons8.com/ios/50/no-image.png",
//             );
//           })),
//         );
//       }).toList();
//       return categories;
//     } else {
//       print('Error: Categories and items data is null or empty');
//       return [];
//     }
//   } else {
//     print('Error fetching categories and items: ${response.statusCode}');
//     return [];
//   }
// }


// void fetchData() async {
//     List<Category> categories = await fetchCategoriesAndItems();
//     categories.forEach((category) {
//       print('Category: ${category.name}');
//       category.items.forEach((item) {
//         print(
//             'Item Name: ${item.foodname}, Price: ${item.price},Image: ${item.foodimg}');
//         // Use item properties as needed
//       });
//     });
//     setState(() {
//       // Update tabTexts with category names
//       tabTexts = categories.map((category) => category.name).toList();

//       // Generate tabs based on tabTexts
//       tabs = tabTexts.map((text) => Tab(child: Text(text))).toList();

//       // Initialize tabsContent with empty lists
//       tabsContent = List.generate(tabTexts.length, (index) => []);

//       // Fetch items for each category
//       for (int i = 0; i < categories.length; i++) {
//         Category category = categories[i];
//         List<dynamic> items = category.items
//             .map((item) => {
//                   'foodname': item.foodname,
//                   'category': category.name,
//                   'price': item.price,
//                   'foodimg': item.foodimg,
//                   'avlb': item.avlb,
//                   'fooding': item.fooding
//                 })
//             .toList();
//         tabsContent[i] = items;
//       }
//     });
//   }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://afosfr-admin-v6lq.vercel.app/api/category_items';

  Future<Map<String, dynamic>> fetchMenu(String shopId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'shop_id': shopId}),
      );

      if (response.statusCode == 200) {
        // print('Response: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load menu data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
