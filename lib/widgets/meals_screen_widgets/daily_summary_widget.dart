import 'package:flutter/material.dart';
import '../../widgets/circular_progress_indicator.dart';

class DailySummaryWidget extends StatelessWidget {
  final double consumedCalories;
  final double calorieGoal;
  final double consumedCarbs;
  final double carbGoal;
  final double consumedProteins;
  final double proteinGoal;
  final double consumedFats;
  final double fatGoal;

  const DailySummaryWidget({
    Key? key,
    required this.consumedCalories,
    required this.calorieGoal,
    required this.consumedCarbs,
    required this.carbGoal,
    required this.consumedProteins,
    required this.proteinGoal,
    required this.consumedFats,
    required this.fatGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double calorieProgress = consumedCalories / calorieGoal;
    calorieProgress = calorieProgress > 1 ? 1 : calorieProgress;

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resumo Diário",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "${consumedCalories.toInt()}",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Calorias Consumidas",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  Text(
                    "${(calorieGoal - consumedCalories).toInt()}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Calorias Faltantes",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: calorieProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              minHeight: 13,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicatorWidget(
                consumedCarbs,
                carbGoal,
                Color(0xFFA7E100),
                Color(0xFFC9C9C9)!,
                "Carboidratos",
              ),
              CircularProgressIndicatorWidget(
                consumedProteins,
                proteinGoal,
                Color(0xFFA7E100),
                Color(0xFFC9C9C9)!,
                "Proteínas",
              ),
              CircularProgressIndicatorWidget(
                consumedFats,
                fatGoal,
                Color(0xFFA7E100),
                Color(0xFFC9C9C9)!,
                "Gorduras",
              ),
            ],
          ),
        ],
      ),
    );
  }
}