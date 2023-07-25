import 'package:flutter/foundation.dart';
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
            var xHora =  articulo.hora.substring(0,4);
            var xOper =  articulo.hora.substring(5,articulo.hora.length); 
            return Expanded(
              child: ListTile(
                leading: Image.network('https://lotoven.com/${articulo.urlimage}',height: 100,width: 100,),
                title: Text(articulo.nombre,
                style:const TextStyle(fontSize: 26)),
                subtitle:  Text(
                  '${articulo.numero} Hora:${articulo.hora}',style:const TextStyle(fontSize: 16)),
              ),
            );
          },
        ));
  }

  Future getWebSiteData() async {
//    final url = Uri.parse('https://www.amazon.com/s?k=iphone');
  
    final url = Uri.parse(
        'https://lotoven.com/animalitos/');
   try {
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final numero = html
        .querySelectorAll('h4 > small')
        .map((element) => element.innerHtml.trim())
        .toList();
    final nombre = html
        .querySelectorAll(' > span.info')
        .map((element) => element.innerHtml.trim())
        .toList();
    final hora = html
        .querySelectorAll(' div > span.info2')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urlimage = html
        .querySelectorAll(' > div > div > img')
        .map((element) => element.attributes['src']!)
        .toList();
    urlimage.remove('/assets/images/investment/thumb-min.webp');
    print (urlimage.length);
    setState(() {
      articulos = List.generate(nombre.length,
          (index) => Articulos(numero:'',
           urlimage: urlimage[index],
           nombre: nombre[index],
           hora:hora[index],));
    });

   }catch (e){
    if (kDebugMode) {
      // ignore: prefer_interpolation_to_compose_strings
      print('{eeee$e}');
    }
   }

// #article-content-container > h3:nth-child(306)
//       .querySelectorAll('h2 > a > span')
  }
}
