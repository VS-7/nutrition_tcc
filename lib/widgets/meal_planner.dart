import 'package:flutter/material.dart';
import '../screens/add_meal_screen.dart';

class MealPlanner extends StatelessWidget {
  const MealPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            "Alimentação",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          MealItem(
            imagePath: 'assets/images/coffe.png',
            name: 'Café da manhã',
            calories: '900',
            consumed: '0',
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/lunch.png',
            name: 'Almoço',
            calories: '1.100',
            consumed: '0',
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/snack.png',
            name: 'Lanche',
            calories: '1.100',
            consumed: '0',
          ),
          Divider(color: Colors.grey, height: 2),
          MealItem(
            imagePath: 'assets/images/dinner.png',
            name: 'Jantar',
            calories: '1.100',
            consumed: '0',
          ),
        ],
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String calories;
  final String consumed;

  const MealItem({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.calories,
    required this.consumed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = double.parse(consumed) / double.parse(calories);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 4,
                ),
                ClipOval(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$consumed / $calories kcal', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
            ),
            width: 30,
            height: 30,
            child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(mealType: name),
                  ),
                );
                },
                padding: EdgeInsets.zero,

            ),
            ),
        ],
      ),
    );
  }
}