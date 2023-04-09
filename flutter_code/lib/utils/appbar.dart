import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/utils/colors.dart';
import 'package:provider/provider.dart';

import '../provider/adProvider.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final adProvider = Provider.of<AdProvider>(context);


    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 10),
            child:Image.asset("assets/logo.png", width: size.width *0.5,),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(FontAwesomeIcons.trophy),
              SizedBox(width: 5,),
              AnimatedDigitWidget(
                value: adProvider.rewardScore,
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          )
        ],),
      automaticallyImplyLeading: false,
      backgroundColor: pale_colors.blue,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
