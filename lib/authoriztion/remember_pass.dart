

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/constant/constants.dart';

class remember_pass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => remember_state();
}

class remember_state extends State<remember_pass> {
  final _formKey = GlobalKey<FormState>();
  var email = "";

  _changeEmail(String text) {
    setState(() => email = text);
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
              // in the middle of the parent.
              child: Form(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(70),
                                bottomLeft: Radius.circular(70))),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 200, bottom: 20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(70),
                                bottomLeft: Radius.circular(70)),
                            gradient: LinearGradient(
                              colors: [
                                constants.stateBlueLite,
                                constants.stateBlue
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
                              Text(
                                "Futu",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 18, top: 130, right: 18, bottom: 0),
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
                                      return null;
                                    } else {
                                      return "Email введен некоррекно";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Введите email',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: const Text(
                                  "Введите email на который придет письмо с подтверждением",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          child: SizedBox(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Backendless.userService
                                        .restorePassword(email)
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Письмо отправленно на вашу почту")));
                                      Navigator.pop(context);
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Ошибка, проверьте корректность введеных данных")));
                                    });
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      constants.lavender),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                                child: const Text("Отправить",
                                    style: TextStyle(fontSize: 20, color: constants.stateBlue))),
                            width: double.infinity,
                            height: 50,
                          ),
                          margin: const EdgeInsets.only(
                              left: 50, top: 20, right: 50, bottom: 0),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70)))),
                      Container(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white)),
                            child: const Text('Назад',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black))),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                      ),
                    ]),
                key: _formKey,
              ),
            )));

    // throw UnimplementedError();
  }
}
