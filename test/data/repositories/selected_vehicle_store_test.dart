import 'package:diario_de_garagem/data/repositories/selected_vehicle_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('write then read, and clear with null', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SelectedVehicleStore(await SharedPreferences.getInstance());
    expect(store.read(), isNull);
    await store.write('a');
    expect(store.read(), 'a');
    await store.write(null);
    expect(store.read(), isNull);
  });
}
