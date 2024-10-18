import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/background_container.dart';
import '../models/taco_food.dart';
import '../models/taco_meal.dart';
import '../providers/taco_meal_provider.dart';

class FoodDetailsScreen extends StatefulWidget {
  final TacoFood food;

  const FoodDetailsScreen({Key? key, required this.food}) : super(key: key);

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  double _quantity = 100;

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Detalhes do Alimento',
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFoodInfoContainer(),
              SizedBox(height: 20),
              _buildNutritionInfoContainer(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addFood,
          icon: Icon(Icons.add_circle_outline_rounded),
          label: Text('Adicionar'),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

Widget _buildFoodInfoContainer() {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        Text(
          _getCategoryEmoji(widget.food.categoria),
          style: TextStyle(fontSize: 48),
        ),
        SizedBox(height: 10),
        Text(
          widget.food.nome,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        _buildNutritionInfo(),
      ],
    ),
  );
}

  Widget _buildNutritionInfoContainer() {
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
            'Informação nutricional',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildNutrientsList(),
        ],
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'bebidas':
        return '🥤';
      case 'acucarados':
        return '🍬';
      case 'carnes':
        return '🍗';
      case 'frutas':
        return '🍎';
      case 'industrializados':
        return '🏭';
      case 'leguminosas':
        return '🫘';
      case 'leites':
        return '🥛';
      case 'miscelaneas':
        return '🍱';
      case 'gorduras':
        return '🧈';
      case 'ovos':
        return '🥚';
      case 'pescados':
        return '🐟';
      case 'preparados':
        return '🍲';
      case 'verduras':
        return '🥬';
      case 'cereais':
        return '🌾';
      case 'nozes':
        return '🥜';
      default:
        return '🍽️';
    }
  }

  Widget _buildNutritionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroInfo('Calorias', '${(widget.food.energia * _quantity / 100).toStringAsFixed(1)} kcal', Colors.black),
        _buildMacroInfo('Carboidratos', '${(widget.food.carboidrato * _quantity / 100).toStringAsFixed(1)}g', Colors.black),
        _buildMacroInfo('Proteínas', '${(widget.food.proteina * _quantity / 100).toStringAsFixed(1)}g', Colors.black),
        _buildMacroInfo('Gorduras', '${(widget.food.lipideos * _quantity / 100).toStringAsFixed(1)}g', Colors.black),
      ],
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

  Widget _buildNutrientsList() {
    final nutrientsList = [
      {'Categoria': widget.food.categoria},
      {'Energia': widget.food.energia * _quantity / 100},
      {'Proteina': widget.food.proteina * _quantity / 100},
      {'Lipideos': widget.food.lipideos * _quantity / 100},
      {'Carboidrato': widget.food.carboidrato * _quantity / 100},
      
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: nutrientsList.length,
      itemBuilder: (context, index) {
        final entry = nutrientsList[index].entries.first;
        return ListTile(
          title: Text(entry.key),
          trailing: Text(
            _formatValue(entry.value),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        );
      },
    );
  }

  String _formatValue(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(2);
    } else if (value is int) {
      return value.toString();
    } else {
      return value.toString();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Quantidade (g):'),
          Slider(
            value: _quantity,
            min: 1,
            max: 500,
            divisions: 499,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[300],
            onChanged: (value) {
              setState(() {
                _quantity = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _addFood() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selecione o tipo de refeição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Café da manhã'),
                onTap: () => _saveMeal('Café da manhã'),
              ),
              ListTile(
                title: Text('Almoço'),
                onTap: () => _saveMeal('Almoço'),
              ),
              ListTile(
                title: Text('Jantar'),
                onTap: () => _saveMeal('Jantar'),
              ),
              ListTile(
                title: Text('Lanche'),
                onTap: () => _saveMeal('Lanche'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveMeal(String mealType) {
    final meal = TacoMeal(
      id: 0,
      food: widget.food,
      quantity: _quantity / 100,
      mealType: mealType,
      date: DateTime.now(),
    );

    final mealProvider = Provider.of<TacoMealProvider>(context, listen: false);
    mealProvider.addMeal(meal);

    Navigator.of(context).pop(); // Fecha o diálogo
    Navigator.of(context).pop(); // Volta para a tela anterior

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alimento adicionado com sucesso!')),
    );
  }
}