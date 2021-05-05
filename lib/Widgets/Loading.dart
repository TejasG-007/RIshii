import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    Size Screensize = MediaQuery.of(context).size;
    double width = Screensize.width;
    double height = Screensize.height;
    return Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/Gloading.json",height: height/10),
                Text("Please Wait...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/40,color: Colors.teal),)
              ],
            )
        );
  }
}

