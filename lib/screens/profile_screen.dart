import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_market_predictor/controllers/auth_controller.dart';
import 'package:stock_market_predictor/controllers/portfolio_controller.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){
    final user = FirebaseAuth.instance.currentUser;
    final controller = Get.find<AuthController>();
    final portfolioController = Get.find<PortfolioController>();

    final photo = user?.photoURL;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            //Image

              CircleAvatar(
                radius: 60,
                backgroundImage: photo != null ? NetworkImage(photo) : AssetImage('assets/profileplaceholder.png'),
              ),

            const SizedBox(height: 20),

            //Name
            Text(
              user?.displayName ?? "No name" ,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            //Email
            Text(
              user?.email ?? "No email" ,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Obx(() => Card(
              color:  Colors.grey[900],
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: HexColor('7DFDFE'), width: 1.2),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "₹${portfolioController.balance.value.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: HexColor('7DFDFE'),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )),

            SizedBox(height: 40),


            //LogoutButton
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () async{
                    await controller.signOut();
                    Get.offAllNamed('/login');
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Logout', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('ED0808').withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  )
              ),
            )

          ],
        ),
      ),
    );
  }
}