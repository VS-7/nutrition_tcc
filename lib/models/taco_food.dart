class TacoFood {
  final String nome;
  final double energia;
  final double proteina;
  final double lipideos;
  final double carboidrato;
  final String categoria;

  TacoFood({
    required this.nome,
    required this.energia,
    required this.proteina,
    required this.lipideos,
    required this.carboidrato,
    required this.categoria,
  });

  factory TacoFood.fromMap(Map<String, dynamic> map, String categoria) {
    return TacoFood(
      nome: map['Nome'] as String,
      energia: (map['Energia1'] as num).toDouble(),
      proteina: (map['Proteina'] as num).toDouble(),
      lipideos: (map['Lipideos'] as num).toDouble(),
      carboidrato: (map['Carboidrato'] as num).toDouble(),
      categoria: categoria,
    );
  }
}