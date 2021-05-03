import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'BottomTabBarLearn.dart';
import 'globals.dart' as globals;
import 'SigninPage.dart';
import 'package:url_launcher/url_launcher.dart';

//

class LearnTab extends StatefulWidget {
  @override
  _LearnTabState createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  Future<void> SignupClassMajazi(context, title, text) async {
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
                  child: Text('تأیید'),
                  onPressed: () {
                    var eitaa_id = globals.eitaa_id;
                    var phonenumber = globals.phonenumber;
                    var address = globals.address;
                    var post_code = globals.post_code;
                    signup_class_message(
                        "درخواست ثبت نام کلاس خیاطی مجازی : \n آیدی : $eitaa_id \n شماره : $phonenumber \n آدرس : $address  \n کد پستی : $post_code");
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('انصراف'),
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

  Future<void> SignupClassHozoori(context, title, text) async {
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
                  child: Text('تأیید'),
                  onPressed: () {
                    var eitaa_id = globals.eitaa_id;
                    var phonenumber = globals.phonenumber;
                    var address = globals.address;
                    var post_code = globals.post_code;
                    signup_class_message(
                        "درخواست ثبت نام کلاس خیاطی حضوری : \n آیدی : $eitaa_id \n شماره : $phonenumber \n آدرس : $address  \n کد پستی : $post_code");
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('انصراف'),
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

  void signup_class_message(text) async {
    var url = Uri.http(globals.django_url, "send_signup_class");
    Response response = await post(url, body: {"text": text});
    print(response.body);
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
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.greenAccent[700],
                  child: InkWell(
                    onTap: () {
                      print("");

                      SignupClassHozoori(context, "ثبت نام کلاس خیاطی حضوری",
                          "درخواست ثبت نام شما به مسئول ثبت نام ارسال می شود و برای ارائه توضیحات در اسرع وقت با شما تماس خواهند گرفت.\n جهت دریافت شرایط ثبت نام و شرکت در کلاس ها، در روز های آتی کاربری ایتای خود را چک کنید");
                    },
                    child: Container(
                      width: 270,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                              child: Text(
                            "ثبت نام کلاس خیاطی حضوری",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.greenAccent[700],
                  child: InkWell(
                    onTap: () {
                      print("");

                      SignupClassMajazi(context, "ثبت نام کلاس خیاطی مجازی",
                          "در حال حاضر امکان ثبت نام کلاس مجازی وجود ندارد.\n برای اجرای کلاسهای مجازی در حال برنامه ریزی هستیم.  \n درخواست شما به مسئول ثبت نام ارسال می شود. به محض آماده شدن شرایط به شما اطلاع رسانی خواهد شد.\n باتشکر ");
                    },
                    child: Container(
                      width: 270,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            "ثبت نام کلاس خیاطی مجازی",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Image.network("http://193.176.243.61/media/icon.png"),
      ]),
      bottomNavigationBar: AppBottomTabBarLearn(),
    );
  }
}

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
