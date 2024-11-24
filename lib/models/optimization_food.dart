class OptimizationFood {
  final String nome;
  final String categoria;
  final double energia;
  final double proteina;
  final double lipideos;
  final double carboidrato;
  final double fibraAlimentar;
  final double calcio;
  final double magnesio;
  final double manganes;
  final double fosforo;
  final double ferro;
  final double zinco;
  final double preco;

  OptimizationFood({
    required this.nome,
    required this.categoria,
    required this.energia,
    required this.proteina,
    required this.lipideos,
    required this.carboidrato,
    required this.fibraAlimentar,
    required this.calcio,
    required this.magnesio,
    required this.manganes,
    required this.fosforo,
    required this.ferro,
    required this.zinco,
    required this.preco,
  });

  factory OptimizationFood.fromMap(Map<String, dynamic> map) {
    return OptimizationFood(
      nome: map['nome'] as String,
      categoria: map['categoria'] as String,
      energia: (map['energia'] as num).toDouble(),
      proteina: (map['proteina'] as num).toDouble(),
      lipideos: (map['lipideos'] as num).toDouble(),
      carboidrato: (map['carboidrato'] as num).toDouble(),
      fibraAlimentar: (map['fibraAlimentar'] as num).toDouble(),
      calcio: (map['calcio'] as num).toDouble(),
      magnesio: (map['magnesio'] as num).toDouble(),
      manganes: (map['manganes'] as num).toDouble(),
      fosforo: (map['fosforo'] as num).toDouble(),
      ferro: (map['ferro'] as num).toDouble(),
      zinco: (map['zinco'] as num).toDouble(),
      preco: (map['preco'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'OptimizationFood(nome: $nome, energia: $energia, proteina: $proteina, '
           'carboidrato: $carboidrato, fibraAlimentar: $fibraAlimentar)';
  }
}