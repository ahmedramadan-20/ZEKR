import 'package:freezed_annotation/freezed_annotation.dart';

part 'sajda.freezed.dart';

/// Sealed class representing Sajda (prostration) data
/// Can be either:
/// - noSajda: false (no sajda in this ayah)
/// - sajdaDetails: Map with sajda information
@freezed
class Sajda with _$Sajda {
  const Sajda._(); // Private constructor required for custom methods

  const factory Sajda.noSajda() = NoSajda;

  const factory Sajda.sajdaDetails({
    required int id,
    required bool recommended,
    required bool obligatory,
  }) = SajdaDetails;
}
