import 'package:flutter/material.dart';
import 'package:hello_world/utils/colors.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  const MainAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', width: size.width * 0.1),
          Row(
            children: [
              Text(
                'Dream ExplAIner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                'beta',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              )
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(size.height * 0.15, size.height * 0.07),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
            onPressed: () async {},
            child: Text(
              "Cuota used (0/5)",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
        ],
      ),
      toolbarHeight: size.height * 0.1,
      backgroundColor: magic_colors.dark_pink,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
