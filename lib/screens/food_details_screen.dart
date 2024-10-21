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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
      {'Calorias': widget.food.energia * _quantity / 100},
      {'Proteína': widget.food.proteina * _quantity / 100},
      {'Lipídeos': widget.food.lipideos * _quantity / 100},
      {'Carboidrato': widget.food.carboidrato * _quantity / 100},
      {'Colesterol': widget.food.colesterol * _quantity / 100},
      {'Fibra': widget.food.fibra * _quantity / 100},
      {'Cálcio': widget.food.calcio * _quantity / 100},
      {'Magnésio': widget.food.magnesio * _quantity / 100},
      {'Manganês': widget.food.manganes * _quantity / 100},
      {'Fósforo': widget.food.fosforo * _quantity / 100},
      {'Ferro': widget.food.ferro * _quantity / 100},
      {'Sódio': widget.food.sodio * _quantity / 100},
      {'Potássio': widget.food.potassio * _quantity / 100},
      {'Cobre': widget.food.cobre * _quantity / 100},
      {'Zinco': widget.food.zinco * _quantity / 100},
      {'Retinol': widget.food.retinol * _quantity / 100},
      {'Riboflavina': widget.food.riboflavina * _quantity / 100},
      {'Vitamina C': widget.food.vitc * _quantity / 100},
      {'Vitamina A': widget.food.vita * _quantity / 100},
      {'Vitamina B1': widget.food.vitb1 * _quantity / 100},
      {'Vitamina B2': widget.food.vitb2 * _quantity / 100},
      {'Vitamina B3': widget.food.vitb3 * _quantity / 100},
      {'Vitamina B6': widget.food.vitb6 * _quantity / 100},
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
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.white, size: 22),
          onPressed: () {
            setState(() {
              _quantity = (_quantity - 1).clamp(1, 500);
            });
          },
        ),
        GestureDetector(
          onTap: () => _showQuantityInputDialog(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '${_quantity.toStringAsFixed(0)}g',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 22),
          onPressed: () {
            setState(() {
              _quantity = (_quantity + 1).clamp(1, 500);
            });
          },
        ),
      ],
    ),
  );
}

void _showQuantityInputDialog() {
  String inputValue = _quantity.toStringAsFixed(0);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Text(
                'Inserir quantidade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    TextField(
                    keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixText: 'g',
                    suffixStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: TextEditingController(text: inputValue),
                  onChanged: (value) {
                    inputValue = value;
                      },
                    ),
                    SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 16),
                      ElevatedButton(
                        child: Text('OK'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _quantity = double.tryParse(inputValue)?.clamp(1, 500) ?? _quantity;
                          });
                          Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFood() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Selecione o tipo de refeição',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildMealTypeButton('Café da manhã'),
                    _buildMealTypeButton('Almoço'),
                    _buildMealTypeButton('Jantar'),
                    _buildMealTypeButton('Lanche'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealTypeButton(String mealType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        child: Text(mealType),
        onPressed: () => _saveMeal(mealType),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
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
