import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as globals;
import 'Product.dart';
import 'package:http/http.dart';
import 'Page__Discription.dart';
import 'dart:convert';
import 'StoreTab.dart';
import 'package:url_launcher/url_launcher.dart';

class Page__AboutMe extends StatefulWidget {
  @override
  _Page__AboutMeState createState() => _Page__AboutMeState();
}

class _Page__AboutMeState extends State<Page__AboutMe> {
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
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: Text(
                  "به سرای مریم خوش آمدید. \n سرای مریم مجموعه ای متشکل از فروشگاه پوشاک و آموزشگاه خیاطی است که در شهر قم به آدرس ( قم. بلوار 15 خرداد کوچه 40)  فعالیت می کند.  \n این مجموعه به دو صورت حقیقی و مجازی در حال فعالیت می باشد. \n صفحات ما را در شبکه های اجتماعی دنبال کنید.",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _launchURL("https://eitaa.com/sarayeh_maryam");
                },
                child: Image.network(
                  "https://s.cafebazaar.ir/1/icons/ir.eitaa.messenger_512x512.png",
                  height: 75,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _launchURL("https://t.me/sarayeh_maryam");
                },
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Telegram_logo.svg/1024px-Telegram_logo.svg.png",
                  height: 75,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _launchURL("https://www.instagram.com/sarayeh_maryam/");
                },
                child: Image.network(
                  "https://cdn.yjc.ir/files/fa/news/1399/1/22/11691915_208.png",
                  height: 75,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
