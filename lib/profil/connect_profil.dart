import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/constant/constants.dart';

import 'change_pass.dart';

class connect_profil extends StatefulWidget {
  const connect_profil({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => connect_state();
}

class connect_state extends State<connect_profil> {
  String telephoneVis = "no";
  var colorEmail= constants.invisibleGray;
  var colorPhone = constants.invisibleGray;
  String emailVis = "no";
  var tele = "";
  String UserEmail = "no";
  String teleHint = "";
  String emialTxt = "Показать1";
  String phoneTxt = "Показать1";
  bool isTeleVisible = false;
  bool isEmailVisible = false;
  var telephoneController = TextEditingController();
  var emailController = TextEditingController();
  var teleEnable = true;
  var backBtnEnable = true;
  var PhoneBtnEnable = true;
  var EmailBtnEnable = true;
  final _connectKey = GlobalKey<FormState>();

  Future<void> showData() async {
    var ch = change_pass_state();
    var pass = await ch.getPass();
    var email = await ch.getEmail();
    emailController.text = email!;
    var query = DataQueryBuilder();
    query.whereClause = "email = $email";
    Backendless.userService
        .login(email.toString(), pass.toString())
        .then((user) async {});
    Backendless.userService.getCurrentUser().then((response) {
      var data = response;

      try {
        if(data?.getProperty("teleVisible") != null) {
          telephoneVis = data!.getProperty("teleVisible").toString();
        }
      }
      catch (e){
        print("exeption $e");
        telephoneVis = "no";
      }
      try {
        emailVis = data!.getProperty("emailIsVisible").toString();
      }
      catch (e){
        emailVis = "no";

      }


        print("tele $telephoneVis, em $emailVis");

        if (telephoneVis == "no" || telephoneVis == "null" ) {
          setState(() {
            phoneTxt = "Показать";
            colorPhone = constants.invisibleGray;
            isTeleVisible = false;
          });
        }
        if (telephoneVis == "yes") {
          print("TELE $telephoneVis");
          setState(() {
            colorPhone = Colors.black;
            phoneTxt = "Скрыть";
            isTeleVisible = true;

          });
        }
        if (emailVis == "no" || emailVis == "null") {
          setState(() {
            colorEmail = constants.invisibleGray;
            emialTxt = "Показать";
            isEmailVisible = false;
          });
        }
        if (emailVis == "yes") {
          setState(() {
            colorEmail = Colors.black;
            emialTxt = "Скрыть";
            isEmailVisible = true;
          });
        }

        if (data!.getProperty("telephone").toString() != "null") {
          tele = data!.getProperty("telephone").toString();
          //telephoneVis = "Не указан2";
          telephoneController.text = tele;
        } else {
          setState(() {
            teleHint = "Не указан";
          });
        }

        //   emailVis = data.getProperty("emailIsVisible").toString();
        // tele = data.getProperty("telephone").toString();

        print("tele $tele , visible $telephoneVis");
        return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выход...')),
        );
      });
    }



  Future<void> saveData() async {

    var ch = change_pass_state();
    var pass = await ch.getPass();
    var email = await ch.getEmail();
    emailController.text = email!;
    var query = DataQueryBuilder();
    query.whereClause = "email = $email";
    var mUser = BackendlessUser();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Сохранение...")));
    Backendless.userService
        .login(email.toString(), pass.toString())
        .then((user) async {
      mUser = user!;
      user.setProperty("teleVisible", "$telephoneVis");
      user.setProperty("emailIsVisible", "$emailVis");
      user.setProperty("telephone", "${telephoneController.text}");
      Backendless.userService.update(user).then((value){
        print(value);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Данные сохранены")));

      }).onError((error, stackTrace){
        print(error);
      });

    });




  }

  void goOutEnable(bool isEnable){
    setState(() {
      teleEnable = isEnable;
      backBtnEnable = isEnable;
      EmailBtnEnable = isEnable;
      PhoneBtnEnable = isEnable;
    });
  }
  @override
  Future<bool> onBackPress() async {
    if(_connectKey.currentState!.validate()) {
      goOutEnable(false);
      saveData();
    }

    return false;
  }
  @override
  void initState() {
    showData();
    super.initState();
  }
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
  //  showData();
    return (WillPopScope(
        onWillPop: onBackPress,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: constants.backGray,
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0.0, top: 20.0, bottom: 0.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Способы связи',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: constants.backGray,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                      spreadRadius: 1.0,
                    )
                  ]),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 56.0),
          ),
          body: Container(
            color: constants.backGray,
            width: double.infinity,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
            child:Form(child:  Column(children: <Widget>[
              SizedBox(
                child: Card(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: DecoratedBox(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Выберете контактную информацию которая будет видна другим пользователям",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Icon(
                            Icons.supervisor_account_sharp,
                            size: 40,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  ),
                ),
                width: double.infinity,
                height: 120,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 30),
                    child: Text(
                      "Email:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(color: colorEmail),
                  controller: emailController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: 'Введите email',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(!EmailBtnEnable){ return ;}
                      if(isEmailVisible){
                        setState(() {
                          emialTxt = "Показать";
                        isEmailVisible = false;
                        colorEmail = constants.invisibleGray;
                          emailVis = "no";
                        });
                      }else{
                        setState(() {
                          emialTxt = "Скрыть";
                        isEmailVisible = true;
                        colorEmail = Colors.black;
                        emailVis = "yes";
                        });
                      }
                    },
                    child: Text(
                      "$emialTxt",
                      style: TextStyle(color: constants.stateBlue),
                    ),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(constants.backGray)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 30),
                    child: Text(
                      "Телефон:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  enabled: teleEnable,
                  validator: (text){
                    if(text!.length!=11){
                      return "Телефон должен состоять из 11 символов";
                    }
                  },
                  style: TextStyle(color: colorPhone),
                  controller: telephoneController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hoverColor: Colors.white,
                    focusColor: Colors.white,
                   enabledBorder:  const OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white, width: 0.0),
                       borderRadius: BorderRadius.all(Radius.circular(20))),
                   border:  const OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.white, width: 0.0),
                       borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: teleHint,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(!PhoneBtnEnable){ return ;}
                      if(isTeleVisible){
                        setState(() {
                          phoneTxt = "Показать";
                          isTeleVisible = false;
                          colorPhone = constants.invisibleGray;
                          telephoneVis = "no";
                        });
                      }else{
                        setState(() {
                          phoneTxt = "Скрыть";
                          isTeleVisible = true;
                          colorPhone = Colors.black;
                          telephoneVis = "yes";
                        });
                      }
                    },
                    child: Text(
                      "$phoneTxt",
                      style: TextStyle(color: constants.stateBlue),
                    ),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(constants.backGray)),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 90, left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(

                      onPressed: () {
                        onBackPress();
                      },
                      child: Text(
                        "Назад",
                        style: TextStyle(
                            color: constants.stateBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          elevation: MaterialStateProperty.all(5),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    ),
                  )),
            ]),
          key: _connectKey,),
        ))));
  }
}
