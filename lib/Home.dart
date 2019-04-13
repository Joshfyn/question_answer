import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'dart:io';
import 'MyPosts.dart';
import 'Dashboard.dart';
import 'upload.dart';
import 'package:question_answer/models/uploadPicture.dart';

class Home extends StatefulWidget {
  Home({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int photoIndex = 0;
  List<String> photos = [
    'images/image2.png',
    'images/graph.png',
    'images/image1.png',
    'images/image3.png'
  ];
  List<String> questionsList = [
    'What’s the difference between regular food and organic food?',
    'How old is the oldest person in the world?',
    'Do you catch snakes?'
  ];
  List<String> photosList = [
    'images/image5.jpg',
    'images/image7.jpeg',
    'images/image6.jpg'
  ];

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }

  var _isLoading = true;

  void _myposts() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new MyPosts();
      //return new AddPost();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Posts'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              print("Reloading..");
              setState(() {
                _isLoading = false;
              });
            },
          )
        ],
      ),
      body: ListView(shrinkWrap: true, children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(photos[photoIndex]),
                          fit: BoxFit.cover)),
                ),
                GestureDetector(
                  child: Container(
                    height: 400.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  onTap: _nextImage,
                ),
                GestureDetector(
                  child: Container(
                    height: 400.0,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.transparent,
                  ),
                  onTap: _previousImage,
                ),
                Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: Icon(
                                Icons.favorite,
                                //color: Colors.red,
                              ),
                            ))
                      ],
                    )),
                Positioned(
                  top: 375.0,
                  left: 25.0,
                  right: 25.0,
                  child: SelectedPhoto(
                    numberOfDots: photos.length,
                    photoIndex: photoIndex,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Text(
                'Graphs',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'Which graph is easily understandable ? ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            _buildListItems(photosList[0], questionsList[0]),
            SizedBox(height: 10.0),
            _buildListItems(photosList[1], questionsList[1]),
            SizedBox(height: 10.0),
            _buildListItems(photosList[2], questionsList[2]),
          ],
        ),
      ]),

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
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: _dashboard),
              new IconButton(
                  icon: new Icon(Icons.account_box),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: _myposts),
              new IconButton(
                  icon: new Icon(Icons.exit_to_app),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: _logout)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItems(String picture, String question) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(picture), fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0))),
          ),
          SizedBox(width: 10.0),
          Container(
            height: 100.0,
            width: 300.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  question,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      )
    ]);
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(4.0)),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return new Container(
      child: new Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}
