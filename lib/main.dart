import 'dart:core';
import 'package:flutter/material.dart';
import 'githubCard.dart';
import 'githubCard_view.dart';
import 'github_data_download.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Github card project with flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  //when we add element to _items in the setState() method
  //the framework update the view
  List<Widget> _items = List<GithubCardItem>();

  @override
  void initState() {
    super.initState();
    print("start download");
    _downloadData();
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key : scaffoldKey,
        appBar: AppBar(title: Text(widget.title)),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) => _items[index],
          itemExtent: 140.0,
          itemCount: _items.length,
        ),
        floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            _downloadData();
          },
        )
    );
  }

  ///
  ///this function take a github project and extract important data ( need for create a GithubCard)
  ///
   GithubCard _extractDataFromJson(Map githubCard){
    GithubCard card = GithubCard(
        githubCard["name"],
        githubCard["owner"]["avatar_url"],
        githubCard["description"],
        githubCard["stargazers_count"],
        githubCard["open_issued_count"],
        githubCard["html_url"]);
    return card;
  }

  //this function call MyHttpCall and then downlaod the data
  void _downloadData(){
    MyHttpCall.getData().then((jsonData) {
      //check if i have card to display
      if(jsonData["items"] != null){
        for(var githubCard in jsonData["items"]){
          setState(() {
            GithubCard card = _extractDataFromJson(githubCard);
            this._items.add(new GithubCardItem(card));
          });
        }
      }
    });
  }
}
