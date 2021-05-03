import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;
import 'Product.dart';
import 'package:http/http.dart';
import 'Page__Discription.dart';
import 'dart:convert';
import 'StoreTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Page__DiscriptionUsersKalas.dart';

Future<void> _showInfo(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'خوش آمد',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  "کاربر گرامی\nبا سلام. شما می توانید کالاهای خود را در بستر فروشگاه مجازی سرای مریم عرضه کنید. \n\nشرایط: \n1. فعلا امکان ارسال بیش از یک محصول برای هر فرد فراهم نیست.\nبه مرور این امکان افزایش پیدا می کند ان شاء الله. \n2. عرضه یک قلم کالا رایگان می باشد.  \n3. کاربر موظف است فرم مربوط به محصول خود را به همراه حداقل یک عکس کم حجم از آن به مسئول فروشگاه ارسال کند.\n4. فروشگاه سرای مریم صرفا بستری جهت عرضه کالاست و پیگیری تمام مراحل خرید و فروش به عهده طرفین معامله می باشد و این فروشگاه هیچ مسئولیتی در قبال آن ندارد.\n5. اقدام و پیگیری خرید از طریق آیدی ایتای فروشنده قابل انجام است.\nو  «شماره همراه» فروشنده و  «شهر محل عرضه کالا» نیز در قسمت عرضه کالا درج می شود.\n\nجهت هماهنگی به آیدی زیر در ایتا پیام دهید:\n@salambarf",
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('انتقال به آیدی مسئول فروش'),
              onPressed: () {
                _launchURL("https://eitaa.com/salambarf");
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('متوجه شدم'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _showAlert(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'اطلاعات خرید',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Center(
                child: Text(
                  "مشتری گرامی\nشما نیز می توانید محصولات خود را در بستر فروشگاه مجازی سرای مریم عرضه کنید.\nمسئولیت خرید و فروش در این بخش به عهده خود شماست. در خرید خود دقت کنید.",
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: Text('ورود به بازار'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('شرایط عرضه کالا در بازار'),
              onPressed: () {
                Navigator.of(context).pop();
                _showInfo(context);
              },
            ),
          ),
        ],
      );
    },
  );
}

class Page__Users_kalas extends StatefulWidget {
  @override
  _Page__Users_kalasState createState() => _Page__Users_kalasState();
}

class _Page__Users_kalasState extends State<Page__Users_kalas> {
  List<Product> _items = [];

  void getItems() async {
    _items = [];
    globals.items = [];
    var url = Uri.http(globals.django_url, globals.users_kalas_getall_url);
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
            i['img4'],
            i['user'],
            i['phone'],
            i['city']);
        _items.add(item);
        globals.items = _items;
      }
      _showAlert(context);
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

Card generateItem(Product product, context, back_page) {
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
            builder: (context) =>
                Page__DiscriptionUsersKalas(product, Colors_values)));
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

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
