import 'package:flutter/material.dart';
import '../../models/user_settings.dart';

class UserGoalsWidget extends StatelessWidget {
  final UserSettings settings;

  const UserGoalsWidget({Key? key, required this.settings}) : super(key: key);

  Widget _buildGoalItem(String label, double value, IconData icon, bool isCalories) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCalories ? 'kcal' : 'g',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metas Diárias',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildGoalItem(
                'Calorias',
                settings.calorieGoal,
                Icons.local_fire_department_outlined,
                true,  // é caloria
              ),
              _buildGoalItem(
                'Carboidratos',
                settings.carbGoal,
                Icons.grain_outlined,
                false,  // não é caloria
              ),
              _buildGoalItem(
                'Proteínas',
                settings.proteinGoal,
                Icons.egg_outlined,
                false,  // não é caloria
              ),
              _buildGoalItem(
                'Gorduras',
                settings.fatGoal,
                Icons.opacity_outlined,
                false,  // não é caloria
              ),
            ],
          ),
        ],
      ),
    );
  }
}