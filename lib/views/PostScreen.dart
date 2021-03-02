import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class PostScreen extends StatefulWidget {
  final String imgUrl, title, content;
  PostScreen({this.imgUrl, this.title, this.content});
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Widget postContent(htmlContent) {
    return HtmlView(
      data: htmlContent,
      onLaunchFail: (url) {
        print("launch $url faild");
      },
      scrollable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.title.replaceAll("&#8217;", "").replaceAll("&#8216;", "")),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.imgUrl),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                postContent(widget.content),
              ],
            ),
          ),
        ));
  }
}
