import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';


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
              Positioned(
                left:-100,
                top:-30,
                child: Container(

                  width: 475,
                  height: 475,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade200, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              //Title
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 300),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Login",
                        style:TextStyle(fontSize: 40, fontWeight: FontWeight.bold, ),
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
                      style: TextStyle(fontSize: 17, ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Get.toNamed('/signup');
                      },
                      child: const Text(
                        "  sign up",
                        style: TextStyle(color:Colors.purple,fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),

              //first field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 420),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Email",
                  ),
                ) ,
              ),

              //second field

              Padding(padding: const EdgeInsets.only(left: 40, top: 500, right:40),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon:Icon( Icons.lock) ,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: "Password",

                      suffix: GestureDetector(
                        onTap: () {
                          //empty for now
                        },
                        child: const Text(
                          "Forgot",
                          style: TextStyle(color: Colors.purple, fontSize: 17, fontWeight: FontWeight.bold),
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
                    backgroundColor: Colors.purple,
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
                      style: TextStyle(color:Colors.white, fontSize: 20)),
                  icon: const Icon(Icons.login, color: Colors.white, size: 25,),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 600, left:25) ,
                  child: SizedBox(width: 200,height: 60,
                    child: Obx(() => controller.isLoading.value ? const Center(child: CircularProgressIndicator())
                      :SignInButton(
                        Buttons.Google,
                        onPressed: controller.signInWithGoogle,
                    )),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }


}