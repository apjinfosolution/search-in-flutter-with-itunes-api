import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
  runApp(
      new MaterialApp(
          home: MyApp())
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  final TextEditingController _SearchController = new TextEditingController();

  List _albums = [];
  int count = 0;


  _onChanged(String value){
//    _albums.clear();
    setState((){
//      print(value);
      if(value.length != 0){
        count=0;
        _albums.clear();
        fetchDetails(value);
        print(value.length);
      }
    });
  }

  _get_result(){
    setState(() {
    print(_albums.length);
    for(var a in _albums){
      count = count + 1;
      print(a);
    }
  });

  }

  Future<List> fetchDetails(String value) async{
    try{
      final response = await http.get('https://itunes.apple.com/search?term=$value', headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
//        print(data);
        print(data["results"]);

//        _albums.addAll(data["results"]);
//        print(_albums);
        _albums.addAll(data["results"]);

        _get_result();

        setState(() {
        });
        return data["results"];
      }

    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Widget _buildChild() {
    if (count != 0) {
      return Expanded(
        child: SafeArea(
            top: false,
            bottom: false,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(_albums.length , (index) {
                print("artist is : ${_albums[index]["artistName"]}");
                return Center(
                  child: Text(
                    'Artist name is ${_albums[index]["artistName"]}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
              }),
            )
        ),
      );
    }else{
      return Text("No items found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  AppBar(
        title:  Text("Search"),
      ),
      body:  Container(
        padding:  EdgeInsets.all(32.0),
        child:  Column(
          children: <Widget>[
            TextField(
              onChanged: (value){
               setState(() {
                 _onChanged(value);
               });
               },
              controller: _SearchController ,
            ),
            _buildChild(),
//            Expanded(
//              child: SafeArea(
//                top: false,
//                bottom: false,
//                child: GridView.count(
//                  crossAxisCount: 2,
//                  shrinkWrap: true,
//                  // Generate 100 widgets that display their index in the List.
//                  children: List.generate(count, (index) {
//                    print("artist is : ${_albums[index]["artistName"]}");
//                    return Center(
//                      child: Text(
//                        'Artist name is ${_albums[index]["artistName"]}',
//                        style: Theme.of(context).textTheme.headline5,
//                      ),
//                    );
//                  }),
//                )
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
