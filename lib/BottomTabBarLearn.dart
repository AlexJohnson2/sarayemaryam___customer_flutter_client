import 'package:flutter/material.dart';
import 'StoreTab.dart';
import 'main.dart';
import 'AccountTab.dart';
import 'ShopBagTab.dart';

class AppBottomTabBarLearn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 65,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 4 - 50,
                    child: IconButton(
                        icon: Icon(
                          Icons.person_outline,
                          color: Colors.blueGrey[900],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                AccountTab(),
                            transitionDuration: Duration(seconds: 0),
                          ));
                        }),
                  ),
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 4 - 50,
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.blueGrey[900],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ShopBagTab(),
                          transitionDuration: Duration(seconds: 0),
                        ));
                      },
                    ),
                  ),
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 4 - 50,
                    child: Icon(
                      Icons.school,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 4 - 50,
                    child: IconButton(
                        icon: Icon(
                          Icons.store_outlined,
                          color: Colors.blueGrey[900],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                StoreTab(),
                            transitionDuration: Duration(seconds: 0),
                          ));
                        }),
                  ),
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width / 4 - 50,
                    child: IconButton(
                        icon: Icon(
                          Icons.home_outlined,
                          color: Colors.blueGrey[900],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                Sarayemaryam(),
                            transitionDuration: Duration(seconds: 0),
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
