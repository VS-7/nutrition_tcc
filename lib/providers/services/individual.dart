class Individual {
  List<double> quantities; // Quantidades de cada alimento
  double fitness = 0;

  Individual(int size) : quantities = List.filled(size, 0.0);

  Individual.clone(Individual other)
      : quantities = List.from(other.quantities);
}