import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pockettouristguide/Service/Authentication.dart';
import 'package:pockettouristguide/Widgets/Loading.dart';
import 'package:pockettouristguide/Widgets/PageBuilderTransition.dart';
import 'package:provider/provider.dart';
import 'LoginModel.dart';
import 'LoginView.dart';
import 'RegisterView.dart';


class ForgotView extends StatefulWidget {
  @override
  _ForgotViewState createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();


  _getBottomRoutes(double Right){
    double right=Right;
    return Column(
      children: [
        SizedBox(height:20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child:GestureDetector(
                  onTap: (){
                    Navigator.push(context,SlideRightRoute(widget:RegisterView()));
                  },
                  child:Padding(
                    padding: EdgeInsets.only(left: 20,right:right),
                    child: Text("Create New Account   ",style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 18,color: Colors.purple,fontWeight: FontWeight.bold),),
                  )
              ),
            )
          ],),
        SizedBox(
            height:20
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: (){
                  Navigator.push(context,SlideRightRoute(widget:LoginView()));
                },
                child:Padding(
                  padding: EdgeInsets.only(left: 20,right:right),
                  child: Text("Login with Credentials ?",style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 18,color: Colors.purple,fontWeight: FontWeight.bold),),
                )
            ),
          ),
          ],),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Provider.of<Authentication>(context).getbusy?LoadingView():LayoutBuilder(
          builder: (builder, size) {
            //Responsive Sizes for Devices
            double small = 700;
            double medium = 700;
            double large = 1399;
            return SingleChildScrollView(
              scrollDirection:Axis.vertical,
              child: Container(
                  height: size.maxHeight,
                  width: size.maxWidth,
                  child: Scrollbar(
                    child:ListView(
                      shrinkWrap: true,
                      children: [
                        ClipPath(
                          clipper: DiagonalPathClipperOne(),
                          child: Container(
                            alignment:Alignment.center,
                            height: size.maxWidth<small?100:100,
                            width: size.maxWidth,
                            color: Colors.teal,
                          ),

                        ),
                        size.maxWidth<small?Container(): Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[

                              Image.asset("assets/Images/logo.jpeg",height: 80,)
                            ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            size.maxWidth >= small
                                ? Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Lottie.asset("assets/registerui.json",height: size.maxWidth>medium?600:200),
                              ),
                            )
                                : Container(),
                            Expanded(
                                flex: 1,
                                child: Container(

                                    child: Column(
                                      children: [
                                        size.maxWidth<small?Padding(
                                          padding:EdgeInsets.only(top:10),
                                          child:Lottie.asset("assets/registerui.json",height:250,width:250),
                                        ):Container(),
                                        size.maxWidth>small? SizedBox(height: 100,):SizedBox(height: 20,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Text("Password Recovery",style:Theme.of(context).textTheme.headline1),FaIcon(FontAwesomeIcons.userLock,color: Colors.purple,)],),

                                        SizedBox(
                                          height: 30,
                                        ),
                                        Consumer<Handler>(
                                          builder: (context,handler,child)=>Form(
                                              key: _formkey,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding: size.maxWidth <= small
                                                          ? EdgeInsets.only(left: 60, right: 60)
                                                          : size.maxWidth >= medium &&
                                                          size.maxWidth <= large
                                                          ? EdgeInsets.only(left: 80, right: 80)
                                                          : EdgeInsets.only(left: 200, right: 200),
                                                      child: TextFormField(
                                                        validator: (inp){

                                                          if(!inp.contains("@")){
                                                            return "Please Enter Valid Email";
                                                          }else if(inp.isEmpty){
                                                            return "Email Should not be Empty";
                                                          }
                                                          return null;
                                                        },
                                                        cursorColor: Colors.purple,
                                                        autovalidateMode:AutovalidateMode.onUserInteraction ,
                                                        cursorHeight: 25,
                                                        decoration: InputDecoration(
                                                            prefixIcon: Icon(Icons.alternate_email),
                                                            labelText: "Enter Email",
                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide:
                                                                BorderSide(color: Colors.purple)),
                                                            disabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                BorderSide(color: Colors.purple)),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors.black, width: 2),
                                                                borderRadius:
                                                                BorderRadius.circular(10))),
                                                      )),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  SizedBox(height: 20,),
                                                  ElevatedButton(
                                                      onPressed: ()async{
                                                        if(_formkey.currentState.validate()){
                                                          print("going GOoD ");
                                                         bool result = await Authentication().ForgotPassword(email.text);
                                                         if(result){
                                                           return showDialog(context: context, builder:(context)=>AlertDialog(
                                                             title: Column(children: [Text("Reset Link Sent",style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 20,color: Colors.teal),),Text("Please Check Your Email and Change Password",style: TextStyle(fontSize: 18),)],),actions: [
                                                             ElevatedButton(onPressed: (){
                                                               Navigator.pop(context);
                                                             }, child:Text("OK"))
                                                           ],));
                                                         }else{
                                                           return showDialog(context: context, builder:(context)=>AlertDialog(
                                                             title: Column(children: [Text("Error",style: Theme.of(context).textTheme.headline2,),Text("${result}")],),actions: [
                                                             ElevatedButton(onPressed: (){
                                                               Navigator.pop(context);
                                                             }, child:Text("OK"))
                                                           ],));
                                                         }
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:EdgeInsets.only(left:10,right:10,top:5,bottom:5),
                                                        child: Text("Continue"),
                                                      ),style: ElevatedButton.styleFrom(

                                                  )
                                                  ),
                                                  size.maxWidth>small? _getBottomRoutes(80):Container()
                                                ],
                                              )),
                                        )
                                      ],
                                    )))

                          ],
                        ),
                        size.maxWidth<small?_getBottomRoutes(15):Container()
                      ],
                    ),
                  )
              ),
            );
          },
        ));
  }
}