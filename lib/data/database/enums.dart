enum VehicleType {
  car('Carro'),
  motorcycle('Moto');

  const VehicleType(this.label);
  final String label;
}

enum FuelType {
  gasoline('Gasolina'),
  ethanol('Etanol'),
  flex('Flex'),
  diesel('Diesel'),
  electric('Elétrico'),
  hybrid('Híbrido');

  const FuelType(this.label);
  final String label;
}

enum ModCategory {
  engine('Motor'),
  intakeExhaust('Admissão e escape'),
  suspension('Suspensão'),
  brakes('Freios'),
  wheelsTires('Rodas e pneus'),
  aesthetics('Estética'),
  interior('Interior'),
  audio('Som'),
  electrical('Elétrica'),
  other('Outros');

  const ModCategory(this.label);
  final String label;
}

enum ModificationStatus {
  planned('Planejada'),
  installed('Instalada'),
  removed('Removida');

  const ModificationStatus(this.label);
  final String label;
}

enum RegularizationStatus {
  pending('Pendente'),
  regularized('Regularizado');

  const RegularizationStatus(this.label);
  final String label;
}

enum MaintenanceType {
  oilChange('Troca de óleo'),
  filters('Filtros'),
  brakes('Freios'),
  tires('Pneus'),
  belt('Correia'),
  fluids('Fluidos'),
  alignment('Alinhamento e balanceamento'),
  service('Revisão'),
  other('Outro');

  const MaintenanceType(this.label);
  final String label;
}

enum LineItemParent {
  modification('Modificação'),
  maintenance('Manutenção');

  const LineItemParent(this.label);
  final String label;
}
