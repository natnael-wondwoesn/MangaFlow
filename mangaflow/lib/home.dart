import 'package:flutter/material.dart';
import 'package:mangaflow/constants/constants.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  List<Map<String, dynamic>> mangaList = [];
  void getList () async{
    final scrapper = WebScraper(Constants.baseUrl);
    if(await scrapper.loadWebPage('/wwww')){
      List<Map<String, dynamic>> elements = scrapper.getElement('div.container-main-left > div.panel-content-homepage > div > a > img ',['src','alt']);
      elements.forEach((element) {
        mangaList.add({
          'src': element['attributes']['src'],
          'alt': element['attributes']['alt']
          
        });
        print(mangaList);
      });
      setState(() {
        isLoaded = true;
      });
    }

  }
  @override
  void initState() {
    super.initState();
    getList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MangaFlow'),
      ),
      body: isLoaded ? ListView.builder(
        itemCount: mangaList.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(mangaList[index]['alt']),
            leading: Image.network(mangaList[index]['src']),
          );
        },
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}