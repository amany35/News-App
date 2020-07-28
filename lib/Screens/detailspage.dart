
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatefulWidget {
  String title, author, urlToImage, publishedAt, url, content;

  DetailsPage(
      {this.title,
      this.author,
      this.publishedAt,
      this.urlToImage,
      this.url,
      this.content});


  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        widget.urlToImage != null
            ? Image.network(
                widget.urlToImage,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "urlToImage Not Found",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20.0, right: 0.0, bottom: 20.0),
                child: widget.author != null
                    ? Text(
                        widget.author,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      )
                    : Text(
                        "Author Not Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.red),
                      )),
            Text(
              " | ",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            widget.publishedAt != null
                ? Text(
                    widget.publishedAt.substring(0, 10),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                : Text(
                    "publishedAt Not Found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.red),
                  ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(
                top: 0.0, right: 20.0, bottom: 20.0, left: 20.0),
            child: widget.content != null
                ? Text(
                    widget.content,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                : Text(
                    "Content Not Found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.red),
                  )),
        Padding(
            padding: const EdgeInsets.only(
                top: 0.0, right: 20.0, bottom: 20.0, left: 20.0),
            child: widget.url != null
                ? GestureDetector(
                    onTap: () {
                      launch(widget.url);
                    },
                    child: Text(
                      'View Source',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 19.0),
                    ),
                  )
                : Text(
                    "URL Not Found",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.red),
                  )),
      ],
    ));
  }
}
