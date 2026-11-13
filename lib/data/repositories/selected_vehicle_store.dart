import 'package:shared_preferences/shared_preferences.dart';

/// Remembers which vehicle is selected across launches.
class SelectedVehicleStore {
  SelectedVehicleStore(this._prefs);

  static const key = 'selected_vehicle_id';

  final SharedPreferences _prefs;

  String? read() => _prefs.getString(key);

  Future<void> write(String? id) async {
    if (id == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, id);
    }
  }
}
