class UploadPicture {

  int _id;
  String _first_picture;
  String _second_picture;
  String _third_picture;
  String _title;
  String _description;
  String _timestamp;

  UploadPicture(this._first_picture, this._second_picture, this._third_picture, this._title, [this._description]);
  UploadPicture.withId(this._id, this._first_picture, this._second_picture, this._third_picture, this._title, [this._description]);

  int get id => _id;

  String get first_picture => _first_picture;

  String get second_picture => _second_picture;

  String get third_picture => _third_picture;

  String get title => _title;

  String get description => _description;

  String get timestamp => _timestamp;

  set first_picture(String newfirst_picture) {
    if (newfirst_picture.length <= 255){
      this._first_picture = newfirst_picture;
    }
  }

  set second_picture(String newsecond_picture) {
    if (newsecond_picture.length <= 255){
      this._second_picture = newsecond_picture;
    }
  }

  set third_picture(String newthird_picture) {
    if (newthird_picture.length <= 255){
      this._third_picture = newthird_picture;
    }
  }

  set title(String newtitle) {
    if (newtitle.length <= 255){
      this._title = newtitle;
    }
  }

  set description(String newdescription) {
    if (newdescription.length <= 255){
      this._description = newdescription;
    }
  }

  set timestamp(String newtimestamp) {
    if (newtimestamp.length <= 255){
      this._timestamp = newtimestamp;
    }
  }

  // Convert table object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (id != null){
      map['id'] = _id;
    }   

    map['first_picture'] = _first_picture;
    map['second_picture'] = _second_picture;
    map['third_picture'] = _third_picture;
    map['title'] = _title;
    map['description'] = _description;
    map['timestamp'] = _timestamp;

    return map;    
  }

  // Extract a Note object from a  Map object

  UploadPicture.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._first_picture = map['first_picture'];
    this._second_picture = map['second_picture'];
    this._third_picture = map['third_picture'];
    this._title = map['title'];
    this._description = map['description'];
    this._timestamp = map['timestamp'];

  }



}