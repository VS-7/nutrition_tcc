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
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildHeader(),
                ),
                Expanded(
                  flex: 12,
                  child: _buildContent(),
                ),
                Expanded(
                  flex: 2,
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
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Bem vindo ao\n',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 28, color: Colors.black),
            ),
            TextSpan(
              text: 'Nutrition TCC',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 35, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 240,
          child: Image.asset(
            'assets/images/logo.png',
            //fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(height: 40),
      Text(
          'Conte calorias, receba dietas\npersonalizadas e alcance\nseus objetivos nutricionais!',
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.north_east, size: 30, color: Colors.white),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(double.infinity, 70),
          ),
        ),
      ),
    );
  }
}
