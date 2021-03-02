import 'package:blog_wala/views/PostScreen.dart';
import 'package:blog_wala/wp_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'B',
              style: TextStyle(
                fontFamily: 'long',
                fontSize: 50.0,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'log',
              style: TextStyle(
                fontFamily: 'long',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'W',
              style: TextStyle(
                fontFamily: 'long',
                color: Colors.orange,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ala',
              style: TextStyle(
                fontFamily: 'long',
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map wppost = snapshot.data[index];
                  return PostTile(
                    href: wppost['_links']["wp:featuredmedia"][0]["href"],
                    title: wppost["title"]["rendered"]
                        .replaceAll("&#8217;", "")
                        .replaceAll("&#8216;", ""),
                    desc: wppost["excerpt"]["rendered"]
                        .replaceAll("&#8217;", "")
                        .replaceAll("&#8216;", ""),
                    content: wppost["content"]["rendered"]
                        .replaceAll("&#8217;", "")
                        .replaceAll("&#8216;", ""),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange[300],
              ),
            );
          },
        ),
      ),
    ));
  }
}

class PostTile extends StatefulWidget {
  final String href, title, desc, content;

  const PostTile({Key key, this.href, this.title, this.desc, this.content})
      : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  var imageUrl = "";

  Widget shortDesc() {
    return HtmlView(
      data: widget.desc,
      onLaunchFail: () {
        print("launch  faild");
      },
      scrollable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(
              imgUrl: imageUrl,
              title: widget.title,
              content: widget.content,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchImage(widget.href),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  imageUrl = snapshot.data["guid"]["rendered"];
                  return Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                        image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data["guid"]["rendered"],
                            ),
                            fit: BoxFit.cover),
                      ));
                }
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightGreen,
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 20.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  )),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  shortDesc(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
