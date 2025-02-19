// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_new_screen/detail_product.dart';
import 'package:product_new_screen/product.dart';
import 'package:product_new_screen/product_type.dart';
import 'package:product_new_screen/search/search_screen.dart';
import 'package:product_new_screen/slide.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

List<Product> displayProduct = [];
int selectedIndex = 0;
var _indexscrol = 0;

class _MainscreenState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'R S',
          style: GoogleFonts.acme(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          const SizedBox(height: 5),
          Container(
            height: 40,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
            ),
            child: SizedBox(
              width: 280,
              height: 40,
              child: Bounceable(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Search anything you like',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart_screen2', arguments: []);
            },
            icon: SvgPicture.asset(
              'assets/svg/cart 02.svg',
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: topbar(),
            // ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CarouselSlider.builder(
                      itemCount: slidesCarousel.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(slidesCarousel[itemIndex]),
                                fit: BoxFit.cover)),
                      ),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _indexscrol = index;
                          });
                        },
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        child: AnimatedSmoothIndicator(
                          activeIndex: _indexscrol,
                          count: 3,
                          effect: const WormEffect(),
                        ))
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  'Product Type',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Expanded(
                child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedIndex == index;
                          var image = productType[index]['image'] as String;
                          print('XXX: $image');
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: GestureDetector(
                              onTap: () {
                                // filterProduct(index);
                                Navigator.pushNamed(
                                  context,
                                  '/productType',
                                  arguments: productType[index]['tag']
                                      as String, // Pass selected tag as argument
                                );
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    SvgPicture.network(
                                      image, // Access the image URL
                                      width: 50, // Custom size
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      productType[index]['title'] as String,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            width: 10,
                          );
                        },
                        itemCount: productType.length)),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  'All Product',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = Product.fromjSON(products[index]);
                    return add_product(item, context);
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterProduct(int index) {
    List<Product> temData = [];
    for (var item in products) {
      var product = Product.fromjSON(item);
      if (product.productType == productType[index]) {
        temData.add(product);
      }
    }
    setState(() {
      // selectedIndex = index;
      displayProduct = temData;
    });
  }
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
              )),
            ),
            Text(item.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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

// Widget topbar() {
//   return Container(
//     child: Padding(
//       padding: const EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 10,
//       ),
//       child: Row(
//         children: [
//           Text(
//             'R S',
//             style: GoogleFonts.acme(
//               fontWeight: FontWeight.bold,
//               fontSize: 28,
//             ),
//           ),
//           const TextField(
//             decoration: InputDecoration(
//               hintText: 'Search',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget add_product(Product item, BuildContext context) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailProduct(),
//           ));
//     },
//     child: Card(
//       child: Container(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 child: Image.network(
//                   item.image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Text(
//               item.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//               ),
//             ),
//             Text(
//               item.describtion,
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '\nPrice : ' + item.price_sign + item.price,
//                   style: TextStyle(fontSize: 13, color: Colors.red),
//                   textAlign: TextAlign.start,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

class Product {
  late String image;
  late String name;
  late String describtion;
  late String price;
  late String price_sign;
  late String productType;
  late String image_product_type;
  late List<String> tagList;
  late List<ProductColor> productColors;
  late String selectedColor;
  late int quantity;

  Product({
    required this.image,
    required this.name,
    required this.describtion,
    required this.price,
    required this.price_sign,
    required this.productType,
    required this.image_product_type,
    required this.tagList,
    required this.productColors,
    required this.selectedColor,
    required this.quantity,
  });
  Product.fromjSON(Map<String, dynamic> data) {
    image = (data['api_featured_image']?.startsWith('http') ?? false)
        ? data['api_featured_image']
        : 'https:${data['api_featured_image']}';
    name = data['name'] ?? '';
    describtion = data['description'] ?? '';
    price = data['price'] ?? '';
    price_sign = data['price_sign'] ?? '';
    productType = data['title'] ?? '';
    image_product_type = data['image'] ?? '';
    tagList =
        ((data['tag_list'] as List?) ?? []).map((e) => e.toString()).toList();
    productColors = ((data['product_colors'] as List?) ?? [])
        .map((e) => ProductColor.fromJson(e))
        .toList();
    selectedColor = data['selected_color'] ?? '';
    quantity = data['quantity'] ?? 0;
  }
}

class ProductColor {
  late String hexValue;
  late String colorName;

  ProductColor({
    required this.hexValue,
    required this.colorName,
  });

  ProductColor.fromJson(Map<String, dynamic> json) {
    hexValue = json['hex_value'] ?? "";
    colorName = json['colour_name'] ?? "";
  }
}
