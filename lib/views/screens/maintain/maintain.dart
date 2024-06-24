import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaintainScreen extends StatelessWidget {
  const MaintainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0.0,
      //   centerTitle: true,
      //   title: const Text("MAINTENANCE",
      //     style: TextStyle(
      //       fontSize: 18.0,
      //       color: Colors.black
      //     ),
      //   ),
      //   leading: CupertinoNavigationBarBackButton(
      //     color: Colors.black,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/background/bg.png')
              )
            ),
            child: Center(child: Image.asset('assets/images/maintenance.png')),
          ),

          Positioned(
            top: 50.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 80.0,
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  Expanded(
                    flex: 1,
                    child: CupertinoNavigationBarBackButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Expanded(
                    child: Container(),
                  ),

                  const Expanded(
                    flex: 3,
                    child: Text("MAINTENANCE",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),

        ],
      ) 
    );
  }
}