import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';
import 'package:hexcolor/hexcolor.dart';


class LoginScreen extends StatelessWidget{
  LoginScreen({super .key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          // height: 1500,
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


              //Title
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 300),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Login",
                        style:TextStyle(color: HexColor('7DFDFE'),fontSize: 40, fontWeight: FontWeight.bold, ),
                      )
                    ],
                  )
              ),

              //switch screen

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 365),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap:(){
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        "  sign up",
                        style: TextStyle(color: HexColor('7DFDFE'),fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),

              //first field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 420),
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

              //second field

              Padding(padding: const EdgeInsets.only(left: 40, top: 500, right:40),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(15)),
                      prefixIcon:Icon( Icons.lock, color: HexColor('7DFDFE'),) ,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: HexColor('181818'),

                      suffix: GestureDetector(
                        onTap: () {
                          //empty for now
                        },
                        child: Text(
                          "Forgot",
                          style: TextStyle(color: HexColor('7DFDFE'), fontSize: 17, fontWeight: FontWeight.bold),
                        ),

                      )
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
                    controller.loginWithEmail(
                        emailController.text.trim(),
                        passwordController.text.trim());
                  },
                  label: const Text("Login",
                      style: TextStyle(color:Colors.black, fontSize: 20)),
                  icon: const Icon(Icons.login, color: Colors.black54, size: 25,),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 605, left:25) ,
                  child:ElevatedButton.icon(
                    onPressed: controller.signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Google's button is white
                      foregroundColor: Colors.black, // text color
                      minimumSize: const Size(20, 50), // full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: HexColor('7DFDFE'),
                    ),
                    icon: Image.asset(
                      'assets/google_logo.png', // download Google's official logo
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )

              )
            ],
          ),
        ),
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}