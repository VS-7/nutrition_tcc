import 'package:flutter/material.dart';
import 'package:macro_counter/providers/food_provider.dart';
import 'package:macro_counter/providers/meal_provider.dart';
import 'package:macro_counter/screens/food_form_screen.dart';
import 'package:macro_counter/screens/foods_screen.dart';
import 'package:macro_counter/screens/meal_form_screen.dart';
import 'package:macro_counter/screens/meals_screen.dart';
import 'package:macro_counter/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class ScaffoldScreen extends StatefulWidget {
  bool fetchedData = false;
  ScaffoldScreen({super.key});

  @override
  State<ScaffoldScreen> createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> screens = [
    {
      "title": "Meals",
      "screen": MealsScreen(),
      "fabAction": (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealFormScreen(),
          ),
        );
      },
    },
    {
      "title": "Foods",
      "screen": FoodsScreen(),
      "fabAction": (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodFormScreen(),
          ),
        );
      },
    },
    {
      "title": "Configurações",
      "screen": SettingsScreen(),
      "fabAction": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    MealProvider mealProvider = Provider.of<MealProvider>(context);
    FoodProvider foodProvider = Provider.of<FoodProvider>(context);

    if (!widget.fetchedData) {
      widget.fetchedData = true;
      mealProvider.loadObjects();
      foodProvider.loadObjects();
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: selectedIndex == 0
            ? null
            : AppBar(
                title: Text(screens[selectedIndex]["title"]),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
        body: screens[selectedIndex]["screen"] as Widget,
        floatingActionButton: (screens[selectedIndex]["fabAction"] == null)
            ? null
            : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFA7E100).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  screens[selectedIndex]["fabAction"](context);
                },
                backgroundColor: Color(0xFFA7E100),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 32),
              ),
            ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Diário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Foods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      ),
    );
  }
}