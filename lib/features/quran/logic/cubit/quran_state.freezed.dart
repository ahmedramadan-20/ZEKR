// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuranState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranState()';
}


}

/// @nodoc
class $QuranStateCopyWith<$Res>  {
$QuranStateCopyWith(QuranState _, $Res Function(QuranState) __);
}


/// Adds pattern-matching-related methods to [QuranState].
extension QuranStatePatterns on QuranState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Downloading value)?  downloading,TResult Function( Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Downloading() when downloading != null:
return downloading(_that);case Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Downloading value)  downloading,required TResult Function( Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Downloading():
return downloading(_that);case Success():
return success(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Downloading value)?  downloading,TResult? Function( Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Downloading() when downloading != null:
return downloading(_that);case Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( int current,  int total)?  downloading,TResult Function( List<Surah> surahs,  bool isDownloadingInBackground,  int? downloadProgress,  int? totalToDownload,  int? lastReadSurah,  int? lastReadPage)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Downloading() when downloading != null:
return downloading(_that.current,_that.total);case Success() when success != null:
return success(_that.surahs,_that.isDownloadingInBackground,_that.downloadProgress,_that.totalToDownload,_that.lastReadSurah,_that.lastReadPage);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( int current,  int total)  downloading,required TResult Function( List<Surah> surahs,  bool isDownloadingInBackground,  int? downloadProgress,  int? totalToDownload,  int? lastReadSurah,  int? lastReadPage)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Downloading():
return downloading(_that.current,_that.total);case Success():
return success(_that.surahs,_that.isDownloadingInBackground,_that.downloadProgress,_that.totalToDownload,_that.lastReadSurah,_that.lastReadPage);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( int current,  int total)?  downloading,TResult? Function( List<Surah> surahs,  bool isDownloadingInBackground,  int? downloadProgress,  int? totalToDownload,  int? lastReadSurah,  int? lastReadPage)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Downloading() when downloading != null:
return downloading(_that.current,_that.total);case Success() when success != null:
return success(_that.surahs,_that.isDownloadingInBackground,_that.downloadProgress,_that.totalToDownload,_that.lastReadSurah,_that.lastReadPage);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements QuranState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranState.initial()';
}


}




/// @nodoc


class _Loading implements QuranState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QuranState.loading()';
}


}




/// @nodoc


class _Downloading implements QuranState {
  const _Downloading({required this.current, required this.total});
  

 final  int current;
 final  int total;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadingCopyWith<_Downloading> get copyWith => __$DownloadingCopyWithImpl<_Downloading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Downloading&&(identical(other.current, current) || other.current == current)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,current,total);

@override
String toString() {
  return 'QuranState.downloading(current: $current, total: $total)';
}


}

/// @nodoc
abstract mixin class _$DownloadingCopyWith<$Res> implements $QuranStateCopyWith<$Res> {
  factory _$DownloadingCopyWith(_Downloading value, $Res Function(_Downloading) _then) = __$DownloadingCopyWithImpl;
@useResult
$Res call({
 int current, int total
});




}
/// @nodoc
class __$DownloadingCopyWithImpl<$Res>
    implements _$DownloadingCopyWith<$Res> {
  __$DownloadingCopyWithImpl(this._self, this._then);

  final _Downloading _self;
  final $Res Function(_Downloading) _then;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? current = null,Object? total = null,}) {
  return _then(_Downloading(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class Success implements QuranState {
  const Success({required final  List<Surah> surahs, required this.isDownloadingInBackground, this.downloadProgress, this.totalToDownload, this.lastReadSurah, this.lastReadPage}): _surahs = surahs;
  

 final  List<Surah> _surahs;
 List<Surah> get surahs {
  if (_surahs is EqualUnmodifiableListView) return _surahs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surahs);
}

 final  bool isDownloadingInBackground;
 final  int? downloadProgress;
 final  int? totalToDownload;
 final  int? lastReadSurah;
 final  int? lastReadPage;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&const DeepCollectionEquality().equals(other._surahs, _surahs)&&(identical(other.isDownloadingInBackground, isDownloadingInBackground) || other.isDownloadingInBackground == isDownloadingInBackground)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.totalToDownload, totalToDownload) || other.totalToDownload == totalToDownload)&&(identical(other.lastReadSurah, lastReadSurah) || other.lastReadSurah == lastReadSurah)&&(identical(other.lastReadPage, lastReadPage) || other.lastReadPage == lastReadPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surahs),isDownloadingInBackground,downloadProgress,totalToDownload,lastReadSurah,lastReadPage);

@override
String toString() {
  return 'QuranState.success(surahs: $surahs, isDownloadingInBackground: $isDownloadingInBackground, downloadProgress: $downloadProgress, totalToDownload: $totalToDownload, lastReadSurah: $lastReadSurah, lastReadPage: $lastReadPage)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $QuranStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 List<Surah> surahs, bool isDownloadingInBackground, int? downloadProgress, int? totalToDownload, int? lastReadSurah, int? lastReadPage
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? surahs = null,Object? isDownloadingInBackground = null,Object? downloadProgress = freezed,Object? totalToDownload = freezed,Object? lastReadSurah = freezed,Object? lastReadPage = freezed,}) {
  return _then(Success(
surahs: null == surahs ? _self._surahs : surahs // ignore: cast_nullable_to_non_nullable
as List<Surah>,isDownloadingInBackground: null == isDownloadingInBackground ? _self.isDownloadingInBackground : isDownloadingInBackground // ignore: cast_nullable_to_non_nullable
as bool,downloadProgress: freezed == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as int?,totalToDownload: freezed == totalToDownload ? _self.totalToDownload : totalToDownload // ignore: cast_nullable_to_non_nullable
as int?,lastReadSurah: freezed == lastReadSurah ? _self.lastReadSurah : lastReadSurah // ignore: cast_nullable_to_non_nullable
as int?,lastReadPage: freezed == lastReadPage ? _self.lastReadPage : lastReadPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class _Error implements QuranState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'QuranState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $QuranStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of QuranState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
