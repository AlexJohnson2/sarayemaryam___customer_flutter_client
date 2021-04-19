import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;
import 'Product.dart';
import 'package:http/http.dart';
import 'Page__Discription.dart';
import 'dart:convert';
import 'StoreTab.dart';

class Page__Kharazi_Abzar extends StatefulWidget {
  @override
  _Page__Kharazi_AbzarState createState() => _Page__Kharazi_AbzarState();
}

class _Page__Kharazi_AbzarState extends State<Page__Kharazi_Abzar> {
  List<Product> _items = [];

  void getItems() async {
    _items = [];
    globals.items = [];
    var url = Uri.http(globals.django_url, globals.kharazi_abzar_getall_url);
    Response response = await get(url);
    setState(() {
      print(jsonDecode(response.body));
      var itemsjson = json.decode(response.body)['result'];
      for (var i in itemsjson) {
        var item = Product(
            i['id'],
            i['name'],
            i['text'],
            i['amount'],
            i['img'],
            i['num'],
            i['number'],
            i['group'],
            i['color_size'],
            i['img2'],
            i['img3'],
            i['img4']);
        _items.add(item);
        globals.items = _items;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "سرای مریم",
          style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: Container(
              height: MediaQuery.of(context).size.height - 60,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: globals.items.length,
                  itemBuilder: (context, index) {
                    return generateItem(
                        globals.items[index], context, StoreTab());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void check(product) async {
  var url = Uri.http(globals.django_url, globals.get_all_cart_url);
  Response response = await post(url, body: {"user": globals.username});
  var this_kala = {
    "id": product.id.toString(),
    "name": product.name,
    "amount": product.amount,
    "img": product.img,
    "num": product.num
  };

  if (jsonDecode(response.body)['result'].toString().contains(product.name)) {
    print(product.name);
  }
  if (jsonDecode(response.body)['result'].toString().contains(product.name)) {
    globals.to_cart = true;
  } else {
    globals.to_cart = false;
  }
}

Card generateItem(Product product, context, back_page) {
  if (product.num == "0") {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5,
      child: InkWell(
        onTap: () {
          List Colors_values = [];
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Page__Discription(product, Colors_values)));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 110,
                  child: Image.network(product.img),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width:
                              MediaQuery.of(context).size.width - 80 - 12 - 110,
                          child: Text(
                            product.name,
                            textAlign: TextAlign.right,
                            maxLines: null,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Text("ناموجود",
                            style: TextStyle(color: Colors.red),
                            textDirection: TextDirection.rtl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } else {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5,
      child: InkWell(
        onTap: () {
          List Colors_values = [];
          for (var i in product.color_size["result"]) {
            var all_amount = 0;
            print(i['color']);
            for (var j in i["size"]) {
              print(j);
              if (j['num'] == "0") {
                print("num is 0");
              } else {
                all_amount += int.parse(j['num']);
              }
              // selectedSize = j["size"];
            }
            if (all_amount == 0) {
            } else {
              Colors_values.add(i['color']);
            }
          }

          //var item_ = globals.pooshak_mardane_getall_res['result'][id]
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Page__Discription(product, Colors_values)));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 110,
                  child: Image.network(product.img),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width:
                              MediaQuery.of(context).size.width - 80 - 12 - 110,
                          child: Text(
                            product.name,
                            textAlign: TextAlign.right,
                            maxLines: null,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Text(product.amount.toString() + " تومان",
                            style: TextStyle(color: Colors.red),
                            textDirection: TextDirection.rtl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
