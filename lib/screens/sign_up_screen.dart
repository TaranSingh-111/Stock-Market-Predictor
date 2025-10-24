import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';
import 'package:stock_market_predictor/screens/login_screen.dart';

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


              //title

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 225),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Create account",
                        style:TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 17, ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context)=>  LoginScreen()),
                        );
                      },
                      child: const Text(
                        "  sign in",
                        style: TextStyle(color:Colors.purple,fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),

              //first field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 345),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Name",
                  ),
                ) ,
              ),

              //second field

              Padding(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 425),
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

              //third field

              Padding(padding: const EdgeInsets.only(left: 40, top: 505, right:40),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Password",
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
                      controller.createAccount(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim());
                    },
                    label: const Text("Sign up",
                        style: TextStyle(color:Colors.white, fontSize: 20)),
                    icon: const Icon(Icons.login, color: Colors.white, size: 25,)
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