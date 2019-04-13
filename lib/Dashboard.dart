import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:dio/dio.dart';
import 'Home.dart';
import 'MyPosts.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'dart:io';
import 'upload.dart';
import 'package:sqflite/sqflite.dart';
import 'package:question_answer/models/uploadPicture.dart';
import 'package:question_answer/utils/databaseHelper.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();

  Dashboard({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;
}

class _DashboardState extends State<Dashboard> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  //TODO: Make the http search request
  String _searchText = "";
  List names = new List(); // names we get from API
  List filteredNames = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Dashboard');

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Material meetMeTiles(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    heading,
                    style: TextStyle(
                      color: new Color(color),
                      fontSize: 20.0,
                    ),
                  ),
                ),

                //Icon
                Material(
                  color: new Color(color),
                  borderRadius: BorderRadius.circular(24.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //build for all widgets implemented as follows
    return Scaffold(
      appBar: _buildBar(context),
      //continue from here

      // In the body this should be insertedL child: _buildList(),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          //meetMeTiles(Icons.search, "Search Questions", 0xffed622b),

          RaisedButton(
            padding: const EdgeInsets.all(1.0),
            child: meetMeTiles(Icons.add, "Post Questions", 0xff3399fe),
            color: Colors.white,
            onPressed: () {
              _addQuestion(
              UploadPicture(
                '',
                '',
                '',
                '',
              ),
              'Post Question');
            },
          ),

          RaisedButton(
            padding: const EdgeInsets.all(1.0),
            child: meetMeTiles(Icons.view_list, "See Questions", 0xffff3266),
            color: Colors.white,
            onPressed: () {
              // open a screen to show all questions
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),

          RaisedButton(
            padding: const EdgeInsets.all(1.0),
            child: meetMeTiles(Icons.graphic_eq, "My Questions", 0xffed622b),
            color: Colors.white,
            onPressed: () {
              // open a screen to show all questions
              _myposts();
            },
          ),

          /* RaisedButton(
            padding: const EdgeInsets.all(1.0),
            child: meetMeTiles(
                Icons.graphic_eq, "Most recently posted questions", 0xff3399fe),
                color: Colors.white,
            onPressed: () {
              // open a screen to show all questions
            },
          ),  */

          _buildList(),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 150.0),
          StaggeredTile.extent(2, 240.0),
        ],
      ),
      resizeToAvoidBottomPadding: false,

      // Bottom Navigation

      bottomNavigationBar: new BottomAppBar(
        color: Colors.blue[500],
        child: new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.dashboard),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: _dashboard),
        
              new IconButton(
                  icon: new Icon(Icons.account_box),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: _myposts),
              new IconButton(
                  icon: new Icon(Icons.exit_to_app),
                  iconSize: 40,
                  color: Colors.white,
                  onPressed: _logout)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      backgroundColor: Color(0xff3399fe),
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  /* Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index]['name']),
          onTap: () => print(filteredNames[index]['name']),
        );
      },
    );
  } */

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Question');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  //Get the questions from the api.
  //A code similar to this
  void _getNames() async {
    final response = await dio.get('https://swapi.co/api/people');
    List tempList = new List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tempList.add(response.data['results'][i]);
    }
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }

  Widget _buildList() => ListView(
        children: [
          _tile(
              'Q: What’s the difference between regular food and organic food?',
              'A: It’s all about how...',
              Icons.question_answer),
          _tile(
              'Q: Do you know why there are black holes in space? Are there any undiscovered plants [sic?] in space?',
              'A: Black holes aren’t really holes in space....',
              Icons.question_answer),
          _tile(
              'Q: Have you found a dinosaur as big as a jumbo jet?',
              'A: Me personally? No. Other people? Yes. Or…',
              Icons.question_answer),
          _tile(
              'Q: Why is the sky blue, and not green or black? It looks black from outer space.',
              'A: The sky is blue...',
              Icons.question_answer),
          _tile(
              'Q: How old is the oldest person in the world?',
              'A: The oldest living person is Gertrude Baines....',
              Icons.question_answer),
          _tile(
              'Q: How long can turtles live?',
              'A: Oooh. I like this one. Large tortoise....',
              Icons.question_answer),
          Divider(),
          _tile(
              'Q: Where do elephants live?',
              'A: Africa, India, Sri Lanka, Nepal, China,...',
              Icons.question_answer),
          _tile(
              'Q: How many explosions have you made while working.',
              'A: It depends on your definition of “explosions...”',
              Icons.question_answer),
          _tile(
              'Q: Does the science museum ever get boring?',
              'A: No. Never. I have the scars to prove it.',
              Icons.question_answer),
          _tile(
              'Q: Do you catch snakes?',
              'A: Not frequently, but sometimes, yes. In my last house ...',
              Icons.question_answer),
        ],
      );

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );

  void _myposts() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new MyPosts();
      //return new AddPost();
    }));
  }
  void _addQuestion(UploadPicture uploadPicture, String title) async {
    
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Upload(uploadPicture);
    }));
    
  }

  void _dashboard() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new Dashboard();
      //return new AddPost();
    }));
  }

  void _logout() async {
    try {
      await widget.auth.SignOut();
      widget.onSignedOut();
    } catch (e) {
      print("Error : " + e.toString());
    }
  }
}
