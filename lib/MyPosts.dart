import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'dart:io';
import 'upload.dart';
import 'package:sqflite/sqflite.dart';
import 'package:question_answer/models/uploadPicture.dart';
import 'package:question_answer/utils/databaseHelper.dart';
import 'package:flutter/services.dart';

import 'Dashboard.dart';

class MyPosts extends StatefulWidget {
  int count = 0;

   MyPosts({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut; 

  State<StatefulWidget> createState() {
    return _MyPostsState();
  }
}

class _MyPostsState extends State<MyPosts> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<UploadPicture> uploadList;
  int count = 0;

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
    if (uploadList == null) {
      uploadList = List<UploadPicture>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Questions'),
      ),
      body: getQuestionHistory(),

      floatingActionButton: FloatingActionButton(
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
        tooltip: 'Add More Questions',
        child: Icon(Icons.add),
      ),

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
                  onPressed: _logout
                  )
            ],
          ),
        ),
      ),
    );
  }

  ListView getQuestionHistory() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[500],
              child: Icon(Icons.local_see),
            ),
            title: Text(
              this.uploadList[position].title,
              style: textStyle,
            ),
            subtitle: Text(this.uploadList[position].timestamp),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, uploadList[position]);
              },
            ),
            onLongPress: () {
              debugPrint("Question tapped");
              _addQuestion(this.uploadList[position], 'Edit Question');
            },
          ),
        );
      },
    );
  }

  void _addQuestion(UploadPicture uploadPicture, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Upload(uploadPicture);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, UploadPicture uploadPicture) async {
    int result = await databaseHelper.deleteQuestion(uploadPicture.id);
    if (result != 0) {
      _showSnackBar(context, 'Question Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UploadPicture>> questionListFuture =
          databaseHelper.getAllQuestionsList();
      questionListFuture.then((uploadList) {
        setState(() {
          this.uploadList = uploadList;
          this.count = uploadList.length;
        });
      });
    });
  }
}
