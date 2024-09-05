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
        // print(mangaList);
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
      body: isLoaded ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index){
          return MangaCard(
            mangaList[index]['alt'], 
            mangaList[index]['src'])
            ;
        },
      ) : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Widget MangaCard (String title, String imageUrl){
  return Container(
    width: 120,
    height: 187,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            fit: BoxFit.cover,
            imageUrl)),
        if (title.length > 20) Text(title.substring(0, 20) + '...' )else Text(title), 
      ],
    ),
  );
}