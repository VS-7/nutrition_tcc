class TacoFood {
  final int id;
  final String nome;
  final double energia;
  final double carboidrato;
  final double proteina;
  final double lipideos;

  TacoFood({
    required this.id,
    required this.nome,
    required this.energia,
    required this.carboidrato,
    required this.proteina,
    required this.lipideos,
  });

  factory TacoFood.fromMap(Map<String, dynamic> map) {
    return TacoFood(
      id: map['id'],
      nome: map['Nome'],
      energia: map['Energia1'],
      carboidrato: map['Carboidrato'],
      proteina: map['Proteina'],
      lipideos: map['Lipideos'],
    );
  }
}