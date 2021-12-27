

import 'dart:async';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/authoriztion/remember_pass.dart';
import 'package:untitled3/constant/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/authoriztion/registration.dart';

import '../profil/generalToolbar.dart';



class authorization extends StatefulWidget {
 // const authorization({Key? key}) : super(key: key);

  // const Authorization({Key? key}) : super(key: key);
  @override
  State<authorization> createState() => authorizationState();
}

class authorizationState extends State<authorization> {
  var isPassIconPress = constants.invisibleGray;
  var email = "";
  var obscurePass = true;
  var pass = "";
  final _formKey = GlobalKey<FormState>();
  final isLog = "isLogin" ;
  var isLogResult = 0;
  var  IsAuthorization = false;

  _changeEmail(String text) {
    setState(() => email = text);
  }

  _changePass(String text) {
    setState(() => pass = text);
  }

  void savePassAndMail(String pass, String email) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("pass", pass);


}
@override
  void initState() {
    super.initState();
  }
  setPref(int value) async{
    print("set pref  = $value");
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(isLog, value);
  }


  @override
  Widget build(BuildContext context)  {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // Column is also a layout widget. It takes a list of children and
                    // arranges them vertically. By default, it sizes itself to fit its
                    // children horizontally, and tries to be as tall as its parent.
                    //
                    // Invoke "debug painting" (press "p" in the console, choose the
                    // "Toggle Debug Paint" action from the Flutter Inspector in Android
                    // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                    // to see the wireframe for each widget.
                    //
                    // Column has various properties to control how it sizes itself and
                    // how it positions its children. Here we use mainAxisAlignment to
                    // center the children vertically; the main axis here is the vertical
                    // axis because Columns are vertical (the cross axis would be
                    // horizontal).
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
                                    "Futu",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  Icon(
                                    Icons.directions_car, color: Colors.white,
                                    size: 30,)
                                ],),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 50, right: 18, bottom: 0),
                                child: TextFormField(
                                  onChanged: _changeEmail,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Поле должно быть заполнено";
                                    }
                                    String pattern =
                                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                        r"{0,253}[a-zA-Z0-9])?)*$";
                                    RegExp regExp = RegExp(pattern);

                                    if (regExp.hasMatch(value)) {
                                      email = value;
                                      return null;
                                    } else {
                                      return "Email введен некоррекно";
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                    hintText: 'Введите email',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 15),
                                child: TextFormField(
                                  onChanged: _changePass,
                                  obscureText: obscurePass,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Поле должно быть заполненно";
                                    }
                                    if (value.length < 8) {
                                      return "Пароль должен быть длиннее восьми символов";
                                    }
                                  },
                                  obscuringCharacter: "*",
                                  decoration: InputDecoration(
                                    //  focusedBorder: const OutlineInputBorder(borderSide:
                                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.vpn_key,
                                            color: isPassIconPress),
                                        onPressed: () {
                                          setState(() {
                                            if (isPassIconPress ==
                                                constants.invisibleGray) {
                                              obscurePass = false;
                                              isPassIconPress =
                                                  constants.stateBlue;
                                            } else {
                                              obscurePass = true;
                                              isPassIconPress =
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          child: SizedBox(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      pass.length > 8) {
                                    Backendless.userService.login(email, pass)
                                        .then((value) {
                                          setPref(1);
                                          savePassAndMail(pass, email);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Вход выполнен успешно")));

                                      Navigator.push(context, SlideRightRoute(
                                          page: generalToolbar()));
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Произошла ошибка, проверьте корректность введеных данных")));
                                    });
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
                                const Text("Войти",
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
                              Navigator.push(context, SlideRightRoute(
                                  page: registration()));
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white)),
                            child: const Text('Регистрация',
                                style: TextStyle(
                                    fontSize: 18, color: constants.stateBlue))),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                      ),
                      Container(
                        child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text("Забыли пароль? "),
                                Align(child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        SlideRightRoute(page: remember_pass()));
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                          EdgeInsets.only(right: 0)),
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),

                                  child: Text('Восстановить',
                                      style: TextStyle(fontSize: 15,
                                          color: constants.stateBlue)),),
                                  alignment: Alignment.centerLeft,),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      )
                    ],
                  ), key: _formKey,
                )), // This trailing comma makes auto-formatting nicer for build methods.
          ));
    }
  }




class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
class CheckAuthorisation extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => checkAuthState();
}
class checkAuthState extends State<CheckAuthorisation>{
  Widget generalWidget = authorization();
  final isLog = "isLogin" ;
  var isLogResult = 0;
  var  IsAuthorization = false;
  Future<int> getPref() async{

    final prefs = await SharedPreferences.getInstance();
    print("get pref  = ${prefs.getInt(isLog)}");
    isLogResult = prefs.getInt(isLog) ?? 0;
    return isLogResult;

  }
  setPref(int value) async{
    print("set pref  = $value");
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(isLog, value);
  }
  Future<void> isAuth() async {
    var pref = await getPref();
    if(pref == 1){
      print("in toolbar");

        generalWidget = generalToolbar();


    }
    if(pref == 0){

        generalWidget =authorization();


    }
  }
  @override
  void initState() {
    super.initState();
    // Создаём таймер, который должен будет переключить SplashScreen на HomeScreen через 2 секунды
    Timer(
        Duration(seconds: 2),
        // Для этого используется статический метод навигатора
        // Это очень похоже на передачу лямбда функции в качестве аргумента std::function в C++
            (){ Navigator.push(context,SlideRightRoute(page: generalWidget));}
    );
  }
  @override
  Widget build(BuildContext context) {
    isAuth();

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Добро пожаловать!",
              style: TextStyle(color: Colors.white,
                  fontSize: 20, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
    //n build");

  }


}
