import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {
  String src;
  ImageView(this.src);
  @override
  _ImageViewState createState() => _ImageViewState(this.src);
}

class _ImageViewState extends State<ImageView> {
  String src;
  _ImageViewState(this.src);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(this.src);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: PhotoView(
          imageProvider: NetworkImage(src),
        ));
  }
}
