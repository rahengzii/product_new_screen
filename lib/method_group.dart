// `class ProductModel {
//   late String name;
//   late String description;
//   late String price;
//   late String imageUrl;
//   late String priceSign;
//   late List<ProductColor> productColors;
//   late List<String> tagList;
//   late String productType;

//   ProductModel({
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//     required this.priceSign,
//     required this.productColors,
//     required this.tagList,
//     required this.productType,
//   });

//   ProductModel.fromJson(Map<String, dynamic> data) {
//     name = data['name'] ?? "";
//     description = data['description'] ?? "NO DESCRIPTION";
//     price = data['price'] ?? 0.0;
//     imageUrl = "https:${data['api_featured_image']}" ?? "";
//     priceSign = data['price_sign'] ?? "";
//     tagList = (data['tag_list'] as List).map((e) => e.toString()).toList();
//     productType = data['product_type'] ?? "";
//     productColors = (data['product_colors'] as List)
//         .map((e) => ProductColor.fromJson(e))
//         .toList();
//   }
// }

// class ProductColor {
//   late String hexValue;
//   late String colorName;

//   ProductColor({
//     required this.hexValue,
//     required this.colorName,
//   });

//   ProductColor.fromJson(Map<String, dynamic> json) {
//     hexValue = json['hex_value'] ?? "";
//     colorName = json['colour_name'] ?? "";
//   }
// }
