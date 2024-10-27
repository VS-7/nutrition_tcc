import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class MealRecommendationScreen extends StatelessWidget {
  const MealRecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('Conteúdo da recomendação de refeição virá aqui.'),
      ), 
    );
  }
}