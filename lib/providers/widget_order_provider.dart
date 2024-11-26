import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetOrderProvider with ChangeNotifier {
  List<String> _widgetOrder = [
    'daily_summary',
    'meal_recommendation',
    'meal_planner',
    'water_tracker',
    'notes',
  ];
  
  List<String> get widgetOrder => _widgetOrder;

  WidgetOrderProvider() {
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final order = prefs.getStringList('widget_order');
    if (order != null) {
      _widgetOrder = order;
      notifyListeners();
    }
  }

  Future<void> updateOrder(List<String> newOrder) async {
    _widgetOrder = newOrder;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('widget_order', newOrder);
    notifyListeners();
  }

  String getWidgetName(String id) {
    switch (id) {
      case 'daily_summary':
        return 'Resumo Diário';
      case 'meal_recommendation':
        return 'Recomendações';
      case 'meal_planner':
        return 'Planejador de Refeições';
      case 'water_tracker':
        return 'Consumo de Água';
      case 'notes':
        return 'Notas';
      default:
        return '';
    }
  }
}