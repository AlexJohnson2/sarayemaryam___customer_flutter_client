import 'dart:convert';
import 'SigninPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'globals.dart' as globals;
import 'UpdateList.dart';
import 'package:url_launcher/url_launcher.dart';

class Page__Update extends StatefulWidget {
  @override
  _Page__UpdateState createState() => _Page__UpdateState();
}

class _Page__UpdateState extends State<Page__Update> {
  void get_update() async {
    var url = Uri.http(globals.django_url, "get_update");
    Response response = await post(url);
    print(response.body);
    if (jsonDecode(response.body)['result'] == "Not New Update") {
      if (globals.update.version == "version") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SigninPage()));
      }
    } else {
      if (globals.update.version == "1.0.3") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SigninPage()));
      } else {
        print(jsonDecode(response.body)['result']);
        var version = jsonDecode(response.body)['result']['version'];
        var name = jsonDecode(response.body)['result']['name'];
        var link = jsonDecode(response.body)['result']['link'];
        var news = jsonDecode(response.body)['result']['new'];
        setState(() {
          globals.update = UpdateList(version, name, link, news);
          print(news);
        });
      }
    }
  }

  void State() {
    print(globals.update);
    // print();
    print(globals.update.link);
    print(globals.update.version);
    print(globals.update.news);
  }

  @override
  void initState() {
    super.initState();

    print("get update");
    get_update();
  }

  Text itemBuilder(index) {
    return Text(
      globals.update.news[index],
      textDirection: TextDirection.rtl,
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    // State();
    if (globals.update.version == "version") {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "سرای مریم",
            style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
          ),
          centerTitle: true,
          leading: Icon(Icons.add),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(
              "سرای مریم",
              style: TextStyle(color: Colors.black, fontFamily: 'Vazir'),
            ),
            centerTitle: true,
            leading: Icon(Icons.add),
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "ورژن جدید : " + globals.update.version + "\n",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    "قابلیت های جدید : ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListView(shrinkWrap: true, children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: globals.update.news.length,
                      itemBuilder: (context, index) {
                        return itemBuilder(index);
                      }),
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.green,
                          child: TextButton(
                              onPressed: () {
                                print(globals.update.link);
                                _launchURL(globals.update.link);
                              },
                              child: Text("نصب می کنم",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )))),
                      Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red,
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => SigninPage()));
                              },
                              child: Text("بعدا ",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )))),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }
}

_launchURL(url) async {
  var this_url = url;
  await launch(url);
}
