import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macro_counter/models/user_settings.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:macro_counter/widgets/background_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String suffix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixText: suffix,
          suffixStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Configurações',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Meta de Calorias',
                    controller: calorieController,
                    icon: Icons.local_fire_department_outlined,
                    suffix: 'kcal',
                  ),
                  _buildTextField(
                    label: 'Meta de Carboidratos',
                    controller: carbController,
                    icon: Icons.grain_outlined,
                    suffix: 'g',
                  ),
                  _buildTextField(
                    label: 'Meta de Proteínas',
                    controller: proteinController,
                    icon: Icons.egg_outlined,
                    suffix: 'g',
                  ),
                  _buildTextField(
                    label: 'Meta de Gorduras',
                    controller: fatController,
                    icon: Icons.opacity_outlined,
                    suffix: 'g',
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final settingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
                          final currentSettings = await settingsProvider.object;
                          UserSettings newSettings = UserSettings(
                            name: currentSettings?.name ?? '',
                            calorieGoal: double.parse(calorieController.text),
                            carbGoal: double.parse(carbController.text),
                            proteinGoal: double.parse(proteinController.text),
                            fatGoal: double.parse(fatController.text),
                            onboardingCompleted: true,
                            age: currentSettings?.age ?? 0,
                            weight: currentSettings?.weight ?? 0,
                            height: currentSettings?.height ?? 0,
                            gender: currentSettings?.gender ?? '',
                            activityLevel: currentSettings?.activityLevel ?? '',
                            goal: currentSettings?.goal ?? '',
                            breakfastCalorieGoal: currentSettings?.breakfastCalorieGoal ?? 0,
                            lunchCalorieGoal: currentSettings?.lunchCalorieGoal ?? 0,
                            dinnerCalorieGoal: currentSettings?.dinnerCalorieGoal ?? 0,
                            snackCalorieGoal: currentSettings?.snackCalorieGoal ?? 0,
                          );
                          await settingsProvider.updateObject(newSettings);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Configurações salvas com sucesso!')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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