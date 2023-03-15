import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/utils/colors.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: magic_colors.dark_pink,
//      appBar: AppBar(title: Text("Page 1")),
      body: Center(
        child: MaterialButton(
          child: const Text("Next"),
          onPressed: () {
            Navigator.push(context, ConcentricPageRoute(builder: (ctx) {
              return const Page2();
            }));
          },
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
//      appBar: AppBar(title: Text("Page 2")),
      body: Center(
        child: MaterialButton(
          child: const Text("Back"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
