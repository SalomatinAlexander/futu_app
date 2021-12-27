

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/constant/constants.dart';

class registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => registrationState();
}

class registrationState extends State<registration> {
  DateTime valueDate = DateTime.now();
  var name = "";
  var soname = "";
  var bth = "";
  var email = "";
  var pass = "";
  var repeat_pass = "";
  var email_validator = false;
  var pass_validator = false;

  var bthHint = "Дата рождения";
  var isPassIconPress = constants.invisibleGray;
  var isRepPassIconPress = constants.invisibleGray;
  var obscurePass = true;
  var obscureRepPass = true;
  final _formKey = GlobalKey<FormState>();

  _changeName(String text) {
    setState(() => name = text);
  }

  _changeSoname(String text) {
    setState(() => soname = text);
  }

  _changeEmail(String text) {
    setState(() => email = text);
  }

  _changePass(String text) {
    setState(() => pass = text);
  }

  _changeRepPass(String text) {
    setState(() => repeat_pass = text);
  }

  _changeBth(String text) {
    setState(() => bth = text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            color: constants.stateBlue,
            child: Form(
              child: Column(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 90, bottom: 20),
                    child: const Text(
                      "Регистрация",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )),
                Expanded(
                    child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: 760,
                    child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 0, right: 0, top: 30, bottom: 0),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(70))),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 70, left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: TextField(
                                  onChanged: _changeName,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Имя',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: TextField(
                                  onChanged: _changeSoname,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Фамилия',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: TextField(
                                  onChanged: _changeBth,

                                  // tex
                                  readOnly: true,
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
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: '$bthHint',
                                  ),
                                ),
                              ),
                              //   ElevatedButton(onPressed: (){_selectDate(context);}, child: Text("Дата рождения")),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
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
                                      email_validator = true;
                                      email = value;
                                      return null;
                                    } else {
                                      return "Email введен некоррекно";
                                    }
                                  },
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Email',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: TextField(
                                  onChanged: _changePass,
                                  onSubmitted: (text) {
                                    pass = text;
                                  },
                                  maxLines: 1,
                                  obscureText: obscurePass,
                                  obscuringCharacter: "*",
                                  decoration: InputDecoration(
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
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Пароль',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: TextField(
                                  onChanged: _changeRepPass,
                                  onSubmitted: (text) {
                                    setState(() {
                                      repeat_pass = text;
                                    });
                                    //= text;
                                  },
                                  obscureText: obscureRepPass,
                                  maxLines: 1,
                                  obscuringCharacter: "*",
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.vpn_key,
                                            color: isRepPassIconPress),
                                        onPressed: () {
                                          setState(() {
                                            if (isRepPassIconPress ==
                                                constants.invisibleGray) {
                                              obscureRepPass = false;
                                              isRepPassIconPress =
                                                  constants.stateBlue;
                                            } else {
                                              obscureRepPass = true;
                                              isRepPassIconPress =
                                                  constants.invisibleGray;
                                            }
                                          });
                                        }),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hoverColor: Colors.white,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    hintText: 'Повторите пароль',
                                  ),
                                ),
                              ),
                              Container(
                                  child: SizedBox(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          if (name.isEmpty ||
                                              soname.isEmpty ||
                                              bthHint.isEmpty ||
                                              bthHint == "Дата рождения" ||
                                              email.isEmpty ||
                                              pass.isEmpty ||
                                              repeat_pass.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Все поля должны быть заполнены ")));
                                            return;
                                          }
                                          if (pass.length<8 || repeat_pass.length<8) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Пароль должен быть больше восьми символов")));
                                            return;
                                          }
                                          if (pass == repeat_pass) {
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Пароли не совпадают")));
                                            return;
                                          }

                                          if (_formKey.currentState!
                                              .validate()) {
                                            var mapa = {
                                              "name": name,
                                              "Soname": soname,
                                              "DateBth": bth,
                                              "password": pass,
                                              "email": email
                                            };
                                            // do not forget to call Backendless.initApp when your app initializes
                                            BackendlessUser user =
                                                BackendlessUser();
                                            user.email = email;
                                            user.password = pass;
                                            user.setProperties(mapa);

                                            var response = await Backendless
                                                .userService
                                                .register(user)
                                                .then((registeredUser) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Регистрация прошла успешно, на вашу почту было отправлено письмо для подтверждения email")));
                                              // user has been registered and now can login
                                              Navigator.pop(context);
                                            }).catchError((onError) {
                                              print(onError);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Ошибка, проверьте корректность введеных данных")));
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(constants.lavender),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ))),
                                        child: const Text("Зарегистрироваться",
                                            style: TextStyle(fontSize: 20, color: constants.stateBlue))),
                                    width: double.infinity,
                                    height: 50,
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 50, top: 40, right: 50, bottom: 0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(70)))),
                              Container(
                                  child: SizedBox(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ))),
                                        child: const Text("Назад",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: constants.invisibleGray))),
                                    width: double.infinity,
                                    height: 50,
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 50, top: 20, right: 50, bottom: 0),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(70)))),
                            ],
                          ),
                        )),
                  ),
                ))
              ]),
              key: _formKey,
            )),
      ),
    );

    //throw UnimplementedError();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: valueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != valueDate) {
      setState(() {
        valueDate = picked;
        bthHint = "${valueDate.toLocal().toString().split(' ')[0]}";
      });
    }
  }
}
