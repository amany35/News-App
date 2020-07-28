import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:newsapp/Screens/detailspage.dart';
class ListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListScreenState();
  }
}

class _ListScreenState extends State<ListScreen> {
  Timer timer;
  String KEY_CATEGORY = "business";

  List data;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget keybuild(String category, String special_category) {
    return Column(
      children: <Widget>[
        Divider(
          thickness: 2.0,
          color: Colors.white,
        ),
        ListTile(
          title: Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
          onTap: () async {
            KEY_CATEGORY = special_category;
            fetch_data_from_api();
            if (_scaffoldKey.currentState.isDrawerOpen) {
              _scaffoldKey.currentState.openEndDrawer();
            }
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => fetch_data_from_api());
    // fetch_data_from_api();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<String> fetch_data_from_api() async {
    var jsondata = await http.get(
        "https://newsapi.org/v2/top-headlines?category=$KEY_CATEGORY&apiKey=9a9a950f67bb47709f45eb0d07114af6");
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata["articles"];
      print(KEY_CATEGORY);
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("News App"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              if (_scaffoldKey.currentState.isDrawerOpen) {
                _scaffoldKey.currentState.openEndDrawer();
              } else {
                _scaffoldKey.currentState.openDrawer();
              }
            },
          ),
        ),
        drawer: Drawer(
            child: Container(
          color: Colors.lightBlue,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Choice Favorite Category : ',
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
              ),
              keybuild("Bussiness", 'business'),
              keybuild("Entertainment", "entertainment"),
              keybuild("General", "general"),
              keybuild("Health", "health"),
              keybuild("Science", "science"),
              keybuild("Sports", "sports"),
              keybuild("Technology", "technology")
            ],
          ),
        )),
        ///////////////////////////
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: data != null
              ? ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                      author: data[index]["author"],
                                      title: data[index]["title"],
                                      content: data[index]["content"],
                                      urlToImage: data[index]["urlToImage"],
                                      publishedAt: data[index]["publishedAt"],
                                      url: data[index]["url"])));
                        },
                        child: Column(
                          children: <Widget>[
                            ListTile(
                                title: Text(data[index]["title"]),
                                leading: Container(
                                  width: 100.0,
                                  height: 80.0,
                                  child: data[index]['urlToImage'] != null
                                      ? Image.network(
                                          data[index]['urlToImage'],
                                        )
                                      : Text(
                                          "Image Not Found",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                )),
                            Divider(
                              thickness: 2.0,
                            )
                          ],
                        ));
                  },
                  itemCount: data == null ? 0 : data.length,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}

///////////////////////////////////////////
