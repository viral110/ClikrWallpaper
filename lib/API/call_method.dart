import 'dart:convert';

import 'package:clikr_wallpaper/Keys/key.dart';
import 'package:clikr_wallpaper/Model/fetch_image.dart';

import 'package:http/http.dart' as http;


class Services {
  List<FetchImageModel> results = new List<FetchImageModel>();
  String nextPageUrl;

  Future<void> getImage(String fetchUrl) async {
    Keys keyObj = Keys();
    String key = keyObj.getKey();
    Map<String, String> headers = {
      "Authorization": "$key",
    };
    var response = await http.get(Uri.parse(fetchUrl), headers: headers);
    var jsonData = jsonDecode(response.body);
    print(jsonData["photos"].length);
    if (jsonData["photos"].length != 0) {
      jsonData["photos"].forEach((element) {
        FetchImageModel itemObject = FetchImageModel();
        itemObject.height = element["height"];
        itemObject.width = element["width"];
        itemObject.photographerId = element["photographer_id"];
        itemObject.photographerName = element["photographer"];
        itemObject.photographerUrl = element["photographer_url"];
        itemObject.url = element["url"];
        itemObject.original = element["src"]["original"];
        itemObject.large2x = element["src"]["large2x"];
        itemObject.large = element["src"]["large"];
        itemObject.medium = element["src"]["medium"];
        itemObject.small = element["src"]["small"];
        itemObject.tiny = element["src"]["tiny"];
        itemObject.portrait = element["src"]["portrait"];
        itemObject.landscape = element["src"]["landscape"];

        results.add(itemObject);
      });

      nextPageUrl = jsonData["next_page"];
    }
  }
}