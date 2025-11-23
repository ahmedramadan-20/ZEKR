import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../models/prayer_times_model.dart';

class PrayerTimesRepo {
  final SharedPrefHelper _sharedPrefHelper;

  PrayerTimesRepo(this._sharedPrefHelper);

  /// Calculate prayer times for current location
  Future<PrayerTimesModel> getPrayerTimes() async {
    // Get location
    Position position = await _getCurrentLocation();

    // Get saved calculation method or use default
    final calculationMethod = _getCalculationMethod();

    // Create coordinates
    final coordinates = Coordinates(position.latitude, position.longitude);

    // Set calculation parameters
    final params = calculationMethod.getParameters();
    params.madhab = Madhab.shafi; // Can be made configurable

    // Calculate prayer times
    final prayerTimes = PrayerTimes.today(coordinates, params);

    // Get location name (you can enhance this with reverse geocoding)
    final locationName = await _getLocationName(position);

    return PrayerTimesModel(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      locationName: locationName,
      date: DateTime.now(),
    );
  }

  /// Get current device location
  Future<Position> _getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
  }

  /// Get location name (can be enhanced with geocoding)
  Future<String> _getLocationName(Position position) async {
    // For now, return coordinates
    // You can add geocoding here to get actual city name
    final lat = position.latitude.toStringAsFixed(2);
    final lng = position.longitude.toStringAsFixed(2);
    return 'موقعك ($lat, $lng)';
  }

  /// Get calculation method from preferences
  CalculationMethod _getCalculationMethod() {
    final methodName = _sharedPrefHelper.getPrayerCalculationMethod();
    switch (methodName) {
      case 'MuslimWorldLeague':
        return CalculationMethod.muslim_world_league;
      case 'Egyptian':
        return CalculationMethod.egyptian;
      case 'Karachi':
        return CalculationMethod.karachi;
      case 'UmmAlQura':
        return CalculationMethod.umm_al_qura;
      case 'Dubai':
        return CalculationMethod.dubai;
      case 'Qatar':
        return CalculationMethod.qatar;
      case 'Kuwait':
        return CalculationMethod.kuwait;
      case 'MoonsightingCommittee':
        return CalculationMethod.moon_sighting_committee;
      case 'Singapore':
        return CalculationMethod.singapore;
      case 'NorthAmerica':
        return CalculationMethod.north_america;
      default:
        return CalculationMethod.muslim_world_league;
    }
  }

  /// Save calculation method preference
  Future<void> saveCalculationMethod(String method) async {
    await _sharedPrefHelper.setPrayerCalculationMethod(method);
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}
