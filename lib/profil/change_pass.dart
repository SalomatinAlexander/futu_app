import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/constant/constants.dart';

import '../authoriztion/authorization.dart';
import '../general/profil.dart';



class change_pass extends StatefulWidget{
  const change_pass({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>change_pass_state();

}
class change_pass_state extends State<change_pass>{
  var oldPass = "";
  var newPass = "";
  var isOldPassVisible = false;
  var isNewPassVisible = false;
  var newPassInvisibleColor = constants.invisibleGray;
  var invisibleColor = constants.invisibleGray;
  final myOldPassController = TextEditingController();
  final myNewPassController = TextEditingController();
  final _formChangePass = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myOldPassController.dispose();
    myNewPassController.dispose();
    super.dispose();
  }
  Future<String?> getPass() async{
    final prefs = await SharedPreferences.getInstance();
    var pass = prefs.getString("pass");

    return pass;
  }
  Future<String?> getEmail() async{
    final prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email");

    return email;
  }
  Future<bool> checkNewPass(String value) async{
    var old_pass =  await getPass();
    return old_pass == value;

  }
  Future<void> changePass() async {
    var pass  = await getPass();
    var email = await getEmail();
    if(myOldPassController.text.toString() != pass){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Старый пароль введен неверно')),
      );
      return;

    }
    if(myOldPassController.text.toString() == myNewPassController.text.toString()){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не должны совпадать')),
      );
      return;
    }


    var user = await Backendless.userService.login(email.toString(), pass.toString());
    user?.password = myNewPassController.text.toString();

   // user.setProperty("password", "${myNewPassController.text}");
    print(email);

    Backendless.data.of("Users").save(user!.toJson()).then((value){
      var pr = authorizationState();
      pr.savePassAndMail(myNewPassController.text.toString(), email.toString());
      

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароль сменен')),
      );
      Timer(
          Duration(seconds: 2),
          // Для этого используется статический метод навигатора
          // Это очень похоже на передачу лямбда функции в качестве аргумента std::function в C++
              () {
                Navigator.pushAndRemoveUntil(context, SlideRightRoute(page: profil()), (e) => false);
            }
      );
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Center(

            // Center is a layout widget. It takes a single child and positions it

                child:Form(key: _formChangePass,child:Column(
                  mainAxisSize: MainAxisSize.max,

                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      margin:
                      const EdgeInsets.only(
                          left: 0, right: 0, top: 0, bottom: 0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(70),
                              bottomLeft: Radius.circular(70))),
                      child: Container(
                        padding:
                        EdgeInsets.only(
                            left: 0, right: 0, top: 200, bottom: 20),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(70),
                              bottomLeft: Radius.circular(70)),
                          gradient: LinearGradient(
                            colors: [
                              constants.stateBlueLite,
                              constants.stateBlue,

                            ],
                            begin: FractionalOffset(1.0, 1.0),
                            end: FractionalOffset(0.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        width: double.infinity,
                        height: 570,
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 50), child:
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "Смена пароля",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),

                              ],),
                            ),
                            Container(margin: EdgeInsets.only(top: 70, right: 10, left: 10)
                            , child: TextFormField(
                               validator: (txt){
                                 if (txt!.isEmpty) {
                                   return "Поле должно быть заполненно";
                                 }
                                 if (txt.length < 8) {
                                   return "Пароль должен быть длиннее восьми символов";
                                 }
                               },

                                controller: myOldPassController,
                                obscureText: isOldPassVisible,
                                  obscuringCharacter: "*",
                                  decoration: InputDecoration(
                                    //  focusedBorder: const OutlineInputBorder(borderSide:
                                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.vpn_key,
                                            color: invisibleColor),
                                        onPressed: () {
                                          setState(() {
                                            if (invisibleColor ==
                                                constants.invisibleGray) {
                                              isOldPassVisible = false;
                                              invisibleColor =
                                                  constants.stateBlue;
                                            } else {
                                              isOldPassVisible = true;
                                              invisibleColor =
                                                  constants.invisibleGray;
                                            }
                                          });
                                        }),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: const OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                    focusColor: Colors.white,
                                    hintText: 'Введите пароль',
                                  ),
                              ), ),
                            Container(margin: EdgeInsets.only(top: 20, right: 10, left: 10)
                              , child: TextFormField(
                                validator: (txt){
                                  if (txt!.isEmpty) {
                                    return "Поле должно быть заполненно";
                                  }
                                  if (txt.length < 8) {
                                    return "Пароль должен быть длиннее восьми символов";
                                  }
                                },

                                controller: myNewPassController,
                                obscureText: isNewPassVisible,
                                obscuringCharacter: "*",
                                decoration: InputDecoration(
                                  //  focusedBorder: const OutlineInputBorder(borderSide:
                                  //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.vpn_key,
                                          color: newPassInvisibleColor),
                                      onPressed: () {
                                        setState(() {
                                          if (newPassInvisibleColor ==
                                              constants.invisibleGray) {
                                            isNewPassVisible = false;
                                            newPassInvisibleColor =
                                                constants.stateBlue;
                                          } else {
                                            isNewPassVisible = true;
                                            newPassInvisibleColor =
                                                constants.invisibleGray;
                                          }
                                        });
                                      }),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hoverColor: Colors.white,
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                                  focusColor: Colors.white,
                                  hintText: 'Введите пароль',
                                ),
                              ), )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                if(_formChangePass.currentState?.validate()== true){
                                 changePass();
                                }
                              },

                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(constants.lavender),
                                  shape:
                                  MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            18.0),
                                      ))),
                              child:
                              const Text("Сменить",
                                  style: TextStyle(fontSize: 20,
                                      color: constants.stateBlue))),
                          width: double.infinity,
                          height: 50,
                        ),
                        margin: const EdgeInsets.only(
                            left: 50, top: 20, right: 50, bottom: 0),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(70)))),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                          child: const Text('Назад',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: constants.stateBlue))),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                    ),

                  ],

              )), // This trailing comma makes auto-formatting nicer for build methods.
              ),),);
  }

}