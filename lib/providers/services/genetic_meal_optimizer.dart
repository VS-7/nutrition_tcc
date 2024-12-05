import 'dart:math';
import '../../models/optimization_food.dart';
import 'individual.dart';

class GeneticMealOptimizer {
  final List<OptimizationFood> foods;
  final double targetCalories;
  final Map<String, double> nutritionalTargets;
  final Random random = Random();
  
  // Parâmetros do algoritmo genético
  final int populationSize = 100;
  final int maxGenerations = 25;
  final double mutationRate = 0.4;
  final double crossoverRate = 0.4;
  
  // Restrições de quantidade por categoria
  final int maxItemsPerCategory = 1; // Máximo de itens por categoria
  final double maxCaloriesDeviation = 0.01; // 1% de desvio permitido nas calorias

  GeneticMealOptimizer({
    required this.foods,
    required this.targetCalories,
    required this.nutritionalTargets,
  });

  Map<OptimizationFood, double> optimize() {
    print('Iniciando otimização genética...');
    print('Calorias alvo: $targetCalories');
    
    var population = _initializePopulation();
    
    for (int generation = 0; generation < maxGenerations; generation++) {
      _evaluatePopulation(population);
      population.sort((a, b) => b.fitness.compareTo(a.fitness));
      
      print('\nGeração $generation');
      print('Melhor fitness: ${population[0].fitness}');
      
      if (population[0].fitness > 0.9) {
        var solution = _convertToRecommendation(population[0]);
        if (_isValidSolution(solution)) {
          print('Solução válida encontrada!');
          return solution;
        }
      }

      print('Gerando nova população...');
      var newPopulation = <Individual>[];
      newPopulation.addAll(population.take(2)); // Elitismo
      
      while (newPopulation.length < populationSize) {
        var parent1 = _tournamentSelection(population);
        var parent2 = _tournamentSelection(population);
        var children = _crossover(parent1, parent2);
        children.forEach(_mutate);
        children.forEach(_enforceConstraints);
        newPopulation.addAll(children);
      }
      
      population = newPopulation;
    }

    print('Nenhuma solução ideal encontrada após todas as gerações.');
    return {};
  }

  void _enforceConstraints(Individual individual) {
    Map<String, int> categoryCount = {};
    Map<String, List<int>> categoryIndices = {};
    
    // Mapear índices por categoria
    for (int i = 0; i < foods.length; i++) {
      String category = foods[i].categoria;
      categoryIndices.putIfAbsent(category, () => []).add(i);
      if (individual.quantities[i] > 5) {
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    // Ajustar quantidades para respeitar o limite por categoria
    categoryCount.forEach((category, count) {
      if (count > maxItemsPerCategory) {
        var indices = categoryIndices[category]!;
        indices.sort((a, b) => individual.quantities[b].compareTo(individual.quantities[a]));
        
        // Zerar quantidades excedentes
        for (int i = maxItemsPerCategory; i < indices.length; i++) {
          individual.quantities[indices[i]] = 0;
        }
      }
    });

    // Ajustar calorias totais
    double totalCalories = _calculateTotalCalories(individual);
    if (totalCalories > targetCalories * (1 + maxCaloriesDeviation)) {
      double factor = targetCalories / totalCalories;
      for (int i = 0; i < individual.quantities.length; i++) {
        individual.quantities[i] *= factor;
      }
    }
  }

  double _calculateTotalCalories(Individual individual) {
    double total = 0;
    for (int i = 0; i < foods.length; i++) {
      total += foods[i].energia * individual.quantities[i] / 100;
    }
    return total;
  }

  double _calculateFitness(Individual individual) {
    Map<String, int> categoryCount = {};
    double totalCalories = 0;
    Map<String, double> totalNutrients = Map.from(nutritionalTargets);
    totalNutrients.forEach((key, value) => totalNutrients[key] = 0);

    // Calcular totais
    for (int i = 0; i < foods.length; i++) {
      if (individual.quantities[i] > 5) {
        String category = foods[i].categoria;
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        
        if (categoryCount[category]! > maxItemsPerCategory) {
          return 0;
        }
      }

      double quantity = individual.quantities[i] / 100;
      var food = foods[i];
      
      totalCalories += food.energia * quantity;
      totalNutrients.forEach((nutrient, total) {
        totalNutrients[nutrient] = total + _getNutrientValue(food, nutrient) * quantity;
      });
    }

    // Verificar calorias
    if (totalCalories > targetCalories * (1 + maxCaloriesDeviation) ||
        totalCalories < targetCalories * (1 - maxCaloriesDeviation)) {
      return 0;
    }

    double nutrientScore = 0;
    int nutrientsMetCount = 0;
    
    totalNutrients.forEach((nutrient, total) {
      double target = nutritionalTargets[nutrient]!;
      if (total >= target) {
        nutrientsMetCount++;
        nutrientScore += 1;
      } else {
        // Ajuste na penalidade para manter o score entre 0 e 1
        nutrientScore += total / target;
      }
    });

    // Normalizar o score para estar entre 0 e 1
    double normalizedScore = nutrientScore / totalNutrients.length;
    
    // Bônus menor para soluções que atendem todos os requisitos
    if (nutrientsMetCount == totalNutrients.length) {
      normalizedScore = (normalizedScore + 1) / 2;  // Média entre o score atual e 1
    }

    return normalizedScore;  // Agora garantimos que está entre 0 e 1
  }

  double _getNutrientValue(OptimizationFood food, String nutrient) {
    switch (nutrient) {
      case 'proteina': return food.proteina;
      case 'carboidrato': return food.carboidrato;
      case 'lipideos': return food.lipideos;
      case 'fibra': return food.fibraAlimentar;
      case 'calcio': return food.calcio;
      case 'manganes': return food.manganes;
      case 'ferro': return food.ferro;
      case 'magnesio': return food.magnesio;
      case 'fosforo': return food.fosforo;
      case 'zinco': return food.zinco;
      default: return 0;
    }
  }

  bool _isValidSolution(Map<OptimizationFood, double> solution) {
    Map<String, int> categoryCount = {};
    double totalCalories = 0;

    for (var entry in solution.entries) {
      String category = entry.key.categoria;
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      
      if (categoryCount[category]! > maxItemsPerCategory) {
        print('Categoria $category excede o limite de itens');
        return false;
      }

      totalCalories += entry.key.energia * entry.value / 100;
    }

    if (totalCalories > targetCalories * (1 + maxCaloriesDeviation) ||
        totalCalories < targetCalories * (1 - maxCaloriesDeviation)) {
      print('Calorias totais ($totalCalories) fora do intervalo permitido');
      return false;
    }

    return true;
  }

  List<Individual> _initializePopulation() {
    var population = <Individual>[];
    
    for (int i = 0; i < populationSize; i++) {
      var individual = Individual(foods.length);
      
      // Inicializar com valores aleatórios
      for (int j = 0; j < foods.length; j++) {
        individual.quantities[j] = random.nextDouble() * 200; // 0-100g
      }
      
      population.add(individual);
    }
    
    return population;
  }

  void _evaluatePopulation(List<Individual> population) {
    for (var individual in population) {
      individual.fitness = _calculateFitness(individual);
    }
  }

  Individual _tournamentSelection(List<Individual> population) {
    Individual best = population[random.nextInt(population.length)];
    for (int i = 0; i < 3; i++) {
      var contestant = population[random.nextInt(population.length)];
      if (contestant.fitness > best.fitness) {
        best = contestant;
      }
    }
    return Individual.clone(best);
  }

  List<Individual> _crossover(Individual parent1, Individual parent2) {
    if (random.nextDouble() > crossoverRate) {
      return [Individual.clone(parent1), Individual.clone(parent2)];
    }

    var child1 = Individual(foods.length);
    var child2 = Individual(foods.length);
    
    int crossPoint = random.nextInt(foods.length);
    
    for (int i = 0; i < foods.length; i++) {
      if (i < crossPoint) {
        child1.quantities[i] = parent1.quantities[i];
        child2.quantities[i] = parent2.quantities[i];
      } else {
        child1.quantities[i] = parent2.quantities[i];
        child2.quantities[i] = parent1.quantities[i];
      }
    }
    
    return [child1, child2];
  }

  void _mutate(Individual individual) {
    for (int i = 0; i < individual.quantities.length; i++) {
      if (random.nextDouble() < mutationRate) {
        individual.quantities[i] += (random.nextDouble() - 0.5) * 20; // ±10g
        individual.quantities[i] = individual.quantities[i].clamp(0, 100);
      }
    }
  }

  Map<OptimizationFood, double> _convertToRecommendation(Individual individual) {
    Map<OptimizationFood, double> recommendation = {};
    
    for (int i = 0; i < foods.length; i++) {
      if (individual.quantities[i] > 5) { // Mínimo de 5g
        recommendation[foods[i]] = individual.quantities[i];
      }
    }
    
    return recommendation;
  }
}
