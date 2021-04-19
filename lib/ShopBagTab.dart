import 'package:flutter/material.dart';
import 'ItemsList.dart';
import 'Product.dart';
import 'BottomTabBarShopBagTab.dart';
import 'globals.dart' as globals;
import 'Page__Pooshak_mardane.dart';
import 'ShopBagList.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'Page__DiscriptionShopBagTab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FinishedByePage.dart';
import 'TarikhcheKharidList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:persian_date/persian_date.dart';

// import 'package:zarinpal/zarinpal.dart';
//

void Error(context, text, button_text) {
  final snackBar = SnackBar(
    content: Text(text, textDirection: TextDirection.rtl),
    action: SnackBarAction(
      label: button_text,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0, // Inner padding for SnackBar content.
    ),
    duration: const Duration(milliseconds: 3500),
    behavior: SnackBarBehavior.floating,
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class ShopBagTab extends StatefulWidget {
  @override
  _ShopBagTabState createState() => _ShopBagTabState();
}

class _ShopBagTabState extends State<ShopBagTab> {
  void finished_bye() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("address") == "") {
      Error(context, "لطفا آدرس خود را در بخش تنظیمات حساب کاربری کامل کنید.",
          "باشه");
    } else if (sharedPreferences.getString("post_code") == "") {
      Error(context,
          "لطفا کد پستی خود را در بخش تنظیمات حساب کاربری کامل کنید.", "باشه");
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => FinishedByePage()));
    }
  }

  void finished_bye_zarinpal(get_all_amount) async {
    print("ok");
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("address") == "") {
      Error(context, "لطفا آدرس خود را در بخش تنظیمات حساب کاربری کامل کنید.",
          "باشه");
    }
    if (sharedPreferences.getString("post_code") == "") {
      Error(context,
          "لطفا کد پستی خود را در بخش تنظیمات حساب کاربری کامل کنید.", "باشه");
    }

    print("ok");
    print("ok");
    print("ok");

    // var Ersal;
    var Ersal_amount;
    // var Massenger;

    print("ok");

    // if (globals.Ersal.toString() == "SendKalaValues.tahvil_in_sarayemaryam") {
    //   Ersal = "تحویل حضوری از سرای مریم";
    //   Ersal_amount = "به عهده مشتری";
    // } else if (globals.Ersal.toString() ==
    //     "SendKalaValues.ersal_be_mojtama_asatid") {
    //   Ersal = "ارسال به مجتمع اساتید";
    //   Ersal_amount = "رایگان";
    // } else if (globals.Ersal.toString() ==
    //     "SendKalaValues.ersal_be_dakhel_shahr_qom") {
    //   Ersal = "ارسال به داخل شهر قم";
    //   Ersal_amount = "3000 تومان";
    // } else if (globals.Ersal.toString() ==
    //     "SendKalaValues.ersal_be_pardisan_qom") {
    //   Ersal = "ارسال به پردیسان قم";
    //   Ersal_amount = "5000 تومان";
    // } else if (globals.Ersal.toString() ==
    //     "SendKalaValues.ersal_be_shahrestans") {
    //   Ersal = "ارسال به شهرستان ها";
    //   Ersal_amount = "10000 تومان";
    // }

    print("ok");

    // if (_Ersal.toString() == "SendKalaValues.eitaa") {
    //   Massenger = "ایتا";
    // } else if (_Ersal.toString() == "SendKalaValues.whatsapp") {
    //   Massenger = "واتساپ";
    // } else if (_Ersal.toString() == "SendKalaValues.soroush") {
    //   Massenger = "سروش";
    // }
    //
    var text;

    text = "سبد خرید : " +
        "\n\n آیدی : " +
        sharedPreferences.getString("eitaa_id") +
        "\n\nشماره : " +
        sharedPreferences.getString("phonenumber") +
        "\n\nآدرس : " +
        sharedPreferences.getString("address") +
        "\n\nکد پستی : " +
        sharedPreferences.getString("post_code"); //+
    "\n\nنحوه دریافت کالا :" +
        globals.Ersal +
        "\n\nهزینه ارسال کالا :" +
        globals.all_amount.toString();
    print(text);
    // "\n\nمکان ارتباط با مسئول فروش : " +
    // Massenger;
    // var url = Uri.http(globals.django_url, globals.send_message_url);
    // Response response = await post(url, body: {'text': text});

    print("ok");

    var url = Uri.http(globals.django_url, globals.get_all_cart_url);
    Response response = await post(url,
        body: {"user": sharedPreferences.getString("username")});

    print("ok");

    // var text = "";
    var all_amount = 0;

    List<ShopBagList> _items = [];
    var itemsjson = json.decode(response.body)['result'];
    for (var i in itemsjson) {
      var item = ShopBagList(
          int.parse(i['id']),
          i["name"],
          i["text"],
          i["amount"],
          i["img"],
          i["num"],
          i["number"],
          i['old_num'],
          i['group'],
          i['color'],
          i['size'],
          i['img2'],
          i['img3'],
          i['img4']);
      _items.add(item);
      globals.shopbagitems = _items;
    }

    print("ok");

    for (var j in _items) {
      all_amount += int.parse(j.amount) * int.parse(j.num);
      text = text +
          "\n\n---------------------" +
          "\n\n" +
          "\n\nنام محصول : " +
          j.name +
          "\n\n  قیمت آن : " +
          j.amount +
          "\n\n و تعداد آن:  " +
          j.num +
          "\n\n و رنگ آن : " +
          j.color +
          "\n\n و سایز آن : " +
          j.size;
      // var url = Uri.http(globals.django_url, globals.send_message_url);
      // Response response = await post(url, body: {'text': text});
      //
      print("ok");

      url = Uri.http("193.176.243.61:8200", "pay/get_authority");
      response = await post(url, body: {
        'amount': get_all_amount.toString(),
        'description': text,
        'mobile': sharedPreferences.getString("phonenumber")
      });
      print(response.body);
      print(jsonDecode(response.body)['authority']);
      globals.authority = jsonDecode(response.body)['authority'];

      // var remove_num_url = "kala/" + j.group.toString() + "/remove_num";
      // print(remove_num_url);

      // url = Uri.http(globals.django_url, remove_num_url);
      // response = await post(url, body: {
      //   'name': j.name,
      //   'id': j.id.toString(),
      //   'num': j.num,
      //   'color': j.color,
      //   'size': j.size
      // });

      print("ok");

      url = Uri.http(globals.django_url, globals.delete_from_cart_url);
      response = await post(url, body: {
        'user': sharedPreferences.getString("username"),
        'name': j.name,
        'amount': j.amount,
        'img': j.img
      });

      setState(() {
        getItems();
      });

      print("ok");

      var url2 = Uri.http(globals.django_url, "/tarikhche_kharid/add");
      print("url2");
      print(url2);
      print("url2");
      response = await post(url2, body: {
        'username': sharedPreferences.getString("username"),
        'name': j.name,
        'amount': j.amount,
        'img': j.img,
        'text': j.text,
        'num': j.num,
        'group': j.group,
        'color': j.color,
        'this_id': j.id.toString(),
        'size': j.size,
        'authority': globals.authority,
        'pick_kala': globals.Ersal,
        'status': 'NOK'
      });

      print("ok");

      print("response.body");

      print(response.body);
      print("response.body");
      //.substring(4600, response.body.length
      //
    }

    // text = text + "\n\n\n\n---------------------\nقیمت کل : $all_amount";

    // url = Uri.http(globals.django_url, globals.send_message_url);
    // response = await post(url, body: {'text': text});

    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => ShopBagTab()));

    // if (Massenger == "ایتا") {
    //   _launchURL("https://eitaa.com/salambarf");
    // } else if (Massenger == "واتساپ") {
    //   _launchURL("https://wa.me/+989194517132");
    // }
    setState(() {
      globals.all_amount = 0;
      globals.Ersal = "";
    });

    _launchURL("https://www.zarinpal.com/pg/StartPay/" + globals.authority);
  }

  Future<void> _showInfo(context) async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();

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
                    "شماره تلفن شما",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Center(
                  child: Text(
                    sharedPreferences.getString("phonenumber"),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Center(
                  child: Text(
                    "کد پستی شما",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Center(
                  child: Text(
                    sharedPreferences.getString("post_code"),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Center(
                    child: Text(
                      "آدرس شما",
                      textDirection: TextDirection.rtl,
                      softWrap: true,
                      maxLines: null,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    sharedPreferences.getString("address"),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Center(
                  child: Text(
                    " مبلغ کل خرید شما : ",
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Center(
                  child: Text(
                    globals.all_amount.toString() + "  تومان  ",
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('تایید'),
                onPressed: () {
                  finished_bye_zarinpal(globals.all_amount);
                  Navigator.of(context).pop();
                  setState(() {
                    getItems();
                  });
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('انصراف'),
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

  void edit_num(name, num) async {
    var url = Uri.http(globals.django_url, globals.edit_cart_url);
    Response response = await post(url, body: {
      "user": globals.username.toString(),
      "name": name.toString(),
      "num": num.toString()
    });
    print(response.body);
  }

  void delete_from_cart(name, amount, img) async {
    var url = Uri.http(globals.django_url, globals.delete_from_cart_url);
    Response response = await post(url, body: {
      "user": globals.username,
      "name": name,
      "amount": amount,
      "img": img,
    });
    getItems();
    setState(() {
      globals.Ersal = "";
      globals.all_amount = 0;
    });
  }

  Future<void> Sure_to_delete_cart_item(context, name, amount, img) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'حذف از سبد خرید',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'آیا از حذف کردن این مورد اطمینان دارید؟',
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
                  child: Text('بله'),
                  onPressed: () {
                    delete_from_cart(name, amount, img);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('خیر'),
                  onPressed: () {
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

  void refresh() {
    setState(() {
      getItems();
    });
  }

  List<ShopBagList> _items = [];

  void getItems() async {
    var url = Uri.http(globals.django_url, globals.get_all_cart_url);
    print(url);
    Response response = await post(url, body: {"user": globals.username});
    setState(() {
      _items = [];
      var itemsjson = json.decode(response.body)['result'];
      // print(itemsjson);
      globals.all_amount = 0;

      for (var i in itemsjson) {
        // print(i['old_num']);
        var item = ShopBagList(
            int.parse(i['id']),
            i["name"],
            i["text"],
            i["amount"],
            i["img"],
            i["num"],
            i["number"],
            i['old_num'],
            i['group'],
            i['color'],
            i['size'],
            i['img2'],
            i['img3'],
            i['img4']);
        // print(item);
        _items.add(item);
        globals.shopbagitems = _items;
        globals.all_amount += int.parse(i['amount']) * int.parse(i['num']);
        // print(globals.shopbagitems);
        // print(i["text"]);
      }
      globals.shopbagitems = _items;

      if (globals.Ersal == "ارسال به داخل شهر قم رایگان") {
        if (globals.all_amount == 100000) {
          globals.Ersal = "ارسال به داخل شهر قم رایگان";
        } else if (globals.all_amount > 100000) {
          globals.Ersal = "ارسال به داخل شهر قم رایگان";
        } else {
          globals.Ersal = " داخل شهر قم 3000 تومان";
          globals.all_amount += 3000;
        }
      } else if (globals.Ersal == " داخل شهر قم 3000 تومان") {
        if (globals.all_amount == 100000) {
          globals.Ersal = "ارسال به داخل شهر قم رایگان";
        } else if (globals.all_amount > 100000) {
          globals.Ersal = "ارسال به داخل شهر قم رایگان";
        } else {
          globals.Ersal = " داخل شهر قم 3000 تومان";
          globals.all_amount += 3000;
        }
      } else if (globals.Ersal == "تحویل حضوری سرای مریم") {
        globals.Ersal = "تحویل حضوری سرای مریم";
      } else if (globals.Ersal == "ارسال به مجتمع اساتید قم رایگان") {
        globals.Ersal = "ارسال به مجتمع اساتید قم رایگان";
      } else if (globals.Ersal == "ارسال به پردیسان قم رایگان") {
        if (globals.all_amount == 150000) {
          globals.Ersal = "ارسال به پردیسان قم رایگان";
        } else if (globals.all_amount > 150000) {
          globals.Ersal = "ارسال به پردیسان قم رایگان";
        } else {
          globals.Ersal = "ارسال به پردیسان قم 5000 تومان";
          globals.all_amount += 5000;
        }
      } else if (globals.Ersal == "ارسال به پردیسان قم 5000 تومان") {
        if (globals.all_amount == 150000) {
          globals.Ersal = "ارسال به پردیسان قم رایگان";
        } else if (globals.all_amount > 150000) {
          globals.Ersal = "ارسال به پردیسان قم رایگان";
        } else {
          globals.Ersal = "ارسال به پردیسان قم 5000 تومان";
          globals.all_amount += 5000;
        }
      } else if (globals.Ersal == "ارسال به خارج قم رایگان") {
        if (globals.all_amount == 300000) {
          globals.Ersal = "ارسال به خارج قم رایگان";
        } else if (globals.all_amount > 300000) {
          globals.Ersal = "ارسال به خارج قم رایگان";
        } else {
          globals.Ersal = "ارسال به خارج قم 15000 تومان";
          globals.all_amount += 15000;
        }
      } else if (globals.Ersal == "ارسال به خارج قم 15000 تومان") {
        if (globals.all_amount == 300000) {
          globals.Ersal = "ارسال به خارج قم رایگان";
        } else if (globals.all_amount > 300000) {
          globals.Ersal = "ارسال به خارج قم رایگان";
        } else {
          globals.Ersal = "ارسال به خارج قم 15000 تومان";
          globals.all_amount += 15000;
        }
      }
    });
  }

  List<TarikhcheKharidList> _tarikhche_items = [];

  void getTarikhcheItems() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.http(globals.django_url, globals.tarikhche_kharid_getall_url);
    print(url);
    Response response = await post(url,
        body: {"user": sharedPreferences.getString("username")});
    setState(() {
      _tarikhche_items = [];
      print(response.body);
      var itemsjson = json.decode(response.body)['result'];
      globals.all_amount_tarikhche = 0;
      for (var i in itemsjson) {
        var item = TarikhcheKharidList(
            int.parse(i['id']),
            i["name"],
            i["text"],
            i["amount"],
            i["img"],
            i["num"],
            i["number"],
            i['old_num'],
            i['group'],
            i['eitaa_id'],
            i['address'],
            i['post_code'],
            i['color'],
            i['size'],
            i['authority'],
            i['status'],
            i['date'],
            i['time'],
            i['img2'],
            i['img3'],
            i['img4'],
            i['level_sabt'],
            i['level_amadeh_sazi'],
            i['level_tahvil_post']);
        _tarikhche_items.add(item);
        globals.all_amount_tarikhche +=
            int.parse(i['amount']) * int.parse(i['num']);
      }
    });
  }

  void getcolors() {}

  @override
  void initState() {
    super.initState();
    getItems();
    getTarikhcheItems();
    if (globals.Ersal == "SendKalaValues.ersal_be_dakhel_shahr_qom") {
      if (globals.all_amount > 100000) {
        globals.Ersal = "ارسال به داخل شهر قم رایگان";
      } else {
        globals.Ersal = " داخل شهر قم 3000 تومان";
        globals.all_amount += 3000;
      }
    } else if (globals.Ersal == "SendKalaValues.tahvil_in_sarayemaryam") {
      globals.Ersal = "تحویل حضوری سرای مریم";
    } else if (globals.Ersal == "SendKalaValues.ersal_be_mojtama_asatid") {
      globals.Ersal = "ارسال به مجتمع اساتید قم رایگان";
    } else if (globals.Ersal == "SendKalaValues.ersal_be_pardisan_qom") {
      if (globals.all_amount > 150000) {
        globals.Ersal = "ارسال به پردیسان قم رایگان";
      } else {
        globals.Ersal = "ارسال به پردیسان قم 5000 تومان";
        globals.all_amount += 5000;
      }
    } else if (globals.Ersal == "SendKalaValues.ersal_be_shahrestans") {
      if (globals.all_amount > 300000) {
        globals.Ersal = "ارسال به خارج قم رایگان";
      } else {
        globals.Ersal = "ارسال به خارج قم 15000 تومان";
        globals.all_amount += 15000;
      }
    }
  }

  Card generateItem(ShopBagList product, context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5,
      child: Container(
        height: 530,
        child: InkWell(
          onTap: () {
            //var item_ = globals.pooshak_mardane_getall_res['result'][id]

            var kala = Product(
                product.id,
                product.name,
                product.text,
                product.amount,
                product.img,
                product.num,
                "product.number",
                product.group,
                {},
                product.img2,
                product.img3,
                product.img4);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Page__DiscriptionShopBagTab(kala, [])));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.network(
                          product.img,
                          width: MediaQuery.of(context).size.width - 160,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 160,
                          child: Text(
                            product.name,
                            maxLines: null,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          product.amount,
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "رنگ : " + product.color,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "سایز : " + product.size,
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_up,
                                size: 30,
                              ),
                              onPressed: () {
                                var num = int.parse(product.num);
                                var new_num = num += 1;
                                // print(new_num);
                                print(product.old_num);
                                if (new_num == int.parse(product.old_num) + 1) {
                                  // print(int.parse(product.old_num));
                                } else {
                                  edit_num(product.name, new_num);
                                  setState(() {
                                    setState(() {
                                      getItems();
                                      if (globals.Ersal ==
                                          "ارسال به خارج قم رایگان") {
                                        if (globals.all_amount == 300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else if (globals.all_amount >
                                            300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به خارج قم 15000 تومان";
                                          globals.all_amount += 15000;
                                        }
                                      }
                                      if (globals.Ersal ==
                                          "ارسال به خارج قم 15000 تومان") {
                                        if (globals.all_amount == 300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else if (globals.all_amount >
                                            300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به خارج قم 15000 تومان";
                                          globals.all_amount += 15000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          "ارسال به داخل شهر قم رایگان") {
                                        if (globals.all_amount == 100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else if (globals.all_amount >
                                            100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              " داخل شهر قم 3000 تومان";
                                          globals.all_amount += 3000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          " داخل شهر قم 3000 تومان") {
                                        if (globals.all_amount == 100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else if (globals.all_amount >
                                            100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              " داخل شهر قم 3000 تومان";
                                          globals.all_amount += 3000;
                                        }
                                      }
                                    });
                                  });
                                }
                              }),
                          Text(
                            product.num,
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                              ),
                              onPressed: () {
                                var num = int.parse(product.num);
                                var new_num = num -= 1;
                                if (new_num == 0) {
                                } else {
                                  edit_num(product.name, new_num);
                                  setState(() {
                                    setState(() {
                                      getItems();
                                      if (globals.Ersal ==
                                          "ارسال به خارج قم رایگان") {
                                        if (globals.all_amount == 300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else if (globals.all_amount >
                                            300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به خارج قم 15000 تومان";
                                          globals.all_amount += 15000;
                                        }
                                      }
                                      if (globals.Ersal ==
                                          "ارسال به خارج قم 15000 تومان") {
                                        if (globals.all_amount == 300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else if (globals.all_amount >
                                            300000) {
                                          globals.Ersal =
                                              "ارسال به خارج قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به خارج قم 15000 تومان";
                                          globals.all_amount += 15000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          "ارسال به داخل شهر قم رایگان") {
                                        if (globals.all_amount == 100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else if (globals.all_amount >
                                            100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              " داخل شهر قم 3000 تومان";
                                          globals.all_amount += 3000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          "داخل شهر قم 3000 تومان") {
                                        if (globals.all_amount == 100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else if (globals.all_amount >
                                            100000) {
                                          globals.Ersal =
                                              "ارسال به داخل شهر قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              " داخل شهر قم 3000 تومان";
                                          globals.all_amount += 3000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          "ارسال به پردیسان قم رایگان") {
                                        if (globals.all_amount == 150000) {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم رایگان";
                                        } else if (globals.all_amount >
                                            150000) {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم 5000 تومان";
                                          globals.all_amount += 5000;
                                        }
                                      }

                                      if (globals.Ersal ==
                                          "ارسال به پردیسان قم 5000 تومان") {
                                        if (globals.all_amount == 150000) {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم رایگان";
                                        } else if (globals.all_amount >
                                            150000) {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم رایگان";
                                        } else {
                                          globals.Ersal =
                                              "ارسال به پردیسان قم 5000 تومان";
                                          globals.all_amount += 5000;
                                        }
                                      }
                                    });
                                  });
                                }
                              })
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            Sure_to_delete_cart_item(context, product.name,
                                product.amount, product.img);
                          })
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Card generateItemTarikhcheKharid(TarikhcheKharidList product, context) {
    PersianDate date = PersianDate.pDate();
    Widget status = Text(
      "وضعیت : " + "",
      style: TextStyle(fontSize: 20),
      textDirection: TextDirection.rtl,
    );
    if (product.status == "NOK") {
      status = Text(
        "وضعیت : " + "ناموفق",
        style: TextStyle(fontSize: 20, color: Colors.red),
        textDirection: TextDirection.rtl,
      );
    } else {
      status = Text(
        "وضعیت : " + "موفق",
        style: TextStyle(fontSize: 20, color: Colors.green),
        textDirection: TextDirection.rtl,
      );
    }
    var level_sabt_color = Colors.white;
    var level_sabt_color_text = Colors.black;
    var level_amadeh_sazi_color = Colors.white;
    var level_amadeh_sazi_color_text = Colors.black;
    var level_tahvil_post_color = Colors.white;
    var level_tahvil_post_color_text = Colors.black;
    if (product.level_sabt == "OK") {
      level_sabt_color = Colors.green;
      level_sabt_color_text = Colors.white;
    }
    if (product.level_amadeh_sazi == "OK") {
      level_amadeh_sazi_color = Colors.green;
      level_amadeh_sazi_color_text = Colors.white;
    }
    if (product.level_tahvil_post == "OK") {
      level_tahvil_post_color = Colors.green;
      level_tahvil_post_color_text = Colors.white;
    }
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 5,
      child: Container(
        height: 530,
        child: InkWell(
          onTap: () {
            //var item_ = globals.pooshak_mardane_getall_res['result'][id]

            var kala = Product(
                product.id,
                product.name,
                product.text,
                product.amount,
                product.img,
                product.num,
                "product.number",
                product.group,
                {},
                product.img2,
                product.img3,
                product.img4);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Page__DiscriptionShopBagTab(kala, [])));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 5),
            child: Column(
              children: [
                Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        child: Image.network(
                          product.img,
                          width: 100,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              product.name,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              product.amount,
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              "رنگ : " + product.color,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              "سایز : " + product.size,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              "تعداد : " + product.num,
                              style: TextStyle(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              "تاریخ : ",
                              style: TextStyle(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              date.parse(product.date)[0].toString() +
                                  '/' +
                                  date.parse(product.date)[1].toString() +
                                  '/' +
                                  date.parse(product.date)[2].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              "زمان : ",
                              style: TextStyle(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              product.time.toString(),
                              style: TextStyle(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: status)
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ]),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: level_sabt_color,
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text("ثبت سفارش",
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style:
                                      TextStyle(color: level_sabt_color_text)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        color: level_amadeh_sazi_color,
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                "آماده سازی سفارش",
                                maxLines: null,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: level_amadeh_sazi_color_text),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        color: level_tahvil_post_color,
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 50,
                              child: Text(
                                "تحویل سفارش به پست",
                                maxLines: null,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: level_tahvil_post_color_text),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  var text;
  var BtnColor;

  void button_on_tap() {
    if (globals.shopbagitems.toString() == "[]") {
    } else {
      if (globals.Ersal == "") {
        Error(context, "لطفا نحوه ارسال را انتخاب کنید", "باشه");
      } else {
        _showInfo(context);
      }
    }
  }

  void setting() {
    print(globals.shopbagitems);
    if (globals.shopbagitems.toString() == "[]") {
      text = "\nسبد خرید شما خالی است";
      BtnColor = Colors.grey;
    } else {
      text = "";
      BtnColor = Colors.green;
    }
  }

  List<Tab> tabs = <Tab>[
    Tab(text: 'تاریخچه خرید'),
    Tab(text: 'سبد خرید'),
  ];

  /*

    
      */

  @override
  Widget build(BuildContext context) {
    setting();
    return Scaffold(
      body: DefaultTabController(
        length: tabs.length,
        // The Builder widget is used to have a different BuildContext to access
        // closest DefaultTabController.
        initialIndex: 1,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              // Your code goes here.
              // To get index of current tab use tabController.index
            }
          });
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "سرای مریم",
                style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 2,
              leading: Icon(Icons.add),
              bottom: TabBar(
                labelColor: Colors.black,
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: [
                Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _tarikhche_items.length,
                        itemBuilder: (context, index) {
                          return generateItemTarikhcheKharid(
                              _tarikhche_items.reversed.toList()[index],
                              context);
                        },
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 340,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: globals.shopbagitems.length,
                        itemBuilder: (context, index) {
                          return generateItem(
                              globals.shopbagitems[index], context);
                        },
                      ),
                    ),
                  ),
                  Text(
                    "نحوه ارسال : " + globals.Ersal,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    child: Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(40),
                      color: BtnColor,
                      child: InkWell(
                        onTap: () {
                          if (globals.shopbagitems.toString() == "[]") {
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FinishedByePage()));
                          }
                        },
                        child: Container(
                          width: 1000,
                          height: 35,
                          child: Center(
                              child: Text(
                            "انتخاب نحوه ارسال",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "مجموع خرید شما :" + globals.all_amount.toString(),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    child: Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(40),
                      color: BtnColor,
                      child: InkWell(
                        onTap: () {
                          button_on_tap();
                          // _showInfo(context);
                        },
                        child: Container(
                          width: 1000,
                          height: 35,
                          child: Center(
                              child: Text(
                            "ادامه خرید",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: AppBottomTabBarShopBagTab(),
    );
  }
}

// import 'package:flutter/material.dart';

// /// This is the main application widget.
// class ShopBagTab extends StatelessWidget {
//   const ShopBagTab({Key key}) : super(key: key);

//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: MyStatelessWidget(),
//     );
//   }
// }

// const List<Tab> tabs = <Tab>[
//   Tab(text: 'Zeroth'),
//   Tab(text: 'First'),
//   Tab(text: 'Second'),
// ];

// /// This is the stateless widget that the main application instantiates.
// class MyStatelessWidget extends StatelessWidget {
//   const MyStatelessWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//   }
// }

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
