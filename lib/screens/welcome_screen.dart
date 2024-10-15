import 'package:flutter/material.dart';
import 'package:macro_counter/screens/onboarding_screen.dart';
import 'package:macro_counter/widgets/background_container.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildHeader(),
                ),
                Expanded(
                  flex: 6,
                  child: _buildContent(),
                ),
                Expanded(
                  flex: 1,
                  child: _buildFooter(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        'Bem Vindo Ao\nNutrition TCC',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/icon.png',
          height: 260,
        ),
        SizedBox(height: 40),
        Text(
          'Acompanhe Suas Refeições\nE Alcance Seus Objetivos\nNutricionais!',
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

   Widget _buildFooter(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingScreen()),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('ENTRAR', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.north_east, size: 24, color: Colors.white),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA7E100),
            foregroundColor: Colors.black,
            padding: EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(double.infinity, 60),
          ),
        ),
      ),
    );
  }
}
