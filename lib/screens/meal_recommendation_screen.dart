import 'package:flutter/material.dart';
import '../widgets/background_container.dart';

class MealRecommendationScreen extends StatelessWidget {
  const MealRecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Recomendação de Refeição',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('Conteúdo da recomendação de refeição virá aqui.'),
        ),
      ),
    );
  }
}