import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({Key? key, required this.imageUrl, required this.title}) : super(key: key);
  final String imageUrl, title;

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
      ),
    );
  }
}
