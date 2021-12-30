import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class PreviewImage extends StatefulWidget {
  int width, height, photographerId;
  String url,
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
  PreviewImage(
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
      this.tiny,
      this.urlPlacehoder});

  String urlPlacehoder;
  int valueDropDown = 6;

  @override
  _PreviewImageState createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void setWallper(int wallpaperLocation) async {
    try {
      var file =
          await DefaultCacheManager().getSingleFile(widget.urlPlacehoder);
      await WallpaperManager.setWallpaperFromFile(file.path, wallpaperLocation);
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Your Wallpaper has been set",
            style: GoogleFonts.aBeeZee(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
        ),
      );
      });

      
    } catch (error) {
      print(error.toString());
    }
  }

  void downloadWallpaper() async {
    try {
      var imageId = await ImageDownloader.downloadImage(widget.urlPlacehoder);
      if (imageId == null) {
        return;
      }

     setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Your Wallpaper has been Donwloaded'),
        duration: Duration(seconds: 2),
      ));
     });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 50,
              child: CachedNetworkImage(
                imageUrl: widget.urlPlacehoder,
                height: MediaQuery.of(context).size.height,
                placeholder: (context, url) =>
                    Image.asset("images/2.gif", height: 100),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: showDropDown(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, top: 10),
                    child: GestureDetector(
                      onTap: () => downloadWallpaper(),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        height: 45,
                        width: 95,
                        child: Text(
                          "Download",
                          style: GoogleFonts.aBeeZee(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => showOptionToset(),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber,
                    ),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Set as Wallpaper",
                      style: GoogleFonts.aBeeZee(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showOptionToset() {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: new Text(
        "Set Wallpaper",
        style: GoogleFonts.aBeeZee(
          color: Colors.white,
        ),
      ),
      content: Container(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setWallper(WallpaperManager.HOME_SCREEN),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  height: 40,
                  child: Text(
                    "Home Screen",
                    style: GoogleFonts.aBeeZee(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setWallper(WallpaperManager.LOCK_SCREEN),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  height: 40,
                  child: Text("Lock Screen", style: GoogleFonts.aBeeZee()),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setWallper(WallpaperManager.BOTH_SCREENS),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  height: 40,
                  child: Text("Both Screen", style: GoogleFonts.aBeeZee()),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel',
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }

  Widget showDropDown() {
    return Container(
      height: 45,
      padding: EdgeInsets.only(left: 15, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          style: GoogleFonts.aBeeZee(color: Colors.black),
          value: widget.valueDropDown,
          hint: Text("Please Select a Size"),
          onChanged: (value) {
            widget.valueDropDown = value;
            switch (value) {
              case 1:
                widget.urlPlacehoder = widget.original;
                break;
              case 2:
                widget.urlPlacehoder = widget.large2x;
                break;
              case 3:
                widget.urlPlacehoder = widget.large;
                break;
              case 4:
                widget.urlPlacehoder = widget.medium;
                break;
              case 5:
                widget.urlPlacehoder = widget.small;
                break;
              case 6:
                widget.urlPlacehoder = widget.portrait;
                break;
              case 7:
                widget.urlPlacehoder = widget.landscape;
                break;
              case 8:
                widget.urlPlacehoder = widget.tiny;
                break;
              default:
                widget.urlPlacehoder = widget.portrait;
                break;
            }
            setState(() {});
          },
          items: const [
            DropdownMenuItem(
              child: Text("Original"),
              value: 1,
            ),
            DropdownMenuItem(
              child: Text("Large 2x"),
              value: 2,
            ),
            DropdownMenuItem(
              child: Text("Large"),
              value: 3,
            ),
            DropdownMenuItem(
              child: Text("Medium"),
              value: 4,
            ),
            DropdownMenuItem(
              child: Text("Small"),
              value: 5,
            ),
            DropdownMenuItem(
              child: Text("Portrait"),
              value: 6,
            ),
            DropdownMenuItem(
              child: Text("Landscape"),
              value: 7,
            ),
            DropdownMenuItem(
              child: Text("Tiny"),
              value: 8,
            ),
          ],
        ),
      ),
    );
  }
}
