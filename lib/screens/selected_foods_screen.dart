import 'package:flutter/material.dart';
import '../models/taco_meal.dart';
import '../widgets/background_container.dart';

class SelectedFoodsScreen extends StatefulWidget {
  final List<TacoMeal> selectedFoods;
  final Function(TacoMeal) onRemove;

  const SelectedFoodsScreen({
    Key? key,
    required this.selectedFoods,
    required this.onRemove,
  }) : super(key: key);

  @override
  _SelectedFoodsScreenState createState() => _SelectedFoodsScreenState();
}

class _SelectedFoodsScreenState extends State<SelectedFoodsScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Recem adicionados',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: widget.selectedFoods.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Os alimentos selecionados aparecerão aqui.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: widget.selectedFoods.length,
                itemBuilder: (context, index) {
                  final meal = widget.selectedFoods[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        meal.food.nome,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${(meal.quantity * 100).toStringAsFixed(0)}g'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          widget.onRemove(meal);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}