import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'SignupPage.dart';
import 'dart:math';
import 'main.dart';

void ConfirmError(context, text, button_text) {
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

class ConfirmPage extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  var confirmcontroller = TextEditingController();

  void confirm(code, right_code) async {
    if (code == right_code) {
      var url = Uri.http(globals.django_url, globals.signup_url);
      print(url);
      Response response = await post(url, body: {
        'username': globals.username,
        'password': globals.password,
        'phonenumber': globals.phonenumber,
        "tel_id": globals.eitaa_id,
        "address": globals.address,
        "post_code": globals.post_code
      });
      if (jsonDecode(response.body)['status'] == 'ok') {
        print(response.body);
        SharedPreferences sharedPreferences;
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("username", globals.username);
        sharedPreferences.setString("password", globals.password);
        sharedPreferences.setString("phonenumber", globals.phonenumber);
        sharedPreferences.setString("eitaa_id", globals.eitaa_id);
        sharedPreferences.setString("address", globals.address);
        sharedPreferences.setString("post_code", globals.post_code);
        sharedPreferences.commit();
      }
      if (jsonDecode(response.body)['status'] == 'error') {
        if (jsonDecode(response.body)['result'] == 'repetitious user') {
          // _showError(context);
          SignupError(
              context, "این نام کاربری قبلا توسط کسی استفاده شده است.", "باشه");
          Navigator.pop(context);
        }
        if (jsonDecode(response.body)['result'] == 'repetitious phonenumber') {
          // _showError(context);
          SignupError(
              context, "این شماره تلفن قبلا توسط کسی استفاده شده است.", "باشه");
          Navigator.pop(context);
        }
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Sarayemaryam()));
      }
    } else {
      ConfirmError(context, "کد وارد شده اشتباه است.", "باشه");
    }
  }

  void send_confirm_number(confirm_number) async {
    var url = Uri.http('193.176.243.61:8080', 'send_verify_code');
    var text = "کد تایید شما : " + confirm_number.toString();
    Response response = await post(url, body: {
      'code': confirm_number.toString(),
      'phone': globals.phonenumber
    });
    print(response.body);
  }

  int ConfirmNumber;
  void initState() {
    super.initState();
    Random random = new Random();
    ConfirmNumber = random.nextInt(999999);
    send_confirm_number(ConfirmNumber);
  }

  @override
  Widget build(BuildContext context) {
    // int ConfirmNumber;
    // Random random = new Random();
    // ConfirmNumber = random.nextInt(999999);
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
                "تایید حساب کاربری",
                style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
              ),
              Image.network(
                "http://193.176.243.61/media/photo_2021-04-23_01-16-14.jpg",
                width: 70,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          leading: Icon(Icons.add),
        ),
        body: Container(
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
                          "کد تایید به شماره موبایل شما ارسال شد. لطفا کد را وارد کنید.",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 10),
                        Material(
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "کد تایید",
                                hintStyle: TextStyle(color: Colors.black38),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                icon: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: Colors.black38,
                                  ),
                                )),
                            obscureText: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                            controller: confirmcontroller,
                          ),
                          elevation: 20,
                          borderRadius: BorderRadius.circular(40),
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
                                confirm(int.parse(confirmcontroller.text),
                                    ConfirmNumber);
                              },
                              child: Container(
                                width: 500,
                                height: 50,
                                child: Center(
                                    child: Text(
                                  "ورود به حساب",
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
        ));
  }
}
