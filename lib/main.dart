import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import 'articulos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required String title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Articulos> articulos = [];
  @override
  void initState() {
    super.initState();
    getWebSiteData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WebScraping'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: articulos.length,
          itemBuilder: (context, index) {
            final articulo = articulos[index];
            return ListTile(
              title: Text(articulo.title),
            );
          },
        ));
  }

  Future getWebSiteData() async {
//    final url = Uri.parse('https://www.amazon.com/s?k=iphone');
    final url = Uri.parse(
        'https://psicologiaymente.com/reflexiones/frases-motivadoras');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
// #article-content-container > h3:nth-child(306)
//       .querySelectorAll('h2 > a > span')
    final titles = html
        .querySelectorAll('> h3')
        .map((element) => element.innerHtml.trim())
        .toList();
    setState(() {
      articulos = List.generate(titles.length,
          (index) => Articulos(url: '', title: titles[index], urlimage: ''));
    });
  }
}
