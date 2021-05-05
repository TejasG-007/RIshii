import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pockettouristguide/Scanner/Scanner.dart';
import 'package:pockettouristguide/Service/Authentication.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import '../WebView.dart';
import '../Widgets/Loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        key: _scaffold,
        appBar: AppBar(elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app_rounded),
                onPressed: () async {
                  var result = await Authentication().signout();
                  if (result is bool) {
                    if (!result) {
                      return showDialog(
                          context: _scaffold.currentContext,
                          builder: (context) => AlertDialog(
                                title: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "There is an ERROR",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color: Colors.teal, fontSize: 20),
                                    ),
                                    Text(
                                      "${result}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: Colors.teal, fontSize: 15),
                                    )
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ));
                    }
                  }
                })
          ],
          title: Text("Pocket Tourist Guide"),
          centerTitle: true,
          leading: Icon(Typicons.location_outline),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Application Description will be here",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(color: Colors.black, fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Scanner()));
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFFFa780d1),
                  radius: 80,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.qrcode,
                          size: 60,
                          color: Colors.white,
                        ),
                        Text("Scan QR Here",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: Colors.white, fontSize: 18))
                      ]),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 70),
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:Border.all(
                   color:Colors.teal
                  ),
                  color: Colors.white
                ),
                child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text("Recent Searches",style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))],),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc("${FirebaseAuth.instance.currentUser.email}")
                      .snapshots(),
                  builder: (context, snapshot) => snapshot.hasData
                      ? snapshot.data["Recent Searches"].length == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("No History Found",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => GestureDetector(
                               onTap: (){
                                 Navigator.push(context,MaterialPageRoute(builder: (context)=>DisplayInfo(Url:"${snapshot.data["Recent Searches"][index]}")));
                               },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[ Icon(Typicons.location_outline),Text(
                                      "${snapshot.data["Recent Searches"][index]}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                          color: Colors.black, fontSize: 18)),]
                                  ),
                                ),
                              ),
                              itemCount:
                                  snapshot.data["Recent Searches"].length,
                            )
                      : LoadingView())
            ],
          ),
        ));
  }
}
