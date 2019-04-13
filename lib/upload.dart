import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:question_answer/models/uploadPicture.dart';
import 'package:question_answer/utils/databaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'Home.dart';
import 'package:question_answer/Crud.dart';
import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'asset_view.dart';
import 'package:multi_image_picker/asset.dart';
import 'MyPosts.dart';

class Upload extends StatefulWidget {
  final UploadPicture uploadPicture;

  Upload(this.uploadPicture);

  State<StatefulWidget> createState() {
    return _UploadPageState(this.uploadPicture);
  }
}

class _UploadPageState extends State<Upload> {
  _UploadPageState(this.uploadPicture);

  DatabaseHelper databaseHelper = DatabaseHelper();
  UploadPicture uploadPicture;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  //List images;
  List<Asset> images = List<Asset>();
  String _error;
  

 

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    //titleController.text = uploadPicture.title;
    //descriptionController.text = uploadPicture.description;
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Ask Question'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildGridView(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: buildTextField(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: buildTextField_2(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      // onPressed: validateAndSave,
                      onPressed: () {
                        setState(() {
                          debugPrint("Save Button Clicked");
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Colors.white,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                      // onPressed: validateAndSave,
                      onPressed: () {
                        setState(() {
                          debugPrint("Cancel Button Clicked");
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            loadAssets();
          },
          tooltip: 'Add More Questions',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return Container(
      height: 300.0,
      width: 400.0,
      child: GridView.count(
        crossAxisCount: 3,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        children: List.generate(images.length, (index) {
          return AssetView(index, images[index]);
        }),
      ),
    );
  }

  Widget buildTextField() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return TextField(
      controller: titleController,
      style: textStyle,
      onChanged: (value) {
        debugPrint('Something has chaged in Title text Field');
        updateTitle();
      },
      decoration: new InputDecoration(
        labelText: 'Title',
        labelStyle: textStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );
  }

  Widget buildTextField_2() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return TextField(
      controller: descriptionController,
      style: textStyle,
      onChanged: (value) {
        debugPrint('Something has changed in the Descriptiom text Field');
        updateDescripton();
      },
      decoration: new InputDecoration(
        labelText: 'Description',
        labelStyle: textStyle,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
      );
    } on PlatformException catch (e) {
      error = e.message;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  void _moveToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Home();
    }));
  }

  void _moveToLastScreen() {
    Navigator.pop(context, true);
    {}
  }

  void updateTitle() {
    uploadPicture.title = titleController.text;
  }

  void updateDescripton() {
    uploadPicture.description = titleController.text;
  }

  void _save() async {
    _moveToLastScreen();
    //_addImages();
    uploadPicture.timestamp = DateFormat.yMMMd().format(DateTime.now());
    uploadPicture.first_picture = '15545454';
    uploadPicture.second_picture = '545454545';
    uploadPicture.third_picture = '9874515365';
    int result;

    if (uploadPicture.id == null) {
      //save Question to the database
      result = await databaseHelper.uploadPictures(uploadPicture);
    } else {
      //Update
      result = await databaseHelper.updatePictures(uploadPicture);
    }

    if (result == 0) {
      //Failuere
      _alertShow('Status', 'Question Posted Unsuccesfully');
    } else {
      //Success
      _alertShow('Status', 'Question Posted succesfully');
    }

    /*  ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("some_image_bame.jpg");
    StorageUploadTask uploadTask = ref.putData(imageData);

    // Release the image data
    asset.releaseOriginal(); */

    //return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  void _delete() async {
    _moveToLastScreen();

    //first case of delete
    if (uploadPicture.id == null) {
      _alertShow('Status', 'No Question to delete');
      return;
    }

    // second case
    int result = await databaseHelper.deleteQuestion(uploadPicture.id);
    if (result == 0) {
      //Failure
      _alertShow('Status', 'Problem Deleting Question');
    } else {
      //Success
      _alertShow('Status', 'Question Deleted succesfully');
    }
  }

  void _alertShow(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

/*   void _saveImages(AssetView(index, images)) async {  
    ByteData byteData = await images.requestOriginal();


    
   
  }  */

  
    

}
