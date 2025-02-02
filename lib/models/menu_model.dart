class Category {
  final String name;
  final List<Item> items;

  Category({
    required this.name,
    required this.items,
  });
}

class Item {
  // final String id;
 String foodname;
 String price;
 String fooding;
 String avlb;
 String foodimg;

  Item({
    // required this.id,
    required this.foodname,
    required this.price,
    required this.fooding,
    required this.avlb,
    required this.foodimg,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          // id == other.id && // Compare unique identifiers
          foodname == other.foodname &&
          price == other.price &&
          fooding == other.fooding &&
          avlb == other.avlb &&
          foodimg == other.foodimg;

  @override
  int get hashCode =>
      // id.hashCode ^
      foodname.hashCode ^
      price.hashCode ^
      fooding.hashCode ^
      avlb.hashCode ^
      foodimg.hashCode;
}
