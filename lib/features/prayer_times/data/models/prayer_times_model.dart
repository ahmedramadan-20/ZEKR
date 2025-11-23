class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String locationName;
  final DateTime date;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.locationName,
    required this.date,
  });

  // Get next prayer
  NextPrayer getNextPrayer() {
    final now = DateTime.now();
    
    if (now.isBefore(fajr)) {
      return NextPrayer(name: 'الفجر', time: fajr, type: PrayerType.fajr);
    } else if (now.isBefore(sunrise)) {
      return NextPrayer(name: 'الشروق', time: sunrise, type: PrayerType.sunrise);
    } else if (now.isBefore(dhuhr)) {
      return NextPrayer(name: 'الظهر', time: dhuhr, type: PrayerType.dhuhr);
    } else if (now.isBefore(asr)) {
      return NextPrayer(name: 'العصر', time: asr, type: PrayerType.asr);
    } else if (now.isBefore(maghrib)) {
      return NextPrayer(name: 'المغرب', time: maghrib, type: PrayerType.maghrib);
    } else if (now.isBefore(isha)) {
      return NextPrayer(name: 'العشاء', time: isha, type: PrayerType.isha);
    } else {
      // After Isha, next prayer is tomorrow's Fajr
      return NextPrayer(
        name: 'الفجر',
        time: fajr.add(const Duration(days: 1)),
        type: PrayerType.fajr,
      );
    }
  }

  // Get all prayers as list
  List<PrayerTime> getAllPrayers() {
    return [
      PrayerTime(name: 'الفجر', time: fajr, type: PrayerType.fajr),
      PrayerTime(name: 'الشروق', time: sunrise, type: PrayerType.sunrise),
      PrayerTime(name: 'الظهر', time: dhuhr, type: PrayerType.dhuhr),
      PrayerTime(name: 'العصر', time: asr, type: PrayerType.asr),
      PrayerTime(name: 'المغرب', time: maghrib, type: PrayerType.maghrib),
      PrayerTime(name: 'العشاء', time: isha, type: PrayerType.isha),
    ];
  }

  // Check if a specific prayer time has passed
  bool hasPassed(PrayerType type) {
    final now = DateTime.now();
    switch (type) {
      case PrayerType.fajr:
        return now.isAfter(fajr);
      case PrayerType.sunrise:
        return now.isAfter(sunrise);
      case PrayerType.dhuhr:
        return now.isAfter(dhuhr);
      case PrayerType.asr:
        return now.isAfter(asr);
      case PrayerType.maghrib:
        return now.isAfter(maghrib);
      case PrayerType.isha:
        return now.isAfter(isha);
    }
  }
}

class PrayerTime {
  final String name;
  final DateTime time;
  final PrayerType type;

  PrayerTime({
    required this.name,
    required this.time,
    required this.type,
  });
}

class NextPrayer extends PrayerTime {
  NextPrayer({
    required super.name,
    required super.time,
    required super.type,
  });

  // Get time remaining until this prayer
  Duration get timeRemaining => time.difference(DateTime.now());

  String get formattedTimeRemaining {
    final duration = timeRemaining;
    if (duration.isNegative) return 'الآن';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    } else {
      return '$minutes دقيقة';
    }
  }
}

enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
}
