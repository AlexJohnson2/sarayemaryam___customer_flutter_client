import 'dart:convert';
import 'ShopBagTab.dart';

import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'SigninPage.dart';
import 'ConfirmPage.dart';
import 'SigninPage.dart';
import 'AccountSetting.dart';
import 'FinishedByePage__2.dart';

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

enum SendKalaValues {
  tahvil_in_sarayemaryam,
  ersal_be_mojtama_asatid,
  ersal_be_dakhel_shahr_qom,
  ersal_be_pardisan_qom,
  ersal_be_shahrestans
}

SendKalaValues _Ersal = SendKalaValues.tahvil_in_sarayemaryam;

class FinishedByePage extends StatefulWidget {
  @override
  _FinishedByePageState createState() => _FinishedByePageState();
}

class _FinishedByePageState extends State<FinishedByePage> {
  var usernamecontroller = TextEditingController(text: globals.username);
  var passwordcontroller = TextEditingController(text: globals.password);
  var phonenumbercontroller = TextEditingController(text: globals.phonenumber);
  var eitaa_idcontroller = TextEditingController(text: globals.eitaa_id);
  var addresscontroller = TextEditingController(text: globals.address);
  var post_codecontroller = TextEditingController(text: globals.post_code);

  void finished_bye() async {
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
  }

  void storage() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    setState() {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "ادامه خرید",
            style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(children: [
          Container(
            child: Container(
              color: Colors.white,
              child: Container(
                child: Padding(
                    padding: EdgeInsets.all(45),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "لطفا نحوه ارسال کالا را انتخاب کنید.",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListBody(
                            children: [
                              Material(
                                color: Colors.yellow[200],
                                borderRadius: BorderRadius.circular(50),
                                child: RadioListTile<SendKalaValues>(
                                    title: Text(
                                      "تحویل حضوری از سرای مریم",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    value:
                                        SendKalaValues.tahvil_in_sarayemaryam,
                                    groupValue: _Ersal,
                                    onChanged: (SendKalaValues value) {
                                      setState(() {
                                        _Ersal = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.cyan[100],
                                borderRadius: BorderRadius.circular(50),
                                child: RadioListTile<SendKalaValues>(
                                    title: Text(
                                      "ارسال درون مجتمع اساتید\nهزینه : رایگان",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    value:
                                        SendKalaValues.ersal_be_mojtama_asatid,
                                    groupValue: _Ersal,
                                    onChanged: (SendKalaValues value) {
                                      setState(() {
                                        _Ersal = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(50),
                                child: RadioListTile<SendKalaValues>(
                                    title: Text(
                                      "ارسال به داخل شهر قم\nهزینه : 3000 تومان \n برای خرید بالای 100 هزار تومان ارسال رایگان است",
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    value: SendKalaValues
                                        .ersal_be_dakhel_shahr_qom,
                                    groupValue: _Ersal,
                                    onChanged: (SendKalaValues value) {
                                      setState(() {
                                        _Ersal = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(50),
                                child: RadioListTile<SendKalaValues>(
                                    title: Text(
                                      "ارسال به پردیسان قم\nهزینه : 5000 تومان \n برای خرید بالای 150 هزار تومان ارسال رایگان است",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    value: SendKalaValues.ersal_be_pardisan_qom,
                                    groupValue: _Ersal,
                                    onChanged: (SendKalaValues value) {
                                      setState(() {
                                        _Ersal = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(50),
                                child: RadioListTile<SendKalaValues>(
                                    title: Text(
                                      "ارسال به شهرستان\nهزینه : 15000 تومان \n برای خرید بالای 300 هزار تومان ارسال رایگان می باشد.",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    value: SendKalaValues.ersal_be_shahrestans,
                                    groupValue: _Ersal,
                                    onChanged: (SendKalaValues value) {
                                      setState(() {
                                        _Ersal = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 60, right: 60),
                            child: Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.green,
                              child: InkWell(
                                onTap: () {
                                  globals.Ersal = _Ersal.toString();
                                  print(globals.Ersal);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ShopBagTab()));
                                },
                                child: Container(
                                  width: 500,
                                  height: 50,
                                  child: Center(
                                      child: Text(
                                    "ادامه خرید",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ])),
              ),
            ),
          )
        ]));
  }
}
