import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_new_screen/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduct extends StatefulWidget {
  final Product product;
  const DetailProduct({super.key, required this.product});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class Add2Cart {
  Add2Cart._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cart3.json');
  }

  static Future<List<Map<String, dynamic>>> _readRawData() async {
    final file = await _getFile();

    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        return jsonDecode(content).cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<List<Product>> readModelsFromFile() async {
    final rawData = await _readRawData();

    return rawData.map((item) {
      Product model = Product.fromjSON(item);
      model.selectedColor = item['selected_color'];
      model.quantity = item['quantity'];
      return model;
    }).toList();
  }

  static Future<void> addToCart(
      Product newModel, String selectedColor, int qty) async {
    final rawData = await _readRawData();

    final existingIndex = rawData.indexWhere((item) =>
        item['name'] == newModel.name &&
        item['selected_color'] == selectedColor);

    if (existingIndex != -1) {
      rawData[existingIndex]['quantity'] += qty;
    } else {
      rawData.add({
        'name': newModel.name,
        'description': newModel.describtion,
        'price': newModel.price,
        'api_featured_image': newModel.image,
        'price_sign': newModel.price_sign,
        'tag_list': newModel.tagList,
        'product_type': newModel.productType,
        'product_colors': newModel.productColors.map((color) {
          return {
            'hex_value': color.hexValue,
            'colour_name': color.colorName,
          };
        }).toList(),
        'selected_color': selectedColor,
        'quantity': qty,
      });
    }

    final file = await _getFile();
    await file.writeAsString(jsonEncode(rawData));
  }

  static Future<void> removeFromCart(
      Product modelToRemove, String selectedColor) async {
    final rawData = await _readRawData();

    rawData.removeWhere((item) =>
        item['name'] == modelToRemove.name &&
        item['selected_color'] == selectedColor);

    final file = await _getFile();
    await file.writeAsString(jsonEncode(rawData));
  }

  static Future<int> countItemsInCart() async {
    List<Product> models = await readModelsFromFile();
    return models.length;
  }
}

class FileHelper {
  FileHelper._();

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/defaultst.json');
  }

  static Future<List<Product>> readModelFromFile() async {
    final file = await _getFile();

    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        List<dynamic> jsonData = jsonDecode(content);
        return jsonData.map((item) => Product.fromjSON(item)).toList();
      }
    }
    return [];
  }

  static Future<void> addModelToFile(Product model) async {
    List<Product> models = await readModelFromFile();
    models.add(model);

    List<Map<String, dynamic>> jsonData = models.map((data) {
      return {
        "name": data.name,
        "description": data.describtion,
        "price": data.price,
        "api_featured_image": data.image,
        "price_sign": data.price_sign,
        "tag_list": data.tagList,
        "product_type": data.productType,
        "product_color": data.productColors.map((color) {
          return {
            "hex_value": color.hexValue,
            "colour_name": color.colorName,
          };
        }).toList(),
      };
    }).toList();

    final file = await _getFile();
    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<void> removeModelFromFile(Product modelToRemove) async {
    List<Product> models = await readModelFromFile();
    models.removeWhere((model) => model.name == modelToRemove.name);

    List<Map<String, dynamic>> jsonData = models.map((model) {
      return {
        "name": model.name,
        "description": model.describtion,
        "price": model.price,
        "api_featured_image": model.image,
        "price_sign": model.price_sign,
        "tag_list": model.tagList,
        "product_type": model.productType,
        "product_color": model.productColors.map((color) {
          return {
            "hex_value": color.hexValue,
            "colour_name": color.colorName,
          };
        }).toList(),
      };
    }).toList();

    final file = await _getFile();
    await file.writeAsString(jsonEncode(jsonData));
  }
}

class _DetailProductState extends State<DetailProduct> {
  bool ischeck = false;
  var _colorName = '';
  int _indexBoder = 0;
  int qty = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _colorName = widget.product.productColors.isEmpty
        ? "No Color"
        : widget.product.productColors[0].colorName;

    togglewishlist();
    loadCartItem();
  }

  void togglewishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = prefs.getStringList('wishlist') ?? [];

    if (wishlist.contains(widget.product.name)) {
      setState(() {
        ischeck = true;
      });
    }
  }

  List<Product> selectedItems = [];

  void loadCartItem() async {
    var item = await Add2Cart.readModelsFromFile();

    setState(() {
      selectedItems = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart_screen2').then((_) {
                  setState(() {
                    loadCartItem();
                  });
                });
              },
              icon: badges.Badge(
                badgeStyle: const badges.BadgeStyle(),
                badgeContent: Text(
                  selectedItems.length.toString(),
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
                child: const Icon(Icons.shopping_cart),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: _biuldDetail(widget.product)),
            _biuldfooter(widget.product),
          ],
        ),
      ),
    );
  }

  Widget _biuldDetail(Product item) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 250,
              width: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      item.image,
                    ),
                    fit: BoxFit.contain),
              ),
            ),
          ),
          Divider(
            thickness: 9,
            color: Colors.grey.shade200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 350,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Text(
                      'Price : ${item.price_sign} ${item.price}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Bounceable(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final wishlist = prefs.getStringList('wishlist') ?? [];
                  setState(
                    () {
                      ischeck = !ischeck;
                      if (ischeck) {
                        FileHelper.addModelToFile(widget.product);
                        IconSnackBar.show(
                          context,
                          snackBarType: SnackBarType.success,
                          label: 'Added to wishlist',
                          duration: const Duration(
                            seconds: 1,
                          ),
                        );
                        wishlist.add(widget.product.name);
                      } else {
                        FileHelper.removeModelFromFile(widget.product);
                        IconSnackBar.show(
                          context,
                          label: 'Removed from wishlist',
                          snackBarType: SnackBarType.fail,
                          duration: const Duration(
                            seconds: 1,
                          ),
                        );
                        wishlist.remove(widget.product.name);
                      }
                    },
                  );

                  await prefs.setStringList('wishlist', wishlist);
                },
                child: ischeck == false
                    ? SvgPicture.asset('assets/svg/love.svg')
                    : SvgPicture.asset('assets/svg/love_solid.svg'),
              ),
            ],
          ),
          Divider(
            thickness: 9,
            color: Colors.grey.shade200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Color : $_colorName',
                style: const TextStyle(color: Colors.blue),
              ),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    var Procolor = item.productColors[index];
                    return Bounceable(
                      scaleFactor: .5,
                      onTap: () {
                        setState(() {
                          _indexBoder = index;
                          _colorName = Procolor.colorName;
                        });
                      },
                      child: _biuldColors(
                          colortext: Procolor.hexValue, indexcolor: index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    width: 15,
                  ),
                  itemCount: item.productColors.length,
                ),
              )
            ],
          ),
          Divider(
            thickness: 9,
            color: Colors.grey.shade200,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tag'),
              SizedBox(
                height: 30,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Text(
                              item.tagList.isEmpty
                                  ? "No tag"
                                  : item.tagList[index],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 10,
                        ),
                    itemCount: item.tagList.isEmpty ? 1 : item.tagList.length),
              )
            ],
          ),
          Divider(
            thickness: 9,
            color: Colors.grey.shade200,
          ),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            item.describtion,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _biuldColors({required String colortext, required int indexcolor}) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(
            width: _indexBoder == indexcolor ? 2 : 0, color: Colors.black),
        color:
            Color(int.parse(colortext.replaceFirst('#', '0xff').split(',')[0])),
      ),
    );
  }

  Widget _biuldfooter(var item) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape:
                      const RoundedRectangleBorder(side: BorderSide(width: 2)),
                  backgroundColor: Colors.white),
              onPressed: () {
                Add2Cart.addToCart(widget.product, _colorName, 1);
              },
              child: const Text(
                'Add to cart',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.black),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/single',
                  arguments: widget.product,
                );
              },
              child: const Text(
                'BUY NOW',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}






























// import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:product_new_screen/mainscreen.dart';

// class DetailProduct extends StatefulWidget {
//   final Product product;

//   const DetailProduct({super.key, required this.product});

//   @override
//   State<DetailProduct> createState() => _DetailProductState();
// }

// class _DetailProductState extends State<DetailProduct> {
//   var _colorName = '';
//   int _indexBoder = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 20),
//             child: Icon(Icons.shopping_cart_sharp),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.network(widget.product.image),
//                       const Divider(
//                         thickness: 10,
//                       ),
//                       title_name(),
//                       const Divider(
//                         thickness: 10,
//                       ),
//                       colors(),
//                       const Divider(
//                         thickness: 10,
//                       ),
//                       description(),
//                     ],
//                   ),
//                 ),
//               ),
//               button(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget title_name() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         // mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Text(
//             widget.product.name,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             'price : \$ ${widget.product.price_sign} ${widget.product.price}',
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//             textAlign: TextAlign.start,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget colors() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Color  : ',
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 color: Colors.red,
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//               Container(
//                 width: 30,
//                 height: 30,
//                 color: Colors.green,
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//               Container(
//                 width: 30,
//                 height: 30,
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget tag() {
//     return Container(
//       child: const Column(
//         children: [
//           Text('Tag'),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             children: [
//               Text('Purpicks'),
//               SizedBox(
//                 width: 30,
//               ),
//               Text('CertClean'),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget button() {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Bounceable(
//                     onTap: () {},
//                     child: Container(
//                       width: 230,
//                       height: 50,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         border: Border.all(strokeAlign: 1),
//                       ),
//                       child: const Text(
//                         'Add to Cart',
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 SizedBox(
//                   width: 120,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         shape: const RoundedRectangleBorder(
//                             side: BorderSide(color: Colors.black),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(10)))),
//                     onPressed: () {
//                       Navigator.pushNamed(
//                         context,
//                         '/buy_now_sreen',
//                         arguments: widget.product,
//                       );
//                     },
//                     child: const Text(
//                       'Buy Now',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget description() {
//     return Container(
//         child: Column(
//       children: [
//         Text(widget.product.describtion),
//       ],
//     ));
//   }
// }
