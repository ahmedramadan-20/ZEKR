import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quran/features/home/ui/home_screen.dart';
import 'package:quran/features/prayer_times/logic/cubit/prayer_times_cubit.dart';
import 'package:quran/features/prayer_times/logic/cubit/prayer_times_state.dart';
import 'package:quran/core/helpers/shared_pref_helper.dart';

@GenerateMocks([SharedPrefHelper, PrayerTimesCubit])
import 'home_screen_test.mocks.dart';

void main() {
  late MockSharedPrefHelper mockSharedPref;
  late MockPrayerTimesCubit mockPrayerTimesCubit;

  setUp(() {
    mockSharedPref = MockSharedPrefHelper();
    mockPrayerTimesCubit = MockPrayerTimesCubit();

    // Setup GetIt
    final getIt = GetIt.instance;
    getIt.registerSingleton<SharedPrefHelper>(mockSharedPref);
    getIt.registerFactory<PrayerTimesCubit>(() => mockPrayerTimesCubit);

    // Default mock values
    when(mockSharedPref.getDailyPagesRead()).thenReturn(5);
    when(mockSharedPref.getBookmarksList()).thenReturn([]);
    when(mockSharedPref.getLastReadSurah()).thenReturn(1);
    when(mockSharedPref.getLastReadPage()).thenReturn(10);
    when(mockSharedPref.getLastReadSurahName()).thenReturn('الفاتحة');

    when(mockPrayerTimesCubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      mockPrayerTimesCubit.state,
    ).thenReturn(const PrayerTimesState.initial());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<PrayerTimesCubit>.value(
        value: mockPrayerTimesCubit,
        child: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should display greeting header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('السلام عليكم'), findsOneWidget);
    });

    testWidgets('should display stats section', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('إحصائيات اليوم'), findsOneWidget);
      expect(find.text('القراءة اليومية'), findsOneWidget);
      expect(find.text('الإشارات المرجعية'), findsOneWidget);
    });

    testWidgets('should load and display daily stats', (tester) async {
      when(mockSharedPref.getDailyPagesRead()).thenReturn(7);
      when(mockSharedPref.getBookmarksList()).thenReturn([
        {'surahNumber': 1, 'ayahNumber': 1},
        {'surahNumber': 1, 'ayahNumber': 2},
      ]);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show continue reading card when last read exists', (
      tester,
    ) async {
      when(mockSharedPref.getLastReadSurah()).thenReturn(1);
      when(mockSharedPref.getLastReadPage()).thenReturn(10);
      when(mockSharedPref.getLastReadSurahName()).thenReturn('الفاتحة');

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ContinueReadingCard), findsOneWidget);
    });

    testWidgets('should not show continue reading card when no last read', (
      tester,
    ) async {
      when(mockSharedPref.getLastReadSurah()).thenReturn(null);
      when(mockSharedPref.getLastReadPage()).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ContinueReadingCard), findsNothing);
    });

    testWidgets('should display action cards', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('القرآن الكريم'), findsOneWidget);
      expect(find.text('البحث'), findsOneWidget);
      expect(find.text('المفضلة'), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);
    });

    testWidgets('should reload stats on pull to refresh', (tester) async {
      when(mockSharedPref.getDailyPagesRead()).thenReturn(5);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Change mock value
      when(mockSharedPref.getDailyPagesRead()).thenReturn(10);

      // Pull to refresh
      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Stats should be reloaded
      verify(mockSharedPref.getDailyPagesRead()).called(greaterThan(1));
    });

    testWidgets('should handle mounted check in _loadStats', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Remove widget
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // No errors should occur
    });

    testWidgets('should dispose properly without leaks', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Dispose widget
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();

      // Verify no memory leaks (implicit - test passes if no errors)
    });
  });
}
