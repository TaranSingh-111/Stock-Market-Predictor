import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';
import 'package:stock_market_predictor/screens/login_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUpScreen extends StatelessWidget{
  SignUpScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          // height: 1000,
          child:Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: DiagonalClipper(),
                child: Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xDF0072FF),
                        Color(0xD800C6FF),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -120,
                right: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),
                ),
              ),


              //title

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 225),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create account",
                        style:TextStyle(color: HexColor('7DFDFE'), fontSize: 40, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
              ),

              //switch screen

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 300),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap:(){
                        Get.toNamed('/login');
                      },
                      child: Text(
                        "  sign in",
                        style: TextStyle(color:HexColor('7DFDFE'),fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),

              //first field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 345),
                child: TextField(
                  controller: nameController,
                  cursorColor: HexColor('7DFDFE'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: HexColor('181818'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                ) ,
              ),

              //second field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 425),
                child: TextField(
                  controller: emailController,
                  cursorColor: HexColor('7DFDFE'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: HexColor('181818'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                ) ,
              ),

              //third field

              Padding(padding: const EdgeInsets.only(left: 40, top: 505, right:40),
                child: TextField(
                  controller: passwordController,
                  cursorColor: HexColor('7DFDFE'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: HexColor('181818'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                ) ,
              ),

              //button

              Padding(
                padding: const EdgeInsets.only(top: 600, left:250) ,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: HexColor('7DFDFE'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: (){
                      controller.createAccount(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim());
                    },
                    label: const Text("Sign up",
                        style: TextStyle(color:Colors.black, fontSize: 20)),
                    icon: const Icon(Icons.login, color: Colors.black54, size: 25,)
                ),
              ),

              //backbutton

              Padding(
                padding: const EdgeInsets.only(top: 40, left:0) ,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_)=> LoginScreen()),
                    );
                  } ,
                  icon: Icon(Icons.chevron_left,color:Colors.black, size:75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}