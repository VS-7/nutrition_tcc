import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/taco_meal_provider.dart';
import '../models/taco_meal.dart';
import '../widgets/background_container.dart';
import 'add_meal_screen.dart';

class MealDetailsScreen extends StatelessWidget {
  final String mealType;
  final DateTime selectedDate;

  const MealDetailsScreen({Key? key, required this.mealType, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            mealType,
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
        body: Consumer<TacoMealProvider>(
          builder: (context, mealProvider, child) {
            List<TacoMeal> meals = mealProvider.getMealsByTypeAndDate(mealType, selectedDate);
            return PageView(
              children: [
                // First page: Statistics and Nutrients
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMealInfoContainer(meals),
                      SizedBox(height: 20),
                      _buildMacronutrientGraph(meals),
                      SizedBox(height: 20),
                      _buildNutritionInfoContainer(meals),
                    ],
                  ),
                ),
                // Second page: Food list
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          TacoMeal meal = meals[index];
                          return ListTile(
                            title: Text(meal.food.nome ?? 'Alimento sem nome'),
                            subtitle: Text('${meal.quantity * 100} g'),
                            trailing: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                await mealProvider.deleteMeal(meal.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Alimento removido')),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        child: Text('Adicionar Alimento'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMealScreen(mealType: mealType, selectedDate: selectedDate),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealInfoContainer(List<TacoMeal> meals) {
    double totalCalories = meals.fold(0, (sum, meal) => sum + meal.food.energia * meal.quantity);
    double totalProtein = meals.fold(0, (sum, meal) => sum + meal.food.proteina * meal.quantity);
    double totalCarbs = meals.fold(0, (sum, meal) => sum + meal.food.carboidrato * meal.quantity);
    double totalFat = meals.fold(0, (sum, meal) => sum + meal.food.lipideos * meal.quantity);

    String imagePath;
    switch (mealType.toLowerCase()) {
      case 'café da manhã':
        imagePath = 'assets/images/coffe.png';
        break;
      case 'almoço':
        imagePath = 'assets/images/lunch.png';
        break;
      case 'jantar':
        imagePath = 'assets/images/dinner.png';
        break;
      case 'lanche':
        imagePath = 'assets/images/snack.png';
        break;
      default:
        imagePath = 'assets/icon.png';
    }

    return Container(
      padding: EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
          ),
          SizedBox(height: 16),
          Text(
            'Resumo da Refeição',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroInfo('Calorias', '${totalCalories.toStringAsFixed(1)} kcal', Colors.black),
              _buildMacroInfo('Carboidratos', '${totalCarbs.toStringAsFixed(1)}g', Colors.black),
              _buildMacroInfo('Proteínas', '${totalProtein.toStringAsFixed(1)}g', Colors.black),
              _buildMacroInfo('Gorduras', '${totalFat.toStringAsFixed(1)}g', Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMacronutrientGraph(List<TacoMeal> meals) {
    double totalCalories = meals.fold(0, (sum, meal) => sum + meal.food.energia * meal.quantity);
    double totalProtein = meals.fold(0, (sum, meal) => sum + meal.food.proteina * meal.quantity);
    double totalCarbs = meals.fold(0, (sum, meal) => sum + meal.food.carboidrato * meal.quantity);
    double totalFat = meals.fold(0, (sum, meal) => sum + meal.food.lipideos * meal.quantity);
    double totalMacros = totalProtein + totalCarbs + totalFat;

    // Definir um valor máximo de calorias (por exemplo, 2000 kcal)
    double maxCalories = 2000;

    return Container(
      padding: EdgeInsets.all(20),
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
            'Informações nutricionais',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          _buildMacroProgressBar('Calorias', totalCalories, maxCalories, unit: ' kcal', showPercentage: false),
          SizedBox(height: 15),
          _buildMacroProgressBar('Proteínas', totalProtein, totalMacros),
          SizedBox(height: 15),
          _buildMacroProgressBar('Carboidratos', totalCarbs, totalMacros),
          SizedBox(height: 15),
          _buildMacroProgressBar('Gorduras', totalFat, totalMacros),
        ],
      ),
    );
  }

  Widget _buildMacroProgressBar(String label, double value, double total, {String unit = 'g', bool showPercentage = true}) {
    double percentage = total > 0 ? value / total : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              showPercentage
                ? '${value.toStringAsFixed(1)}$unit (${(percentage * 100).toStringAsFixed(1)}%)'
                : '${value.toStringAsFixed(1)}$unit',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8),
        CustomProgressBar(percentage: percentage),
      ],
    );
  }

  Widget _buildNutritionInfoContainer(List<TacoMeal> meals) {
    return Container(
      padding: EdgeInsets.all(20),
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
          _buildNutrientsList(meals),
        ],
      ),
    );
  }

  Widget _buildNutrientsList(List<TacoMeal> meals) {
    final nutrientsList = [
      {'Energia': meals.fold(0.0, (sum, meal) => sum + meal.food.energia * meal.quantity)},
      {'Proteína': meals.fold(0.0, (sum, meal) => sum + meal.food.proteina * meal.quantity)},
      {'Lipídeos': meals.fold(0.0, (sum, meal) => sum + meal.food.lipideos * meal.quantity)},
      {'Carboidrato': meals.fold(0.0, (sum, meal) => sum + meal.food.carboidrato * meal.quantity)},
      {'Fibra': meals.fold(0.0, (sum, meal) => sum + meal.food.fibra * meal.quantity)},
      {'Cálcio': meals.fold(0.0, (sum, meal) => sum + meal.food.calcio * meal.quantity)},
      {'Magnésio': meals.fold(0.0, (sum, meal) => sum + meal.food.magnesio * meal.quantity)},
      {'Fósforo': meals.fold(0.0, (sum, meal) => sum + meal.food.fosforo * meal.quantity)},
      {'Ferro': meals.fold(0.0, (sum, meal) => sum + meal.food.ferro * meal.quantity)},
      {'Sódio': meals.fold(0.0, (sum, meal) => sum + meal.food.sodio * meal.quantity)},
      {'Potássio': meals.fold(0.0, (sum, meal) => sum + meal.food.potassio * meal.quantity)},
      {'Cobre': meals.fold(0.0, (sum, meal) => sum + meal.food.cobre * meal.quantity)},
      {'Zinco': meals.fold(0.0, (sum, meal) => sum + meal.food.zinco * meal.quantity)},
      {'Retinol': meals.fold(0.0, (sum, meal) => sum + meal.food.retinol * meal.quantity)},
      {'Riboflavina': meals.fold(0.0, (sum, meal) => sum + meal.food.riboflavina * meal.quantity)},
      {'Vitamina C': meals.fold(0.0, (sum, meal) => sum + meal.food.vitc * meal.quantity)},
      {'Vitamina A': meals.fold(0.0, (sum, meal) => sum + meal.food.vita * meal.quantity)},
      {'Vitamina B1': meals.fold(0.0, (sum, meal) => sum + meal.food.vitb1 * meal.quantity)},
      {'Vitamina B2': meals.fold(0.0, (sum, meal) => sum + meal.food.vitb2 * meal.quantity)},
      {'Vitamina B3': meals.fold(0.0, (sum, meal) => sum + meal.food.vitb3 * meal.quantity)},
      {'Vitamina B6': meals.fold(0.0, (sum, meal) => sum + meal.food.vitb6 * meal.quantity)},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: nutrientsList.length,
      itemBuilder: (context, index) {
        final entry = nutrientsList[index].entries.first;
        return ListTile(
          title: Text(
            entry.key,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
          trailing: Text(
            '${entry.value.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        );
      },
    );
  }
}

class CustomProgressBar extends StatefulWidget {
  final double percentage;

  const CustomProgressBar({Key? key, required this.percentage}) : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        );
      },
    );
  }
}
