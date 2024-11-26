import 'package:flutter/material.dart';
import '../../models/user_settings.dart';
import '../../screens/onboarding_screen.dart';

class PersonalDataWidget extends StatelessWidget {
  final UserSettings settings;

  const PersonalDataWidget({
    Key? key,
    required this.settings,
  }) : super(key: key);

  Widget _buildDataItem(String label, String value, IconData icon) {
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
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Redefinir Dados', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.warning, color: Colors.white),
          backgroundColor: Colors.black,
          content: const Text(
            'Isso irá redefinir todos os seus dados pessoais. Deseja continuar?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
              child: const Text('Confirmar', style: TextStyle(color: Colors.red)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dados Pessoais',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _showResetConfirmationDialog(context),
                tooltip: 'Redefinir dados',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildDataItem(
                'Idade',
                '${settings.age} anos',
                Icons.cake_outlined,
              ),
              _buildDataItem(
                'Altura',
                '${settings.height.toStringAsFixed(0)} cm',
                Icons.height_outlined,
              ),
              _buildDataItem(
                'Peso',
                '${settings.weight.toStringAsFixed(1)} kg',
                Icons.monitor_weight_outlined,
              ),
              _buildDataItem(
                'Gênero',
                settings.gender,
                Icons.person_outline,
              ),
              _buildDataItem(
                'Nível de Atividade',
                settings.activityLevel,
                Icons.directions_run_outlined,
              ),
              _buildDataItem(
                'Objetivo',
                settings.goal,
                Icons.track_changes_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}