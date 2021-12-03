import 'package:flutter/material.dart';

class authorization extends StatefulWidget {
  const authorization({Key? key}) : super(key: key);

  // const Authorization({Key? key}) : super(key: key);
  @override
  State<authorization> createState() => authorizationState();


}
class authorizationState extends State<authorization>{

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
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
                    margin: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(70),
                            bottomLeft: Radius.circular(70))),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(70),
                            bottomLeft: Radius.circular(70)),

                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF3366FF),
                            Color(0xFF00CCFF),
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: double.infinity,
                      height: 600,
                      child: Column(
                        children: <Widget>[

                        ],
                      ),

                    ),),
                  Text(
                    'text',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ));
    }

  }


