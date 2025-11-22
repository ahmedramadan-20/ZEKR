import 'package:json_annotation/json_annotation.dart';
import 'sajda.dart';

/// Custom JSON converter for Sajda field
/// Handles both boolean (false) and Map object responses from API
class SajdaConverter implements JsonConverter<Sajda, dynamic> {
  const SajdaConverter();

  @override
  Sajda fromJson(dynamic json) {
    // If json is false or null, return noSajda
    if (json == false || json == null) {
      return const Sajda.noSajda();
    }

    // If json is a Map, parse as sajdaDetails
    if (json is Map<String, dynamic>) {
      return Sajda.sajdaDetails(
        id: json['id'] as int,
        recommended: json['recommended'] as bool,
        obligatory: json['obligatory'] as bool,
      );
    }

    // Default to noSajda for unexpected types
    return const Sajda.noSajda();
  }

  @override
  dynamic toJson(Sajda object) {
    return object.when(
      noSajda: () => false,
      sajdaDetails: (id, recommended, obligatory) => {
        'id': id,
        'recommended': recommended,
        'obligatory': obligatory,
      },
    );
  }
}
