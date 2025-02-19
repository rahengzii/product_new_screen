import 'package:flutter/material.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:product_new_screen/product.dart';

class ProductTypeScreen extends StatefulWidget {
  const ProductTypeScreen({super.key});

  @override
  State<ProductTypeScreen> createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  List<Product> displayProduct = [];
  String selectedType = '';
  List<Map<String, dynamic>> filterPro = [];

  void filterd(String tag) {
    filterPro = products.where((fpro) {
      return fpro["product_type"].toLowerCase() ==
          tag.toLowerCase().replaceFirst(' ', '_');
    }).toList();
    selectedType = tag;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    filterd(args!);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          selectedType,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: filterPro.isNotEmpty
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: filterPro.length,
              itemBuilder: (context, index) {
                var fpro = Product.fromjSON(filterPro[index]);
                return add_product(fpro, context);
              },
            )
          : const Center(child: Text('No Products Available')),
    );
  }

  Widget add_product(Product item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(product: item),
          ),
        );
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                  ),
                ),
              ),
              Text(item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text(
                item.describtion,
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text('Price: ${item.price_sign}${item.price}',
                  style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
// Widget add_product(Product item, BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailProduct(product: item),
//         ),
//       );
//     },
//     child: Card(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 child: Image.network(item.image, fit: BoxFit.cover),
//               ),
//             ),
//             Text(item.name,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//             Text(
//               item.describtion,
//               style: const TextStyle(color: Colors.grey),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//             Text('Price: ${item.price_sign}${item.price}',
//                 style: const TextStyle(color: Colors.red)),
//           ],
//         ),
//       ),
//     ),
//   );
// }