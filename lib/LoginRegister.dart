import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';



class LoginRegisterPage extends StatefulWidget {

  LoginRegisterPage({

    this.auth,
    this.onSignedIn, onSignedOut,

});

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState ()
{
  return _LoginRegisterState();
}
}

enum FormType{
  login,
  register

}


class _LoginRegisterState extends State <LoginRegisterPage>  {


  DialoBox dialoBox = new DialoBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";


  //Methods

  bool validateAndSave(){

    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void validateAndSubmit() async {

    if(validateAndSave()){
      try{
        if(_formType == FormType.login ){
          String userId = await widget.auth.SignIn(_email, _password);
          print("Login Userid : "+ userId);
        }else{

          String userId = await widget.auth.SignUp(_email, _password);
          print("Register userId : "+ userId);

        }
        widget.onSignedIn();

      }catch(e){

        dialoBox.information(context, "Error : ", e.toString());


        print("Error : "+ e.toString());

      }


    }
  }

  void moveToRegister(){

    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }


  void moveToLogin(){

    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }


  //Design
         @override
  Widget build(BuildContext context) {

    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Q-A meetup!"),
      ),

      body: new Container(

        margin: EdgeInsets.all(15.0),

        child: new Form(

          key: formKey,
            child: new Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: createInput() + createButtons(),


            )

        ),


      ),
    );
  }



  List<Widget> createInput()
  {
    return [

      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField(

        decoration: new InputDecoration(
            labelText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0)

          ),
        ),


        validator: (value){
          return value.isEmpty?'enter email':null;
        },

        onSaved: (value){
          return _email = value;
        },

      ),

     SizedBox(height: 10.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0)

        ),
        ),

        obscureText: true,

        validator: (value){
          return value.isEmpty?'enter password':null;
        },

        onSaved: (value){
          return _password = value;
        },


      ),
        SizedBox(height: 10.0,),
      


    ];

  }

  Widget logo(){



    return new Container(

        child: new CircleAvatar(
                 backgroundColor: Colors.transparent,
                 radius: 40.0,
                 child:
                 Image.asset('images/Q-A.jpg')
               )

    );


  }



         List<Widget> createButtons() {
           if (_formType == FormType.login) {
             return [

               new RaisedButton(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(24),

                 ),
                 padding: EdgeInsets.symmetric(vertical: 10.0),
                 child: new Text(
                   'Login', style: new TextStyle(fontSize: 20.0),

                 ),

                 textColor: Colors.white,
                 color: Colors.pink,



                 onPressed: validateAndSubmit,

               ),

               new FlatButton(
                 child: new Text(
                   'Register !', style: new TextStyle(fontSize: 14.0),),
                 textColor: Colors.blue,

                 onPressed: moveToRegister,


               )


             ];
           }
           else
         {

           return [

             new RaisedButton(

               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(24),
               ),
               padding: EdgeInsets.symmetric(vertical: 10.0),
               child: new Text(
                 'Register', style: new TextStyle(fontSize: 20.0),),
               textColor: Colors.white,
               color: Colors.pink,

               onPressed: validateAndSubmit,
             ),

             new FlatButton(
               child: new Text(
                 'Already have an account?', style: new TextStyle(fontSize: 14.0),),
               textColor: Colors.blue,

               onPressed: moveToLogin,

             )


           ];
         }
         }

}