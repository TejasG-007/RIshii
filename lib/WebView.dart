import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pockettouristguide/Widgets/Loading.dart';

import 'Widgets/Loading.dart';

class DisplayInfo extends StatefulWidget {
  final Url;
  DisplayInfo({this.Url});
  @override
  DisplayInfoState createState() => DisplayInfoState();
}

class DisplayInfoState extends State<DisplayInfo> {
  GlobalKey _scaffold = GlobalKey();
  TextEditingController feedback = TextEditingController();
  TextEditingController username = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Places")
                .doc("${widget.Url}")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingView();
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Image.network(
                            "${snapshot.data["Place_ImgURL"]}",
                            fit: BoxFit.fitWidth,
                            loadingBuilder: (context, child,
                                    ImageChunkEvent loadingProgress) =>
                                loadingProgress != null ? LoadingView() : child,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Text(
                                    "${snapshot.data["Place_Title"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                     return showModalBottomSheet(context: _scaffold.currentContext, builder:(context)=>
                                     Column(children: [
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text("Feedback's",),
                                         ],
                                       ),
                                       StreamBuilder(
                                           stream: FirebaseFirestore.instance.collection("Feedback's").snapshots(),
                                           builder: (context,snapshot){
                                             return snapshot.hasData?ListView.builder(shrinkWrap: true,
                                               itemCount: snapshot.data.docs.length,itemBuilder: (context,index){

                                                 String username = snapshot.data.docs[index]["username"].toString().toUpperCase().substring(0,1)==null?"username not set":snapshot.data.docs[index]["username"].toString().toUpperCase().substring(0,1);
                                                 String feedback = snapshot.data.docs[index]["${widget.Url}"]!=null?snapshot.data.docs[index]["${widget.Url}"]:"No feedback Found";

                                               return ListTile(
                                                 dense:true,leading:CircleAvatar(radius:20,child:
                                               Text("${username}"),),
                                                 title: Text("${feedback}"));



                                               },


                                             ):LoadingView();
                                           }
                                       )],)

                                     );
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        "assets/feedback.png",
                                        scale: 10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: _scaffold.currentContext,
                                          builder: (context) {
                                            return AlertDialog(
                                                scrollable: true,

                                                ///User written feedback =>${snapshot.data.docs[0]["feedback_text"]}
                                                title: Column(
                                                  children: [
                                                    Text("Write Feedback's"),
                                                    SizedBox(height: 10,),
                                                    TextField(
                                                        controller:username,
                                                        decoration: InputDecoration(
                                                            labelText: "Username",
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius:BorderRadius.circular(10),
                                                            )
                                                        )
                                                    ),

                                                SizedBox(height: 20,)
                                                ,TextField(
                                                        controller:feedback,
                                                        decoration: InputDecoration(
                                                          labelText: "Write Feeback",
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius:BorderRadius.circular(10),
                                                            )
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: FloatingActionButton(onPressed: ()async{
                                                       await FirebaseFirestore.instance.collection("Feedback's").doc("${FirebaseAuth.instance.currentUser.email}").update({"username":username.text,"${widget.Url}":feedback.text});
                                                        Navigator.pop(context);
                                                      },child: Icon(Icons.done),),
                                                    )
                                                  ],
                                                ));
                                          });
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        "assets/writing.png",
                                        scale: 10,
                                      ),
                                    ),
                                  )
                                ])),
                          ),
                        ),
                        Flexible(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${snapshot.data["Place_Description"]}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(fontSize: 16)),
                            ))
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
