import 'dart:async';
import 'dart:io';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/constant/constants.dart';


import 'change_pass.dart';

class setting_profil extends StatefulWidget {
  const setting_profil({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => setting_profil_state();
}

class setting_profil_state extends State<setting_profil> {
  File _image = File("");
  Widget userImage = const Icon(
    Icons.person,
    size: 50,
  );
  DateTime valueDate = DateTime.now();
  final nameCont = TextEditingController();
  final sonameCont = TextEditingController();
  final DateCont = TextEditingController();
  final EmailCont = TextEditingController();
  final TeleCont = TextEditingController();
  var maleBtnColor = Colors.white;
  var femaleBtnColor = Colors.white;
  var maleTxtColor = Colors.black;
  var femaleTxtColor = Colors.black;
  var userGender = -1;
  String user_name = "";
  String reg_date = "";
  String user_soname = "";
  String user_brth = "";
  String user_email = "";
  String user_tele = "";
  String user_gender = "";
  String age = "";
  String foto_uri = "null";
  static const String USER_NAME_VALUE = "username";
  static const String USER_AGE_VALUE = "userage";
  static const String USER_REG_DATE_VALUE = "userregdate";
  static const String USER_FOTO_URI_VALUE = "userUri";

  static const String USER_TELE_VALUE = "userTele";
  static const String USER_GENDER_VALUE = "userGender";
  static const String USER_SONAME_VALUE = "usersoname";
  final _settingProfilKey = GlobalKey<FormState>();

  Future<void> getGalleryImage() async {
    var picker = ImagePicker();
    var image = await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      print(value!.path);
      _image = File("${value.path}");
      loadPhoto();
    });

    setState(() {});
  }

  Future<void> saveData() async{
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Сохранение...")));
    if(!_settingProfilKey.currentState!.validate()){
      return;
    }
    var ch = change_pass_state();
    var pass = await ch.getPass();
    var email = await ch.getEmail();
    Backendless.userService
        .login(email.toString(), pass.toString())
        .then((user) async {
      final prefs = await SharedPreferences.getInstance();

          var newUser = user;
          newUser!.setProperty("name", nameCont.text);
          newUser!.setProperty("DateBth", DateCont.text);
          newUser!.setProperty("Soname",  sonameCont.text);
          newUser!.setProperty("telephone",  TeleCont.text);
          newUser!.setProperty("photo_id", foto_uri);
          newUser!.setProperty("gender", user_gender);

          prefs.setString(USER_NAME_VALUE, nameCont.text)!;
          prefs.setString(USER_AGE_VALUE, DateCont.text)!;
          prefs.setString(USER_FOTO_URI_VALUE, foto_uri)!;
          prefs.setString(USER_TELE_VALUE, TeleCont.text)!;
          prefs.setString(USER_SONAME_VALUE, sonameCont.text)!;
          if(userGender == 0) {
            user_gender = "0";
            prefs.setString(USER_GENDER_VALUE, user_gender)!;
          }
      if(userGender == 1) {
        user_gender = "1";
        prefs.setString(USER_GENDER_VALUE, user_gender)!;
      }

      Backendless.data.of("Users").save(newUser!.toJson()).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Данные сохранены")));
        Navigator.pop(context);

      }).onError((error, stackTrace) {
        print("Все по пизде1 $error");
      });
    });

  }
  Future<bool> onBackPress() async{
    saveData();
    return false;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: valueDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2022));
    if (picked != null && picked != valueDate) {
      setState(() {
        valueDate = picked;


        var date = "${valueDate.toLocal().toString().split(' ')[0]}";
        var day = date.substring(8, 10);
        var month = date.substring(5,7);
     //   2022-12-12
        var year = date.substring(0, 4);
        DateCont.text = "$day.$month.$year";

      });
    }
  }

  Future<void> setData() async {
    final prefs = await SharedPreferences.getInstance();
    var ch = change_pass_state();
    var pass = await ch.getPass();
    var email = await ch.getEmail();
    EmailCont.text = email!;
    setState(() {
      try {
        user_name = prefs.getString(USER_NAME_VALUE)!;
        age = prefs.getString(USER_AGE_VALUE)!;
        reg_date = prefs.getString(USER_REG_DATE_VALUE)!;
        foto_uri = prefs.getString(USER_FOTO_URI_VALUE)!;
        user_brth = prefs.getString(USER_AGE_VALUE)!;
        user_tele = prefs.getString(USER_TELE_VALUE)!;
        user_soname = prefs.getString(USER_SONAME_VALUE)!;
        user_gender = prefs.getString(USER_GENDER_VALUE)!;
        if(user_gender == "0"){
          maleBtnColor = Colors.blue;
          maleTxtColor = Colors.white;
          userGender = 0;
        }
        else if(user_gender == "1"){
          femaleBtnColor = Colors.pink;
          femaleTxtColor = Colors.white;
          userGender = 1;
        }
        userImage = AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(60, 0, 0, 0),
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0))
                    ],
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(foto_uri)))));
      }catch (e){

      }
    });

    Backendless.userService
        .login(email.toString(), pass.toString())
        .then((user) async {
      setState(() {
        user_name = user!.getProperty("name");
        nameCont.text = user_name;
        reg_date = user!
            .getProperty("created")
            .toString()
            .substring(0, 10)
            .replaceAll('-', '.');
        user_brth = user!.getProperty("DateBth").toString();
        DateCont.text = user_brth;
        user_soname = user!.getProperty("Soname").toString();
        sonameCont.text = user_soname;
        user_tele = user!.getProperty("telephone").toString();
        TeleCont.text = user_tele;
        foto_uri = user!.getProperty("photo_id");
        user_gender = user!.getProperty("gender").toString();
        print("gender is $userGender");
        if( user_gender == "0"){
          femaleBtnColor = Colors.blue;
          femaleTxtColor = Colors.white;
          userGender = 0;
        }
        else if(user_gender == "1"){
          femaleBtnColor = Colors.pink;
          femaleTxtColor = Colors.white;
          userGender = 1;
        }
        prefs.setString(USER_NAME_VALUE, user_name);
        prefs.setString(USER_AGE_VALUE, age);
        prefs.setString(USER_REG_DATE_VALUE, reg_date);
        prefs.setString(USER_FOTO_URI_VALUE, foto_uri);
        print("uri is $foto_uri");
        userImage = AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(60, 0, 0, 0),
                          blurRadius: 5.0,
                          offset: Offset(5.0, 5.0))
                    ],
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(foto_uri)))));
      });
    });
  }

  Future<void> loadPhoto() async {
    var ch = change_pass_state();
    var pass = await ch.getPass();
    var email = await ch.getEmail();
    print(email);
    Backendless.userService
        .login(email.toString(), pass.toString())
        .then((user) async {
      var newUser = user;
      print("im here");
      Backendless.files
          .removeDirectory("/web/UserPhoto/${email}")
          .then((value) {
        //Timer(Duration(seconds:1), (){
        Backendless.files
            .upload(_image, "/web/UserPhoto/${email}", overwrite: true)
            .then((value) {
          Backendless.files
              .upload(_image, "/web/UserPhoto/${email}", overwrite: true)
              .then((value) {
            print("Все ок1");
            print("value is $value");
            newUser?.setProperty("photo_id", value);
            Backendless.data.of("Users").save(newUser!.toJson()).then((value) {
              setData();
              //});
            }).onError((error, stackTrace) {
              print("Все по пизде1 $error");
            });
            ;
          }).onError((error, stackTrace) {
            Backendless.files
                .upload(_image, "/web/UserPhoto/${email}", overwrite: true)
                .then((value) {
              print("Все ок");
              print("value is $value");
              user?.setProperty("photo_id", value);
              Backendless.data.of("Users").save(user!.toJson()).then((value) {
                setData();
              });
            }).onError((error, stackTrace) {
              print("Все по пизде1 $error");
            });
            print("Все по пизде2 $error");
          });
        }).onError((error, stackTrace) {
          print("Все по пизде3 $error");
        });
        ;
      });
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(onWillPop: onBackPress,

        child:Container(
            child: CustomScrollView(slivers: [
      SliverAppBar(
        automaticallyImplyLeading: false,
        shadowColor: constants.stateBlue,
        backgroundColor: constants.stateBlue,
        foregroundColor: constants.stateBlue,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        floating: false,
        pinned: true,
        expandedHeight: 200,
        flexibleSpace: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
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
          child: FlexibleSpaceBar(
            centerTitle: true,
            expandedTitleScale: 1.0,
            title: Text("Настройки профиля"),
            background: Container(
              child: Stack(
                children: [
                  //,),),
                  //  SliverToBoxAdapter(
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                          color: constants.backGray,
                          //   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          shape: BoxShape.rectangle,
                          //    color: constants.stateBlue,
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
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40))),
                      child: Card(
                          color: constants.stateBlue,
                          elevation: 0,
                          margin: const EdgeInsets.only(
                              top: 0, bottom: 30, right: 0, left: 0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
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
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0, top: 40),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(
                                        children: <Widget>[
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: Container(
                                              width: 100,
                                              height: 150,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 150,
                                            child: userImage,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all(0)),
                                                onPressed: () {
                                                  onBackPress();
                                                },
                                                child: Icon(
                                                  Icons.arrow_back,
                                                )),
                                          )
                                        ],
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                  Align(
                    child: Container(
                      margin: EdgeInsets.only(top: 50, left: 120),
                      child: FloatingActionButton(
                        onPressed: () {
                          getGalleryImage();
                        },
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.deepPurple,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
              color: constants.backGray,
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
          child: Form(key:_settingProfilKey,child:Center(
        child: DecoratedBox(
          decoration: BoxDecoration(color: constants.backGray),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Информация  о аккаунте",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Имя",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: nameCont,
                  //initialValue: user_name,
                  validator: (txt) {
                    if (txt!.isEmpty) {
                      return "Поле должно быть заполненно";
                    }
                  },

                  //  controller: myOldPassController,
                  //obscureText: isOldPassVisible,
                  decoration: InputDecoration(
                    //  focusedBorder: const OutlineInputBorder(borderSide:
                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusColor: Colors.white,
                    hintText: 'Введите имя',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Фамилия",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: sonameCont,
                  validator: (txt) {
                    if (txt!.isEmpty) {
                      return "Поле должно быть заполненно";
                    }
                  },

                  //  controller: myOldPassController,
                  //obscureText: isOldPassVisible,
                  decoration: InputDecoration(
                    //  focusedBorder: const OutlineInputBorder(borderSide:
                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusColor: Colors.white,
                    hintText: 'Введите фамилию',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Дата рождения",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  readOnly: true,
                  controller: DateCont,

                  validator: (txt) {
                    if (txt!.isEmpty) {
                      return "Поле должно быть заполненно";
                    }
                  },

                  //  controller: myOldPassController,
                  //obscureText: isOldPassVisible,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _selectDate(context);
                          setState(() {
                            // bthHint =
                            // "${valueDate.toLocal().toString().split(' ')[0]}";
                          });
                        },
                        icon: const Icon(
                            Icons.calendar_today_outlined)),
                    //  focusedBorder: const OutlineInputBorder(borderSide:
                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusColor: Colors.white,
                    hintText: 'Введите дату',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(

                  enabled: false,
                  controller: EmailCont,
                  validator: (txt) {
                    if (txt!.isEmpty) {
                      return "Поле должно быть заполненно";
                    }
                  },

                  //  controller: myOldPassController,
                  //obscureText: isOldPassVisible,
                  decoration: InputDecoration(
                    //  focusedBorder: const OutlineInputBorder(borderSide:
                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusColor: Colors.white,
                    hintText: 'Введите email',
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Телефон",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: TeleCont,
                  validator: (txt) {
                    if (txt!.isEmpty) {
                      return "Поле должно быть заполненно";
                    }
                    if (txt.length != 11) {
                      return "Номер телефона должен состоять из 11 цифр";
                    }
                  },

                  //  controller: myOldPassController,
                  //obscureText: isOldPassVisible,
                  decoration: InputDecoration(
                    //  focusedBorder: const OutlineInputBorder(borderSide:
                    //  BorderSide(color: constants.stateBlue), borderRadius: BorderRadius.all(Radius.circular(20))),

                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    border: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusColor: Colors.white,
                    hintText: 'Введите телефон',
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Text(
                      "Пол:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if(maleBtnColor == Colors.white){
                            setState(() {
                              user_gender = "0";
                              maleBtnColor = Colors.blue;
                              maleTxtColor = Colors.white;
                              femaleBtnColor =Colors.white;
                              femaleTxtColor = Colors.black;
                            });
                          }else{
                            setState(() {
                              user_gender = "-1";
                              maleBtnColor = Colors.white;
                              maleTxtColor = Colors.black;
                              femaleBtnColor =Colors.white;
                              femaleTxtColor = Colors.black;
                            });

                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(maleBtnColor),
                            elevation: MaterialStateProperty.all(5)),
                        child: Text(
                          "М",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: maleTxtColor),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          {
                            if(femaleBtnColor == Colors.white){
                              setState(() {
                                user_gender = "1";
                                femaleBtnColor =Colors.pink;
                                femaleTxtColor = Colors.white;
                                maleBtnColor =Colors.white;
                                maleTxtColor = Colors.black;
                              });
                            }else{
                          setState(() {
                            user_gender = "-1";
                          maleBtnColor = Colors.white;
                          maleTxtColor = Colors.black;
                          femaleBtnColor =Colors.white;
                          femaleTxtColor = Colors.black;
                          });

                          }}
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(femaleBtnColor),
                            elevation: MaterialStateProperty.all(5)),
                        child: Text(
                          "Ж",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: femaleTxtColor),
                        ),
                      )),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, top: 60, bottom: 80),
                child: SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        onBackPress();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          elevation: MaterialStateProperty.all(5)),
                      child: Text("Назад",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: constants.stateBlue))),
                ))
          ]),
        ),
      )),
      )]))));
  }
}
