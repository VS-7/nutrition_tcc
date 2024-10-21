class TacoFood {
  final String nome;
  final double energia;
  final double proteina;
  final double lipideos;
  final double colesterol;
  final double carboidrato;
  final double fibra;
  final double calcio;
  final double magnesio;
  final double manganes;
  final double fosforo;
  final double ferro;
  final double sodio;
  final double potassio;
  final double cobre;
  final double zinco;
  final double retinol;
  final double riboflavina;
  final double vitc;
  final double vita;
  final double vitb1;
  final double vitb2;
  final double vitb3;
  final double vitb6;
  final String categoria;

  TacoFood({
    required this.nome,
    required this.energia,
    required this.proteina,
    required this.lipideos,
    required this.colesterol,
    required this.carboidrato,
    required this.fibra,
    required this.calcio,
    required this.magnesio,
    required this.manganes,
    required this.fosforo,
    required this.ferro,
    required this.sodio,
    required this.potassio,
    required this.cobre,
    required this.zinco,
    required this.retinol,
    required this.riboflavina,
    required this.vitc,
    required this.vita,
    required this.vitb1,
    required this.vitb2,
    required this.vitb3,
    required this.vitb6,
    required this.categoria,
  });

  factory TacoFood.fromMap(Map<String, dynamic> map, String categoria) {
    return TacoFood(
      nome: map['Nome'] as String,
      energia: (map['Energia1'] as num).toDouble(),
      proteina: (map['Proteina'] as num).toDouble(),
      lipideos: (map['Lipideos'] as num).toDouble(),
      colesterol: (map['Colesterol'] as num).toDouble(),
      carboidrato: (map['Carboidrato'] as num).toDouble(),
      fibra: (map['FibraAlimentar'] as num).toDouble(),
      calcio: (map['Calcio'] as num).toDouble(),
      magnesio: (map['Magnesio'] as num).toDouble(),
      manganes: (map['Manganes'] as num).toDouble(),
      fosforo: (map['Fosforo'] as num).toDouble(),
      ferro: (map['Ferro'] as num).toDouble(),
      sodio: (map['Sodio'] as num).toDouble(),
      potassio: (map['Potassio'] as num).toDouble(),
      cobre: (map['Cobre'] as num).toDouble(),
      zinco: (map['Zinco'] as num).toDouble(),
      retinol: (map['RE'] as num).toDouble(),
      riboflavina: (map['RAE'] as num).toDouble(),
      vitc: (map['VitaminaC'] as num).toDouble(),
      vita: (map['VitaminaA'] as num).toDouble(),
      vitb1: (map['VitaminaB1'] as num).toDouble(),
      vitb2: (map['VitaminaB2'] as num).toDouble(),
      vitb3: (map['VitaminaB3'] as num).toDouble(),
      vitb6: (map['VitaminaB6'] as num).toDouble(),
      categoria: categoria,
    );
  }
}