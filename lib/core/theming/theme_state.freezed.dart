// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState()';
}


}

/// @nodoc
class $ThemeStateCopyWith<$Res>  {
$ThemeStateCopyWith(ThemeState _, $Res Function(ThemeState) __);
}


/// Adds pattern-matching-related methods to [ThemeState].
extension ThemeStatePatterns on ThemeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LightTheme value)?  light,TResult Function( DarkTheme value)?  dark,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LightTheme() when light != null:
return light(_that);case DarkTheme() when dark != null:
return dark(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LightTheme value)  light,required TResult Function( DarkTheme value)  dark,}){
final _that = this;
switch (_that) {
case LightTheme():
return light(_that);case DarkTheme():
return dark(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LightTheme value)?  light,TResult? Function( DarkTheme value)?  dark,}){
final _that = this;
switch (_that) {
case LightTheme() when light != null:
return light(_that);case DarkTheme() when dark != null:
return dark(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  light,TResult Function()?  dark,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LightTheme() when light != null:
return light();case DarkTheme() when dark != null:
return dark();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  light,required TResult Function()  dark,}) {final _that = this;
switch (_that) {
case LightTheme():
return light();case DarkTheme():
return dark();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  light,TResult? Function()?  dark,}) {final _that = this;
switch (_that) {
case LightTheme() when light != null:
return light();case DarkTheme() when dark != null:
return dark();case _:
  return null;

}
}

}

/// @nodoc


class LightTheme implements ThemeState {
  const LightTheme();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LightTheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.light()';
}


}




/// @nodoc


class DarkTheme implements ThemeState {
  const DarkTheme();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DarkTheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.dark()';
}


}




// dart format on
