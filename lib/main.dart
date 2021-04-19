import 'dart:convert';
import 'Page__Discription.dart';
import 'Product.dart';
import 'package:flutter/material.dart';
import 'BottomTabBar.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'SigninPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Page__Help.dart';
import 'Page__AboutMe.dart';
import 'Page__Update.dart';

void main() async {
  if (2 == 2) {
    runApp(UpdateMaterial());
  } else {
    runApp(MainMaterial());
  }
}
//void main() { runApp(SigninPage()); }

class MainMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sarayemaryam(),
      title: "سرای مریم",
      theme: ThemeData(fontFamily: "Vazir"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SigninMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SigninPage(),
      title: "سرای مریم",
      theme: ThemeData(fontFamily: "Vazir"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UpdateMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page__Update(),
      title: "سرای مریم",
      theme: ThemeData(fontFamily: "Vazir"),
      debugShowCheckedModeBanner: false,
    );
  }
}

void set_variable() async {
  SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  globals.username = sharedPreferences.getString('username');
  globals.password = sharedPreferences.getString('password');
  globals.phonenumber = sharedPreferences.getString('phonenumber');
  globals.eitaa_id = sharedPreferences.getString('eitaa_id');
  globals.address = sharedPreferences.getString('address');
  globals.post_code = sharedPreferences.getString('post_code');
}

class Sarayemaryam extends StatefulWidget {
  @override
  _SarayemaryamState createState() => _SarayemaryamState();
}

class _SarayemaryamState extends State<Sarayemaryam> {
  @override
  Widget build(BuildContext context) {
    set_variable();
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
      ),
      body: Column(children: [
        Container(
          alignment: Alignment.topCenter,
          child: Image.network(
            "http://193.176.243.61/media/icon.png",
            height: MediaQuery.of(context).size.width - 35,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 60, right: 60),
          child: Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(40),
            color: Colors.greenAccent[700],
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Page__Help()));
              },
              child: Container(
                width: 130,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: Text(
                      "راهنما",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                    Icon(
                      Icons.help,
                      color: Colors.white,
                    ),
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
          padding: EdgeInsets.only(left: 60, right: 60),
          child: Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(40),
            color: Colors.greenAccent[700],
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Page__AboutMe()));
              },
              child: Container(
                width: 130,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      "درباره ما",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                    Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
      bottomNavigationBar: AppBottomTabBar(),
    );
  }
}

Card generateItem(Product product, context) {
  return Card(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))),
    elevation: 5,
    child: InkWell(
      onTap: () {
        //var item_ = globals.pooshak_mardane_getall_res['result'][id]
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Page__Discription(product, [])));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120,
              child: Image.network(product.img),
            ),
            Text(
              product.name,
              style: TextStyle(fontSize: 17),
            ),
            Text(
              product.amount.toString(),
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    ),
  );
}
