// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sajda.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Sajda {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sajda);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Sajda()';
}


}

/// @nodoc
class $SajdaCopyWith<$Res>  {
$SajdaCopyWith(Sajda _, $Res Function(Sajda) __);
}


/// Adds pattern-matching-related methods to [Sajda].
extension SajdaPatterns on Sajda {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoSajda value)?  noSajda,TResult Function( SajdaDetails value)?  sajdaDetails,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoSajda() when noSajda != null:
return noSajda(_that);case SajdaDetails() when sajdaDetails != null:
return sajdaDetails(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoSajda value)  noSajda,required TResult Function( SajdaDetails value)  sajdaDetails,}){
final _that = this;
switch (_that) {
case NoSajda():
return noSajda(_that);case SajdaDetails():
return sajdaDetails(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoSajda value)?  noSajda,TResult? Function( SajdaDetails value)?  sajdaDetails,}){
final _that = this;
switch (_that) {
case NoSajda() when noSajda != null:
return noSajda(_that);case SajdaDetails() when sajdaDetails != null:
return sajdaDetails(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noSajda,TResult Function( int id,  bool recommended,  bool obligatory)?  sajdaDetails,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoSajda() when noSajda != null:
return noSajda();case SajdaDetails() when sajdaDetails != null:
return sajdaDetails(_that.id,_that.recommended,_that.obligatory);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noSajda,required TResult Function( int id,  bool recommended,  bool obligatory)  sajdaDetails,}) {final _that = this;
switch (_that) {
case NoSajda():
return noSajda();case SajdaDetails():
return sajdaDetails(_that.id,_that.recommended,_that.obligatory);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noSajda,TResult? Function( int id,  bool recommended,  bool obligatory)?  sajdaDetails,}) {final _that = this;
switch (_that) {
case NoSajda() when noSajda != null:
return noSajda();case SajdaDetails() when sajdaDetails != null:
return sajdaDetails(_that.id,_that.recommended,_that.obligatory);case _:
  return null;

}
}

}

/// @nodoc


class NoSajda extends Sajda {
  const NoSajda(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoSajda);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Sajda.noSajda()';
}


}




/// @nodoc


class SajdaDetails extends Sajda {
  const SajdaDetails({required this.id, required this.recommended, required this.obligatory}): super._();
  

 final  int id;
 final  bool recommended;
 final  bool obligatory;

/// Create a copy of Sajda
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SajdaDetailsCopyWith<SajdaDetails> get copyWith => _$SajdaDetailsCopyWithImpl<SajdaDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SajdaDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.recommended, recommended) || other.recommended == recommended)&&(identical(other.obligatory, obligatory) || other.obligatory == obligatory));
}


@override
int get hashCode => Object.hash(runtimeType,id,recommended,obligatory);

@override
String toString() {
  return 'Sajda.sajdaDetails(id: $id, recommended: $recommended, obligatory: $obligatory)';
}


}

/// @nodoc
abstract mixin class $SajdaDetailsCopyWith<$Res> implements $SajdaCopyWith<$Res> {
  factory $SajdaDetailsCopyWith(SajdaDetails value, $Res Function(SajdaDetails) _then) = _$SajdaDetailsCopyWithImpl;
@useResult
$Res call({
 int id, bool recommended, bool obligatory
});




}
/// @nodoc
class _$SajdaDetailsCopyWithImpl<$Res>
    implements $SajdaDetailsCopyWith<$Res> {
  _$SajdaDetailsCopyWithImpl(this._self, this._then);

  final SajdaDetails _self;
  final $Res Function(SajdaDetails) _then;

/// Create a copy of Sajda
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recommended = null,Object? obligatory = null,}) {
  return _then(SajdaDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,recommended: null == recommended ? _self.recommended : recommended // ignore: cast_nullable_to_non_nullable
as bool,obligatory: null == obligatory ? _self.obligatory : obligatory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
