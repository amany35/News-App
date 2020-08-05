import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
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

  bool is_loading = false;
  Timer timer;
  String KEY_CATEGORY = "business";

  List data;
  //////////////////////////////////////////////////////


  Widget keybuild(String category, String special_category) {
    return GestureDetector(
      onTap: () async {
        is_loading = false;
        print("${is_loading} button");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });

        KEY_CATEGORY = special_category;
        await fetch_data_from_api();
        Navigator.pop(context);
      },
      child: Text(
        category,
        style: TextStyle(
            fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.fetch_data_from_api();
    });

    time();

  }

  time(){
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) async {

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      await fetch_data_from_api();
      Navigator.pop(context);

    } );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<String> fetch_data_from_api() async {


    // Navigator.pop(context);


    var jsondata = await http.get(
        "https://newsapi.org/v2/top-headlines?category=$KEY_CATEGORY&apiKey=9a9a950f67bb47709f45eb0d07114af6");
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      is_loading = true;
      print("${is_loading} fetch");
      data = fetchdata["articles"];

      print(KEY_CATEGORY);

    });

    return "Sucses";


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.purple,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      keybuild("Bussiness", 'business'),
                      SizedBox(
                        width: 15.0,
                      ),
                      keybuild("Entertainment", "entertainment"),
                      SizedBox(
                        width: 15.0,
                      ),
                      keybuild("General", "general"),
                      SizedBox(
                        width: 15.0,
                      ),
                      keybuild("Health", "health"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      keybuild("Science", "science"),
                      SizedBox(
                        width: 15.0,
                      ),
                      keybuild("Sports", "sports"),
                      SizedBox(
                        width: 15.0,
                      ),
                      keybuild("Technology", "technology"),
                    ],
                  ),
                )
              ],
            ),
          ),
//////////////

          ////////////////////
          SizedBox(
            height: 20.0,
          ),

          Expanded(
            child: is_loading
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
          ),
        ],
      ),
    ));
  }
}

///////////////////////////////////////////
