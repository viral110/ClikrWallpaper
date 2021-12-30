import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clikr_wallpaper/API/call_method.dart';
import 'package:clikr_wallpaper/API/suggestion_call.dart';
import 'package:clikr_wallpaper/Model/fetch_image.dart';
import 'package:clikr_wallpaper/Model/suggestion_choice.dart';
import 'package:clikr_wallpaper/Widget/common_widget.dart';
import 'package:clikr_wallpaper/view/preview_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<FetchImageModel> curated = new List<FetchImageModel>();
  List<SChoices> choices = new List<SChoices>();
  var searchBar = TextEditingController();
  String nextPageURL;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchBar.dispose();
    super.dispose();
  }

  bool _loading = true, searchBarVisibility = false;
  @override
  void initState() {
    super.initState();
    getChoices();
    getCuratedImages("nature");
  }

  void getChoices() {
    GetSChoices obj = new GetSChoices();
    choices = obj.getList();
    setState(() {});
  }

  void getCuratedImages(String keyWord) async {
    Services obj = new Services();
    await obj.getImage(
        "https://api.pexels.com/v1/search?query=$keyWord&per_page=15");
    curated = obj.results;
    nextPageURL = obj.nextPageUrl;
    setState(() {
      _loading = false;
      searchBarVisibility = false;
    });
  }

  void loadMoreImages(String url) async {
    Services obj = new Services();
    await obj.getImage(url);
    curated.addAll(obj.results);
    nextPageURL = obj.nextPageUrl;
    setState(() {
      _loading = false;
      searchBarVisibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: cappbar(),
          backgroundColor: Colors.black,
          body: _loading
              ? Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 45,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white38,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: GoogleFonts.aBeeZee(
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    controller: searchBar,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  String st = searchBar.text;
                                  if (st != null || st != "")
                                    getCuratedImages(st);
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 15),
                        child: Container(
                          height: 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  getCuratedImages(choices[index].nameImage);
                                },
                                child: ChoiceTiles(
                                    url: choices[index].imageUrl,
                                    keyString: choices[index].nameImage),
                              );
                            },
                            itemCount: choices.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (curated.length == 0) {
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      // Image.asset("assets/images/empty.gif"),
                                      Text(
                                        "No results found",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              if (index < curated.length) {
                                return ImageTiles(
                                    width: curated[index].width,
                                    height: curated[index].height,
                                    photographerId:
                                        curated[index].photographerId,
                                    url: curated[index].url,
                                    photographerName:
                                        curated[index].photographerName,
                                    photographerUrl:
                                        curated[index].photographerUrl,
                                    original: curated[index].original,
                                    large2x: curated[index].large2x,
                                    large: curated[index].large2x,
                                    medium: curated[index].medium,
                                    small: curated[index].small,
                                    portrait: curated[index].portrait,
                                    landscape: curated[index].landscape,
                                    tiny: curated[index].tiny);
                              } else {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 15),
                                    child: RaisedButton(
                                      color: Colors.amber,
                                      onPressed: () {
                                        loadMoreImages(nextPageURL);
                                      },
                                      child: Text(
                                        "Load More",
                                        style: GoogleFonts.aBeeZee(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ));
                              }
                            }
                          },
                          itemCount: curated.length + 1,
                        ),
                      )),
                    ],
                  ),
                )),
    );
  }
}

class ImageTiles extends StatelessWidget {
  ImageTiles(
      {this.width,
      this.height,
      this.photographerId,
      this.url,
      this.photographerName,
      this.photographerUrl,
      this.original,
      this.large2x,
      this.large,
      this.medium,
      this.small,
      this.portrait,
      this.landscape,
      this.tiny});

  int width, height, photographerId;
  final url,
      photographerName,
      photographerUrl,
      original,
      large2x,
      large,
      medium,
      small,
      portrait,
      landscape,
      tiny;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: InkWell(
        highlightColor: Colors.blueAccent,
        focusColor: Colors.blueGrey,
        splashColor: Colors.lightBlue,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PreviewImage(
                      width: width,
                      height: height,
                      photographerId: photographerId,
                      url: url,
                      photographerName: photographerName,
                      photographerUrl: photographerUrl,
                      original: original,
                      large2x: large2x,
                      large: large2x,
                      medium: medium,
                      small: small,
                      portrait: portrait,
                      landscape: landscape,
                      tiny: tiny,
                      urlPlacehoder: portrait)));
        },
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 350,
                    placeholder: (context, url) => Container(
                      height: 50,
                      child: Image.asset(
                            "images/2.gif",
                            
                            width: 340,
                            fit: BoxFit.fill,
                          ),
                    ),
                    imageUrl: landscape),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChoiceTiles extends StatelessWidget {
  ChoiceTiles({this.url, this.keyString});
  final keyString, url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.amber.withOpacity(0.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              url,
              height: 60,
              width: 130,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black26,
            ),
            child: Text(
              keyString,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
