import 'package:flutter/material.dart';
import 'package:macro_counter/models/user_settings.dart';
import 'package:macro_counter/providers/user_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:macro_counter/screens/scaffold_screen.dart';
import 'package:macro_counter/widgets/background_container.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  int? age;
  double? weight;
  double? height;
  String? gender;
  String? activityLevel;
  String? goal;

  // Add TextEditingControllers
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Add this new variable
  double _opacity = 1.0;

  List<Widget> get _steps => [
    _buildGoalStep(),
    _buildAgeStep(),
    _buildWeightStep(),
    _buildHeightStep(),
    _buildGenderStep(),
    _buildActivityLevelStep(),
    _buildFinalStep(), // Add this new step
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Widget _buildAgeStep() {
    return _buildInputStep(
      'Quantos anos você tem?',
      TextFormField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Idade',
          prefixIcon: Padding(
            padding: EdgeInsets.all(25),
            child: Text('🎂', style: TextStyle(fontSize: 24)),
          ),
          suffixText: 'anos',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFB0FF6B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          if (int.tryParse(value) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            age = int.parse(value);
          }
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              age = int.tryParse(value);
            });
          }
        },
      ),
    );
  }

  Widget _buildWeightStep() {
    return _buildInputStep(
      'Quanto você pesa atualmente?',
      TextFormField(
        controller: _weightController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: 'Peso',
          prefixIcon: Padding(
            padding: EdgeInsets.all(25),
            child: Text('⚖️', style: TextStyle(fontSize: 24)),
          ),
          suffixText: 'kg',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFB0FF6B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          if (double.tryParse(value) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            weight = double.parse(value);
          }
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              weight = double.tryParse(value);
            });
          }
        },
      ),
    );
  }

  Widget _buildHeightStep() {
    return _buildInputStep(
      'Qual é a sua altura?',
      TextFormField(
        controller: _heightController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: 'Altura',
          prefixIcon: Padding(
            padding: EdgeInsets.all(25),
            child: Text('📏', style: TextStyle(fontSize: 24)),
          ),
          suffixText: 'cm',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xFFB0FF6B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo é obrigatório';
          }
          if (double.tryParse(value) == null) {
            return 'Por favor, insira um número válido';
          }
          return null;
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            height = double.parse(value);
          }
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              height = double.tryParse(value);
            });
          }
        },
      ),
    );
  }

  Widget _buildGenderStep() {
    return _buildInputStep(
      'Qual é o seu gênero?',
      Column(
        children: [
          _buildOptionButton('Masculino', '👨', gender),
          _buildOptionButton('Feminino', '👩', gender),
        ],
      ),
    );
  }

  Widget _buildActivityLevelStep() {
    return _buildInputStep(
      'Como você descreveria seu nível de atividade?',
      Column(
        children: [
          _buildOptionButton('Sedentário', '🛋️', activityLevel),
          _buildOptionButton('Levemente Ativo', '🚶', activityLevel),
          _buildOptionButton('Moderadamente Ativo', '🏃', activityLevel),
          _buildOptionButton('Muito Ativo', '🏋️', activityLevel),
          _buildOptionButton('Extremamente Ativo', '🏅', activityLevel),
        ],
      ),
    );
  }

  Widget _buildGoalStep() {
    return _buildInputStep(
      'Qual objetivo você tem em mente?',
      Column(
        children: [
          _buildOptionButton('Perder Peso', '🥦', goal),
          _buildOptionButton('Manter Peso', '🥑', goal),
          _buildOptionButton('Ganhar Peso', '🥩', goal),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, String emoji, String? currentValue) {
    bool isSelected = currentValue == text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          onPressed: () => setState(() {
            if (text.contains('Masculino') || text.contains('Feminino')) {
              gender = text;
            } else if (text.contains('Peso')) {
              goal = text;
            } else {
              activityLevel = text;
            }
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Text(emoji, style: TextStyle(fontSize: 24)),
              ),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color:  Colors.black87,
                ),
              ),
              Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.grey[900],
                  size: 24,
                ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Color(0xFFB0FF6B): Colors.white,
            foregroundColor:  Colors.black87,
            elevation: isSelected ? 4 : 0,
            shadowColor: Colors.transparent,
            side: BorderSide(
              color: isSelected ? Color(0xFFB0FF6B) : Colors.white,
              width: 2,
            ),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildInputStep(String question, Widget input) {
    List<String> parts = question.split(' ');
    int splitIndex = parts.length ~/ 2;
    String firstPart = parts.sublist(0, splitIndex).join(' ');
    String secondPart = parts.sublist(splitIndex).join(' ');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Text(
              firstPart,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              secondPart,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            input,
          ],
        ),
      ),
    );
  }

    Widget _buildFinalStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFFB0FF6B),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.black,
              size: 60,
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Tudo pronto!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Vamos começar sua jornada para uma vida mais saudável.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 60),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(
              'Começar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(200, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      bool isValid = true;
      String errorMessage = '';
      
      // Validação específica para cada etapa
      switch (_currentStep) {
        case 0:
          if (goal == null) {
            isValid = false;
            errorMessage = 'Por favor, selecione um objetivo.';
          }
          break;
        case 1:
          if (age == null) {
            isValid = false;
            errorMessage = 'Por favor, insira sua idade.';
          }
          break;
        case 2:
          if (weight == null) {
            isValid = false;
            errorMessage = 'Por favor, insira seu peso.';
          }
          break;
        case 3:
          if (height == null) {
            isValid = false;
            errorMessage = 'Por favor, insira sua altura.';
          }
          break;
        case 4:
          if (gender == null) {
            isValid = false;
            errorMessage = 'Por favor, selecione seu gênero.';
          }
          break;
        case 5:
          if (activityLevel == null) {
            isValid = false;
            errorMessage = 'Por favor, selecione seu nível de atividade.';
          }
          break;
      }
      
      if (isValid) {
        setState(() {
          _opacity = 0.0; // Start fade-out
        });
        
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            _currentStep++;
            // Clear the text field when moving to the next step
            if (_currentStep == 2) _ageController.clear();
            if (_currentStep == 3) _weightController.clear();
            if (_currentStep == 4) _heightController.clear();
          });
          
          Future.delayed(Duration(milliseconds: 50), () {
            setState(() {
              _opacity = 1.0; // Start fade-in
            });
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _opacity = 0.0; // Start fade-out
      });
      
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _currentStep--;
        });
        
        Future.delayed(Duration(milliseconds: 50), () {
          setState(() {
            _opacity = 1.0; // Start fade-in
          });
        });
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _allFieldsFilled()) {
      _formKey.currentState!.save();
      
      double bmr = calculateBMR();
      double tdee = calculateTDEE(bmr);
      double calorieGoal = calculateCalorieGoal(tdee);
      
      // Calcular as metas calóricas para cada refeiço
      double breakfastCalorieGoal = calorieGoal * 0.25; // 25% (média entre 15% e 35%)
      double lunchCalorieGoal = calorieGoal * 0.30; // 30% (média entre 15% e 40%)
      double dinnerCalorieGoal = calorieGoal * 0.30; // 30% (média entre 15% e 40%)
      double snackCalorieGoal = calorieGoal * 0.15; // 15% (média entre 5% e 15%)

      // Verificar se a soma das calorias das refeições é igual ao total
      double totalMealCalories = breakfastCalorieGoal + lunchCalorieGoal + dinnerCalorieGoal + snackCalorieGoal;
      
      // Ajustar a diferença, se houver
      if (totalMealCalories != calorieGoal) {
        double difference = calorieGoal - totalMealCalories;
        // Distribuir a diferença igualmente entre as refeições
        double adjustment = difference / 4;
        breakfastCalorieGoal += adjustment;
        lunchCalorieGoal += adjustment;
        dinnerCalorieGoal += adjustment;
        snackCalorieGoal += adjustment;
      }

      UserSettings newSettings = UserSettings(
        calorieGoal: calorieGoal,
        carbGoal: calorieGoal * 0.5 / 4, // 50% das calorias de carboidratos
        proteinGoal: calorieGoal * 0.3 / 4, // 30% das calorias de proteínas
        fatGoal: calorieGoal * 0.2 / 9, // 20% das calorias de gorduras
        onboardingCompleted: true,
        age: age!,
        weight: weight!,
        height: height!,
        gender: gender!,
        activityLevel: activityLevel!,
        goal: goal!,
        breakfastCalorieGoal: breakfastCalorieGoal,
        lunchCalorieGoal: lunchCalorieGoal,
        dinnerCalorieGoal: dinnerCalorieGoal,
        snackCalorieGoal: snackCalorieGoal,
      );

      Provider.of<UserSettingsProvider>(context, listen: false).addObject(newSettings);
      
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ScaffoldScreen()),
    );
    } else {
      print("Formulário não validado ou campos não preenchidos");
      String missingFields = _getMissingFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha os seguintes campos: $missingFields')),
      );
    }
  }

  bool _allFieldsFilled() {
    return age != null &&
           weight != null &&
           height != null &&
           gender != null &&
           activityLevel != null &&
           goal != null;
  }

  String _getMissingFields() {
    List<String> missingFields = [];
    if (age == null) missingFields.add('Idade');
    if (weight == null) missingFields.add('Peso');
    if (height == null) missingFields.add('Altura');
    if (gender == null) missingFields.add('Gênero');
    if (activityLevel == null) missingFields.add('Nível de Atividade');
    if (goal == null) missingFields.add('Objetivo');
    return missingFields.join(', ');
  }

/*
  // BMR de Harris-Benedict
  double calculateBMR() {
    if (gender == 'Masculino') {
      return 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
    } else {
      return 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
    }
  }
*/

 // BMR de Mifflin-St Jeor
  double calculateBMR() {
    if (gender == 'Masculino') {
      return (10 * weight!) + (6.25 * height!) - (5 * age!) + 5;
    } else {
      return (10 * weight!) + (6.25 * height!) - (5 * age!) - 161;
    }
  }


  double calculateTDEE(double bmr) {
    switch (activityLevel) {
      case 'Sedentário':
        return bmr * 1.2;
      case 'Levemente Ativo':
        return bmr * 1.375;
      case 'Moderadamente Ativo':
        return bmr * 1.55;
      case 'Muito Ativo':
        return bmr * 1.725;
      case 'Extremamente Ativo':
        return bmr * 1.9;
      default:
        return bmr;
    }
  }

  double calculateCalorieGoal(double tdee) {
    switch (goal) {
      case 'Perder Peso':
        return tdee * 0.85; // 15% de déficit calórico
      case 'Ganhar Peso':
        return tdee * 1.15; // 15% de superávit calórico
      default:
        return tdee; // Manter peso
    }
  }



  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _currentStep > 0
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: _previousStep,
                )
              : null,
          title: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / _steps.length,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              
            ],
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: Duration(milliseconds: 300),
                      child: _steps[_currentStep],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_currentStep < _steps.length - 1) // Only show the button if it's not the final step
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        child: Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
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
}
