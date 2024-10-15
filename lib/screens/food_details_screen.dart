import 'package:flutter/material.dart';
import '../widgets/background_container.dart';
import '../models/taco_food.dart';

class FoodDetailsScreen extends StatelessWidget {
  final TacoFood food;

  const FoodDetailsScreen({Key? key, required this.food}) : super(key: key);

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
              _buildHeaderCard(),
              _buildNutritionInfo(),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Text('informação nutricional', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _buildNutrientsList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Implement add food functionality
          },
          icon: Icon(Icons.add_circle_outline_rounded),
          label: Text('Adicionar', style: TextStyle(fontWeight: FontWeight.w600)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Colors.black,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantidade (g):'),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(50),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            food.nome,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMacroInfo('Calorias', '${food.energia.toStringAsFixed(1)} kcal', Colors.black),
          _buildMacroInfo('Carboidratos', '${food.carboidrato.toStringAsFixed(1)}g', Colors.black),
          _buildMacroInfo('Proteínas', '${food.proteina.toStringAsFixed(1)}g', Colors.black),
          _buildMacroInfo('Gorduras', '${food.lipideos.toStringAsFixed(1)}g', Colors.black),
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

  Widget _buildNutrientsList() {
    // Crie uma lista de pares chave-valor para todos os nutrientes
    final nutrientsList = [
      {'Energia': food.energia},
      {'Proteina': food.proteina},
      {'Lipideos': food.lipideos},
      {'Carboidrato': food.carboidrato},
      {'Categoria': food.categoria},
      // Adicione outros nutrientes aqui se necessário
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
}
