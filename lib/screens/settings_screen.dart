import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macro_counter/models/user_settings.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:macro_counter/widgets/background_container.dart';
import 'package:macro_counter/providers/services/onboarding_service.dart';
import 'package:macro_counter/dialogs/recalculate_calories_dialog.dart';

enum DietType {
  default_diet,
  low_carb,
  high_protein,
  low_fat,
  custom
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final OnboardingService _onboardingService = OnboardingService();
  DietType selectedDietType = DietType.default_diet;
  
  // Controladores existentes
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController carbPercentController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController proteinPercentController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController fatPercentController = TextEditingController();
  final TextEditingController waterController = TextEditingController();

  Map<DietType, Map<String, double>> dietPresets = {
    DietType.default_diet: {'carb': 50, 'protein': 20, 'fat': 30},
    DietType.low_carb: {'carb': 25, 'protein': 35, 'fat': 40},
    DietType.high_protein: {'carb': 35, 'protein': 40, 'fat': 25},
    DietType.low_fat: {'carb': 60, 'protein': 25, 'fat': 15},
  };

  void _applyDietPreset(DietType type) {
    if (type != DietType.custom) {
      final preset = dietPresets[type]!;
      setState(() {
        carbPercentController.text = preset['carb']!.toString();
        proteinPercentController.text = preset['protein']!.toString();
        fatPercentController.text = preset['fat']!.toString();
        selectedDietType = type;
        _updateMacrosFromPercentages();
      });
    }
  }

  void _updateMacrosFromPercentages() {
    if (calorieController.text.isNotEmpty) {
      double calories = double.parse(calorieController.text);
      double carbPercent = double.parse(carbPercentController.text);
      double proteinPercent = double.parse(proteinPercentController.text);
      double fatPercent = double.parse(fatPercentController.text);

      carbController.text = ((calories * carbPercent / 100) / 4).round().toString();
      proteinController.text = ((calories * proteinPercent / 100) / 4).round().toString();
      fatController.text = ((calories * fatPercent / 100) / 9).round().toString();
    }
  }

  Widget _buildDietTypeSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de Dieta',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: DietType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    backgroundColor: Colors.white,
                    selectedColor: Colors.black,
                    label: Text(_getDietTypeLabel(type)),
                    selected: selectedDietType == type,
                    onSelected: (selected) {
                      if (selected) _applyDietPreset(type);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required String label,
    required TextEditingController gramController,
    required TextEditingController percentController,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildTextField(
              label: label,
              controller: gramController,
              icon: icon,
              suffix: 'g',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextField(
              label: '',
              controller: percentController,
              icon: Icons.percent,
              suffix: '',
              onChanged: (value) {
                if (selectedDietType != DietType.custom) {
                  setState(() => selectedDietType = DietType.custom);
                }
                _updateMacrosFromPercentages();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getDietTypeLabel(DietType type) {
    switch (type) {
      case DietType.default_diet:
        return 'Padrão';
      case DietType.low_carb:
        return 'Low Carb';
      case DietType.high_protein:
        return 'Alto Proteína';
      case DietType.low_fat:
        return 'Baixa Gordura';
      case DietType.custom:
        return 'Personalizado';
    }
  }

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
        // Carrega valores existentes
        calorieController.text = currentSettings.calorieGoal.toString();
        carbController.text = currentSettings.carbGoal.toString();
        proteinController.text = currentSettings.proteinGoal.toString();
        fatController.text = currentSettings.fatGoal.toString();
        waterController.text = currentSettings.waterGoal.toString();

        // Calcula e define as porcentagens
        double totalCalories = currentSettings.calorieGoal;
        
        // Calcula porcentagens baseadas nas calorias de cada macro
        double carbCalories = currentSettings.carbGoal * 4;
        double proteinCalories = currentSettings.proteinGoal * 4;
        double fatCalories = currentSettings.fatGoal * 9;

        carbPercentController.text = (carbCalories / totalCalories * 100).round().toString();
        proteinPercentController.text = (proteinCalories / totalCalories * 100).round().toString();
        fatPercentController.text = (fatCalories / totalCalories * 100).round().toString();

        // Define o tipo de dieta baseado nas porcentagens
        _determineInitialDietType();
      });
    }
  }

  void _determineInitialDietType() {
    // Obtém as porcentagens atuais
    double carbPercent = double.parse(carbPercentController.text);
    double proteinPercent = double.parse(proteinPercentController.text);
    double fatPercent = double.parse(fatPercentController.text);

    // Compara com os presets para determinar o tipo de dieta
    for (var entry in dietPresets.entries) {
      var preset = entry.value;
      if ((preset['carb'] == carbPercent) && 
          (preset['protein'] == proteinPercent) && 
          (preset['fat'] == fatPercent)) {
        setState(() => selectedDietType = entry.key);
        return;
      }
    }

    // Se não corresponder a nenhum preset, marca como personalizado
    setState(() => selectedDietType = DietType.custom);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String suffix,
    Function(String)? onChanged,
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
        onChanged: onChanged,
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

  Widget _buildCalorieSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          label: 'Meta de Calorias',
          controller: calorieController,
          icon: Icons.local_fire_department_outlined,
          suffix: 'kcal',
          onChanged: (_) => _updateMacrosFromPercentages(),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final shouldRecalculate = await RecalculateCaloriesDialog.show(context);
                if (shouldRecalculate == true) {
                  _recalculateCalories();
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Text(
                      'Recalcular calorias',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_showRecalculateMessage)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Baseado nos seus dados pessoais',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  bool _showRecalculateMessage = false;

  void _recalculateCalories() async {
    final settingsProvider = Provider.of<UserSettingsProvider>(context, listen: false);
    final currentSettings = await settingsProvider.object;

    if (currentSettings != null) {
      final newSettings = _onboardingService.createUserSettings(
        age: currentSettings.age,
        weight: currentSettings.weight,
        height: currentSettings.height,
        gender: currentSettings.gender,
        activityLevel: currentSettings.activityLevel,
        goal: currentSettings.goal,
      );

      setState(() {
        calorieController.text = newSettings.calorieGoal.round().toString();
        _showRecalculateMessage = true;
        // Atualiza os macros baseados na nova caloria
        _updateMacrosFromPercentages();
      });

      // Esconde a mensagem após 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showRecalculateMessage = false;
          });
        }
      });
    }
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
                children: [
                  // Calories Container
                  _buildSettingsContainer(
                    title: 'Calorias',
                    child: _buildCalorieSection(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Macros Container
                  _buildSettingsContainer(
                    title: 'Macronutrientes',
                    child: Column(
                      children: [
                        _buildDietTypeSelector(),
                        _buildMacroRow(
                          label: 'Carboidratos',
                          gramController: carbController,
                          percentController: carbPercentController,
                          icon: Icons.grain_outlined,
                        ),
                        _buildMacroRow(
                          label: 'Proteínas',
                          gramController: proteinController,
                          percentController: proteinPercentController,
                          icon: Icons.egg_outlined,
                        ),
                        _buildMacroRow(
                          label: 'Gorduras',
                          gramController: fatController,
                          percentController: fatPercentController,
                          icon: Icons.opacity_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Water Container
                  _buildSettingsContainer(
                    title: 'Água',
                    child: _buildTextField(
                      label: 'Meta de Água',
                      controller: waterController,
                      icon: Icons.water_drop_outlined,
                      suffix: 'L',
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Save Button
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
                            waterGoal: double.parse(waterController.text),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    calorieController.dispose();
    carbController.dispose();
    proteinController.dispose();
    fatController.dispose();
    waterController.dispose();
    super.dispose();
  }
}