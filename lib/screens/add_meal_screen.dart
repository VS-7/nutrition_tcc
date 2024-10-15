import 'package:flutter/material.dart';
import '../widgets/background_container.dart';
import '../data/taco_dao.dart';
import '../widgets/food_item_card.dart';
import '../models/taco_food.dart';
import '../models/taco_meal.dart';
import '../providers/taco_meal_provider.dart';
import 'package:provider/provider.dart';

class AddMealScreen extends StatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const AddMealScreen({Key? key, required this.mealType, required this.selectedDate}) : super(key: key);

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TacoDao _tacoDao = TacoDao();

  List<String> _categories = [];
  String? _selectedCategory;
  List<TacoFood> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAllFoods(); // Carrega todos os alimentos inicialmente
  }

  Future<void> _loadCategories() async {
    final categories = await _tacoDao.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _loadAllFoods() async {
    final allFoods = await _tacoDao.getAllFoods();
    setState(() {
      _searchResults = allFoods;
    });
  }

  Future<void> _searchFood(String query) async {
    if (query.isEmpty && _selectedCategory == null) {
      await _loadAllFoods();
      return;
    }

    List<TacoFood> results;
    if (_selectedCategory != null) {
      results = await _tacoDao.getFoodsByCategory(_selectedCategory!);
      if (query.isNotEmpty) {
        results = results.where((food) => 
          food.nome.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    } else {
      results = await _tacoDao.searchFoodByName(query);
    }

    setState(() {
      _searchResults = results;
    });
  }

  void _addFoodToMeal(TacoFood food) {
    showDialog(
      context: context,
      builder: (context) {
        double quantity = 100;
        return AlertDialog(
          title: Text('Adicionar ${food.nome}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quantidade (g):'),
              Slider(
                value: quantity,
                min: 0,
                max: 500,
                divisions: 50,
                onChanged: (value) {
                  setState(() {
                    quantity = value;
                  });
                },
              ),
              Text('${quantity.toStringAsFixed(0)}g'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () {
                final mealProvider = Provider.of<TacoMealProvider>(context, listen: false);
                final newMeal = TacoMeal(
                  id: DateTime.now().millisecondsSinceEpoch,
                  food: food,
                  quantity: quantity / 100,
                  mealType: widget.mealType,
                  date: widget.selectedDate,
                );
                mealProvider.addMeal(newMeal);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            widget.mealType,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'O que você procura?',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onChanged: _searchFood,
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                        _searchFood(_searchController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == null ? Colors.black : Colors.white,
                        foregroundColor: _selectedCategory == null ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Todos'),
                    ),
                  ),
                  ..._categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedCategory == category ? Colors.black : Colors.white,
                          foregroundColor: _selectedCategory == category ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _searchFood(_searchController.text);
                        },
                        child: Text(category),
                      ),
                    );
                  }).toList(),
                ],
              ),  
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final food = _searchResults[index];
                  return FoodItemCard(
                    food: food,
                    onAdd: _addFoodToMeal,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}