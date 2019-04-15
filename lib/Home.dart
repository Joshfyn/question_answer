import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'Authentication.dart';
import 'dart:io';
import 'MyPosts.dart';
import 'Dashboard.dart';
import 'upload.dart';
import 'package:question_answer/models/uploadPicture.dart';

import 'package:sqflite/sqflite.dart';
import 'package:question_answer/utils/databaseHelper.dart';

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
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<UploadPicture> uploadList;

  List<String> photo;
  

  int count = 0;

  int photoIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (uploadList == null) {
      uploadList = List<UploadPicture>();
      updateView();
    }
    //image();

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
      body: showQuestion(),
    );
      
  }


  ListView showQuestion(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Column(
            children: <Widget>[
            
              
              
            ],
            
           
          ),
        );
      },
    );
    

  }

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

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

  
  void updateView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UploadPicture>> questionListFuture =
          databaseHelper.getPictureList();
      questionListFuture.then((uploadList) {
        setState(() {
          this.uploadList = uploadList;
        });
      });
    });
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
