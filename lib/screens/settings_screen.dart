import 'package:flutter/material.dart';
import 'package:macro_counter/models/user_settings.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentSettings();
    });
  }

  void _loadCurrentSettings() async {
    final settingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
    final currentSettings = await settingsProvider.object;
    if (currentSettings != null) {
      setState(() {
        calorieController.text = currentSettings.calorieGoal.toString();
        carbController.text = currentSettings.carbGoal.toString();
        proteinController.text = currentSettings.proteinGoal.toString();
        fatController.text = currentSettings.fatGoal.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: calorieController,
              decoration: InputDecoration(labelText: 'Meta de Calorias'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: carbController,
              decoration: InputDecoration(labelText: 'Meta de Carboidratos'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: proteinController,
              decoration: InputDecoration(labelText: 'Meta de Proteínas'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: fatController,
              decoration: InputDecoration(labelText: 'Meta de Gorduras'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final settingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
                UserSettings newSettings = UserSettings(
                  calorieGoal: double.parse(calorieController.text),
                  carbGoal: double.parse(carbController.text),
                  proteinGoal: double.parse(proteinController.text),
                  fatGoal: double.parse(fatController.text),
                  onboardingCompleted: true,
                );
                await settingsProvider.addObject(newSettings);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configurações salvas com sucesso!')),
                );
              },
              child: Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    calorieController.dispose();
    carbController.dispose();
    proteinController.dispose();
    fatController.dispose();
    super.dispose();
  }
}