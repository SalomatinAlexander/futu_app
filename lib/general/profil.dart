

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/constant/constants.dart';
import 'package:untitled3/profil/public_profil.dart';
import 'package:untitled3/profil/setting_profil.dart';

import '../authoriztion/authorization.dart';
import '../profil/change_pass.dart';
import '../profil/connect_profil.dart';



class profil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => profil_state();
}

class profil_state extends State<profil> {
  String user_name = "";
  String reg_date = "";
  String age = "";
  String foto_uri = "null";
  Widget userImage = const Icon(Icons.person, size: 50,);
  static const String USER_NAME_VALUE = "username";
  static const String USER_AGE_VALUE = "userage";
  static const String USER_REG_DATE_VALUE = "userregdate";
  static const String USER_FOTO_URI_VALUE = "userUri";
  static const String USER_TELE_VALUE = "userTele";
  static const String USER_GENDER_VALUE = "userGender";
  static const String USER_SONAME_VALUE = "usersoname";

  Future<void> logOut() async {
    var ch = change_pass_state();
    var pass  = await ch.getPass();
    var email = await ch.getEmail();
    Backendless.userService
        .login(email.toString(),
        pass.toString())
        .then((user) async {});
    Backendless.userService.logout()
        .then((response) {
      var auto = authorizationState();
      auto.setPref(0);
      //   Navigator.pop(context, authorization());
      Navigator.push(context, SlideRightRoute(page: authorization()));


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выход...')),

      );
    });



  }

  Future<void> getGalleryImage() async{
    var  picker =ImagePicker();
    var image  = await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      var  _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getGalleryImage();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        }
    );
  }


  Future<void> getUserData() async{
    final prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
      user_name = prefs.getString(USER_NAME_VALUE)!;
      age = prefs.getString(USER_AGE_VALUE)!;
      reg_date = prefs.getString(USER_REG_DATE_VALUE)!;
      foto_uri = prefs.getString(USER_FOTO_URI_VALUE)!;

      userImage = AspectRatio(
      aspectRatio: 1/1,
        child: Container(
        margin: EdgeInsets.all(
        0.0
        ),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        boxShadow:[
        BoxShadow(
        color: Color.fromARGB(60, 0, 0, 0),
        blurRadius: 5.0,
        offset: Offset(5.0, 5.0)
        )
        ],
        image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(foto_uri)
        )
        )));

      });
    }catch (e){

    }


    var ch = change_pass_state();
    var pass  = await ch.getPass();
    var email = await ch.getEmail();
    Backendless.userService
        .login(email.toString(),
        pass.toString())
        .then((user) async {
          setState(() {
          user_name = user!.getProperty("name");
          reg_date = user!.getProperty("created").toString().substring(0,10).replaceAll('-', '.');
          age = isAdult(user!.getProperty("DateBth").toString());
          foto_uri = user!.getProperty("photo_id");
          print("Age is $age");
          if(foto_uri != null) {
            userImage = AspectRatio(
                  aspectRatio: 1/1,
                  child: Container(
                      margin: EdgeInsets.all(
                          0.0
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          boxShadow:[
                            BoxShadow(
                                color: Color.fromARGB(60, 0, 0, 0),
                                blurRadius: 5.0,
                                offset: Offset(5.0, 5.0)
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(foto_uri)
                          )
                      )));
          }

                  prefs.setString(USER_NAME_VALUE, user_name);
          prefs.setString(USER_AGE_VALUE, age);
          prefs.setString(USER_REG_DATE_VALUE, reg_date);
          prefs.setString(USER_FOTO_URI_VALUE, foto_uri);

          });
          print("user name $user_name, reg $reg_date, age $age ");
    });


  }
  String isAdult(String enteredAge) {
    var birthDate = DateFormat('dd.MM.yyyy').parse(enteredAge);
    print("set state: $birthDate");
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    print(difference);
    final year = difference / 365;
    print(year);
    return year.toInt().toString();
  }
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CustomScrollView(slivers: [
      SliverAppBar(
        shadowColor: constants.stateBlue,
        backgroundColor: constants.stateBlue,
        foregroundColor: constants.stateBlue,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        floating: false,
        pinned: true,
        expandedHeight: 350,
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
            expandedTitleScale: 1.3,
            title: Text("Профиль"),
            background: Container(child: Stack(
              children: [
                //,),),
                //  SliverToBoxAdapter(
                SizedBox(
                  height: 400,
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
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 30,
                                  ),
                                  child: SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                         logOut();
                                        },
                                        child: const Text(
                                          "Выйти",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topLeft:
                                                              Radius.circular(
                                                                  0))),
                                            )),
                                      )),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 40, top: 40),
                                child: Row(
                                  children: <Widget>[
                                    Stack(
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
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 200,
                                      height: 150,
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: 20, top: 25),
                                        child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "$user_name",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Возраст: $age ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ))),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Дата регистрации",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "$reg_date",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(top: 30, right: 30, bottom: 10),
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(context,
                            SlideRightRoute(page: setting_profil(key: GlobalKey<FormState>(),)));
                      },
                      isExtended: false,
                      elevation: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.create_rounded,
                        color: Colors.deepPurple,
                        size: 25,
                      ),
                    ))
              ],
            ),color: constants.backGray,),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Center(
          child: DecoratedBox(
              decoration: BoxDecoration(color: constants.backGray),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Информация  о аккаунте",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.insert_comment_rounded,
                                      color: Colors.deepOrange,
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)))),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                ),
                                Container(
                                  child: Text("Отзывы"),
                                  margin: EdgeInsets.only(top: 15),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.compare_arrows_rounded,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                ),
                                Container(
                                  child: Text("Поездки"),
                                  margin: EdgeInsets.only(top: 15),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: () {
                                     // final dep = MyChangingDependency();
                                      Navigator.push(context, SlideRightRoute(page: connect_profil(key: GlobalKey<FormState>(),)));
                                    },
                                    child: Icon(
                                      Icons.mobile_screen_share_sharp,
                                      color: Colors.orange,
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                ),
                                Container(
                                  child: Text("Связь"),
                                  margin: EdgeInsets.only(top: 15),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 70,
                                  height: 70,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.directions_car,
                                      color: Colors.yellow,
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white)),
                                  ),
                                ),
                                Container(
                                  child: Text("Авто"),
                                  margin: EdgeInsets.only(top: 15),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 30, bottom: 30),
                    child: SizedBox(
                      child: DecoratedBox(
                        decoration: BoxDecoration(),
                        child: Card(
                          // color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),

                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightBlue,
                                  constants.coldBlue,
                                ],
                                begin: FractionalOffset(1.0, 1.0),
                                end: FractionalOffset(0.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Рейтинг",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      margin:
                                          EdgeInsets.only(top: 20, left: 20),
                                    ),
                                    Container(
                                        margin:
                                            EdgeInsets.only(top: 10, left: 20),
                                        child: Text(
                                          "20/100",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 200,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: const Align(
                                    child: Icon(
                                      Icons.assistant,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    alignment: Alignment.topRight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      width: double.infinity,
                      height: 120,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 0),
                      child: SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    SlideRightRoute(page: public_profil()));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "Просмотреть публичный профиль",
                                style: TextStyle(color: Colors.black),
                              )))),
                  Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    SlideRightRoute(page: change_pass()));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              child: const Text(
                                "Сменить пароль",
                                style: TextStyle(color: Colors.black),
                              )))),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "О нас",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Условия использования",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Вопросы",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 17),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Помощь",
                        style: TextStyle(color: Colors.lightBlue, fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 100,
                  )
                ],
              )),
        ),
      ),
    ]
                // child:],
                )));
  }
}

class Sample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 200),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => ListTile(
                  title: Text("Index: $index"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Image.network(
          "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
          fit: BoxFit.cover,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: expandedHeight,
                width: MediaQuery.of(context).size.width / 2,
                child: FlutterLogo(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
