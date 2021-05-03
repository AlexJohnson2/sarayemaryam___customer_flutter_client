import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'Product.dart';
import 'StoreTab.dart';
import 'Page__Pooshak_mardane.dart';
import 'ShopBagTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ImageView.dart';

enum color_value { red }

class Page__DiscriptionSefaresh extends StatefulWidget {
  Product product;
  List colors_values;
  Page__DiscriptionSefaresh(this.product, this.colors_values);
  @override
  _Page__DiscriptionSefareshState createState() =>
      _Page__DiscriptionSefareshState(this.product, this.colors_values);
}

class _Page__DiscriptionSefareshState extends State<Page__DiscriptionSefaresh> {
  var back_page;
  Product product;
  List colors_values;
  _Page__DiscriptionSefareshState(this.product, this.colors_values);

  void add_to_cart(name, amount, text, img, id, num, old_num) async {
    var url = Uri.http(globals.django_url, globals.add_to_cart_url);
    Response response = await post(url, body: {
      "user": globals.username,
      "name": name,
      "amount": amount,
      "text": text,
      "img": img,
      "num": num,
      "this_id": id,
      "old_num": old_num.toString(),
      "group": product.group.toString(),
      "color": selected,
      "size": selectedSize
    });
    globals.to_cart = true;
    setState(() {
      setState(() {
        set_button();
      });
    });
  }

  void check_to_cart(product) async {
    var url = Uri.http(globals.django_url, globals.get_all_cart_url);
    Response response = await post(url, body: {"user": globals.username});
    print(url);
    print(jsonDecode(response.body.toString()).toString());
    if (jsonDecode(response.body.toString())
        .toString()
        .contains(product.name)) {
      print("globals.to_cart = true;");
      globals.to_cart = true;
      print(globals.to_cart);
    }
    setState(() {
      setState(() {
        set_button();
      });
    });
  }

  void check_comment() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var username = sharedPreferences.getString("username");
    var url = Uri.http(globals.django_url, globals.get_comments_url);
    Response response = await post(url, body: {"user": username});
    print(response.body);
    if (jsonDecode(response.body.toString())
        .toString()
        .contains(product.name)) {
      globals.to_comments = true;
      set_button();
    }
  }

  void pishnahad_mojood() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var username = sharedPreferences.getString("username");
    var url = Uri.http(globals.django_url, globals.pishnahad_mojood_url);
    Response response = await post(url, body: {
      "user": username,
      "text": "پیشنهاد موجودی برای کالای : " + product.name
    });
    print(response.body);
    globals.to_comments = true;
    setState(() {
      setState(() {
        set_button();
      });
    });
  }

  // List Colors_values = [];

  void initState() {
    super.initState();
    globals.to_cart = false;
    set_button();
    check_to_cart(product);
    set_button();
    check_comment();
    set_button();
    for (var i in product.color_size["result"]) {
      // print(i);
      // print(product.color_size["result"].toList()[i]);
      if (i["color"] == selected) {
        for (var j in i["size"]) {
          setState(() {
            sizes.add(j["size"]);
            selectedSize = j["size"];
          });
        }
      }
    }
    for (var i in product.color_size["result"]) {
      if (i["color"] == selected) {
        for (var j in i["size"]) {
          print(j);
          if (j["size"] == selectedSize) {
            old_num = int.parse(j["num"]);
            print(old_num);
          }
        }
      }
    }
    print(colors_values);
  }

  CarouselController slide_controller = CarouselController();

  void button_on_tap() {
    if (product.num == "0") {
      if (globals.to_comments == true) {
      } else if (globals.to_comments == false) {
        pishnahad_mojood();
      }
    } else {
      if (globals.to_cart == false) {
        add_to_cart(product.name, product.amount, product.text, product.img,
            product.id.toString(), "1", old_num);
      } else if (globals.to_cart == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ShopBagTab()),
          ModalRoute.withName('/'),
        );
      }
    }
  }

  var button_text = "درخواست سبد داده نشده";
  var button_color = Colors.green;

  void set_button() {
    print("در حال set_button هستم.");
    print(globals.to_cart);
    print(globals.to_comments);
    if (product.num == "0") {
      if (globals.to_comments == true) {
        button_text = "از پیشنهاد شما متشکریم";
        button_color = Colors.green;
      } else if (globals.to_comments == false) {
        button_text = "پیشنهاد می دهم موجود شود";
        button_color = Colors.red;
      }
    } else {
      if (globals.to_cart == false) {
        button_text = "افزودن به سبد خرید";
        button_color = Colors.red;
      } else if (globals.to_cart == true) {
        button_text = "نهایی کردن خرید";
        button_color = Colors.blue;
      }
    }
  }

  Row generateItem(context, index, selectedradio) {
    var text = colors_values[index].toString();
    return Row(children: [
      Text(text),
      Radio(
          value: colors_values[index],
          groupValue: selected,
          onChanged: (value) {
            setState(() {
              // print(value);
              // print(selected);
              selected = colors_values[index];
              // print(selected);
              sizes = [];
              for (var i in product.color_size["result"]) {
                // print(i);
                // print(product.color_size["result"].toList()[i]);
                if (i["color"] == value.toString()) {
                  for (var j in i["size"]) {
                    setState(() {
                      sizes.add(j["size"]);
                    });
                  }
                }
              }
            });
          }),
    ]);
  }

  Row generateItemSize(context, index, selectedradio) {
    var text = sizes[index].toString();
    return Row(children: [
      Text(text),
      Radio(
          value: sizes[index],
          groupValue: selectedSize,
          onChanged: (value) {
            setState(() {
              // print(value);
              print(selectedSize);
              selectedSize = sizes[index];
              print(selectedSize);
              for (var i in product.color_size["result"]) {
                if (i["color"] == selected) {
                  for (var j in i["size"]) {
                    print(j);
                    if (j["size"] == selectedSize) {
                      old_num = int.parse(j["num"]);
                      print(old_num);
                    }
                  }
                }
              }
            });
          }),
    ]);
  }

  void sefaresh_message(text) async {
    var url = Uri.http(globals.django_url, "send_message");
    Response response = await post(url, body: {"text": text});
    print(response.body);
  }

  Future<void> SefareshDookht(context, title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  text,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    child: Text('انصراف'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                TextButton(
                  child: Text('تایید'),
                  onPressed: () {
                    var name = product.name;
                    var amount = product.amount;
                    var username = globals.username;
                    var phonenumber = globals.phonenumber;
                    var eitaa_id = globals.eitaa_id;
                    sefaresh_message(
                        "سلام. سفارش دوخت. کالا : $name \n دستمزد تقریبی : $amount \n کاربر : $username \n تلفن کاربر : $phonenumber \n آیدی ایتا : $eitaa_id");
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void signup_class_message(text) async {
    var url = Uri.http(globals.django_url, "send_signup_class");
    Response response = await post(url, body: {"text": text});
    print(response.body);
  }

  var selected = "قرمز";

  var selectedSize = "";

  List sizes = [];

  int old_num;

  @override
  Widget build(BuildContext context) {
    var kala_amount = product.amount;

    var all_num = 0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              "http://193.176.243.61/media/photo_2021-04-23_01-16-09.jpg",
              width: 70,
            ),
            Text(
              "سرای مریم",
              style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
            ),
            Image.network(
              "http://193.176.243.61/media/photo_2021-04-23_01-16-14.jpg",
              width: 70,
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black87,
          onPressed: () {
            globals.to_cart = false;
            globals.to_comments = false;
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.0, left: 25, right: 25),
          child: GestureDetector(
            onTap: () {
              SefareshDookht(context, "سفارش دوخت",
                  "آیا مایلید سفارش دوخت این محصول به خیاط مجموعه سرای مریم ارسال شود؟ در صورت تأیید در ایتا منتظر پیام خیاط باشید.");
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 48,
                child: Center(
                  child: Text(
                    "تمایل دارم سفارش دهم",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Align(
            child: Text(
              product.name,
              style: TextStyle(fontSize: 28),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      slide_controller.nextPage();
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Image.network(
                        "http://193.176.243.61/media/outline_arrow_back_ios_black_48dp.png",
                        height: 25,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: CarouselSlider(
                  items: [
                    // Image.network(product.img),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageView(product, 0)));
                      },
                      child: Image.network(product.img),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageView(product, 1)));
                      },
                      child: Image.network(product.img2),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageView(product, 2)));
                      },
                      child: Image.network(product.img3),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ImageView(product, 3)));
                      },
                      child: Image.network(product.img4),
                    ),
                    // Image.network(product.img2),
                    // Image.network(product.img3),
                    // Image.network(product.img4),
                  ],
                  options: CarouselOptions(
                    height: 180.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                  carouselController: slide_controller,
                ),

                // child: Image.network(
                //   product.img,
                //   height: MediaQuery.of(context).size.width - 20,
                // ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      slide_controller.previousPage();
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Image.network(
                        "http://193.176.243.61/media/outline_arrow_forward_ios_black_48dp.png",
                        height: 25,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(height: 1.0, width: 130.0, color: Colors.black38),
          Center(
            child: Text(
              "سفارش",
              style: TextStyle(color: Colors.red, fontSize: 21),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Center(
              child: Text(
                product.text,
                style: TextStyle(color: Colors.black, fontSize: 18),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Card generateItem(product, context) {
//   return Card(
//     clipBehavior: Clip.antiAliasWithSaveLayer,
//     margin: EdgeInsets.all(10),
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(15))),
//     elevation: 5,
//     child: Padding(
//       padding: const EdgeInsets.all(15.0),
//       child: Center(
//         child: Text(
//           product,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     ),
// child: Container(
//   height: 200,
//   child: InkWell(
//     onTap: () {},
//     child: Padding(
//       padding:
//           const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 5),
//       child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.start,
//           textDirection: TextDirection.rtl,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(right: 10),
//                   child: Text(
//                     product,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ]),
//     ),
//   ),
// ),
//   );
// }

// class Page__Discription extends StatelessWidget {
//   var back_page;
//   Product product;
//   Page__Discription(this.product);

//   void add_to_cart(name, amount, text, img, id, num, old_num) async {
//     var url = Uri.http(globals.django_url, globals.add_to_cart_url);
//     Response response = await post(url, body: {
//       "user": globals.username,
//       "name": name,
//       "amount": amount,
//       "text": text,
//       "img": img,
//       "num": num,
//       "this_id": id,
//       "old_num": old_num,
//     });
//     print(response.body);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (globals.to_cart == false) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "سرای مریم",
//             style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: Colors.black87,
//             onPressed: () {
//               // Navigator.of(context)
//               //     .push(MaterialPageRoute(builder: (context) => back_page));
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: Colors.white,
//           elevation: 2,
//         ),
//         persistentFooterButtons: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 2.0, left: 25, right: 25),
//             child: GestureDetector(
//               onTap: () {
//                 add_to_cart(
//                     product.name,
//                     product.amount,
//                     product.text,
//                     product.img,
//                     product.id.toString(),
//                     product.num,
//                     product.num);
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width - 50,
//                 height: 50,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.all(Radius.circular(15))),
//                   height: 48,
//                   child: Center(
//                     child: Text(
//                       "افزودن به سبد خرید",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//         body: ListView(
//           children: <Widget>[
//             SizedBox(
//               height: 10,
//             ),
//             Align(
//               child: Text(
//                 product.name,
//                 style: TextStyle(fontSize: 28),
//               ),
//               alignment: Alignment.center,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: Image.network(
//                 product.img,
//                 height: MediaQuery.of(context).size.width - 20,
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Center(
//               child: Text(
//                 product.amount,
//                 style: TextStyle(color: Colors.red, fontSize: 21),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 40, right: 40),
//               child: Center(
//                 child: Text(
//                   product.text,
//                   style: TextStyle(color: Colors.black, fontSize: 18),
//                   textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "سرای مریم",
//             style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             color: Colors.black87,
//             onPressed: () {
//               // Navigator.of(context)
//               //     .push(MaterialPageRoute(builder: (context) => back_page));
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: Colors.white,
//           elevation: 2,
//         ),
//         persistentFooterButtons: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 2.0, left: 25, right: 25),
//             child: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 width: MediaQuery.of(context).size.width - 50,
//                 height: 50,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.blue[400],
//                       borderRadius: BorderRadius.all(Radius.circular(15))),
//                   height: 48,
//                   child: Center(
//                     child: Text(
//                       "ادامه دادن خرید",
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//         body: ListView(
//           children: <Widget>[
//             SizedBox(
//               height: 10,
//             ),
//             Align(
//               child: Text(
//                 product.name,
//                 style: TextStyle(fontSize: 28),
//               ),
//               alignment: Alignment.center,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Center(
//               child: Image.network(
//                 product.img,
//                 height: MediaQuery.of(context).size.width - 20,
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Center(
//               child: Text(
//                 product.amount,
//                 style: TextStyle(color: Colors.red, fontSize: 21),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 40, right: 40),
//               child: Center(
//                 child: Text(
//                   product.text,
//                   style: TextStyle(color: Colors.black, fontSize: 18),
//                   textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
