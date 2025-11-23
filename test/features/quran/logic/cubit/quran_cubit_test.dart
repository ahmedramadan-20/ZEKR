import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quran/features/quran/logic/cubit/quran_cubit.dart';
import 'package:quran/features/quran/logic/cubit/quran_state.dart';
import 'package:quran/features/quran/data/repos/quran_repo.dart';
import 'package:quran/features/quran/data/models/surah_response.dart';

@GenerateMocks([QuranRepo])
import 'quran_cubit_test.mocks.dart';

void main() {
  late QuranCubit cubit;
  late MockQuranRepo mockRepo;

  setUp(() {
    mockRepo = MockQuranRepo();
    cubit = QuranCubit(mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('QuranCubit', () {
    final testSurahs = [
      const Surah(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatihah',
        englishNameTranslation: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      ),
      const Surah(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqarah',
        englishNameTranslation: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      ),
    ];

    test('initial state should be Initial', () {
      expect(cubit.state, equals(const QuranState.initial()));
    });

    test('should emit [Loading, Success] when getSurahList succeeds', () async {
      // Arrange
      when(mockRepo.getSurahList()).thenAnswer((_) async => testSurahs);
      when(mockRepo.isAllSurahsDownloaded()).thenReturn(true);
      when(mockRepo.getLastReadSurah()).thenReturn(null);
      when(mockRepo.getLastReadPage()).thenReturn(null);

      // Assert later
      final expected = [
        const QuranState.loading(),
        QuranState.success(
          surahs: testSurahs,
          isDownloadingInBackground: false,
          downloadProgress: null,
          totalToDownload: null,
          lastReadSurah: null,
          lastReadPage: null,
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      // Act
      await cubit.getSurahList();
    });

    test('should emit [Loading, Error] when getSurahList fails', () async {
      // Arrange
      when(mockRepo.getSurahList()).thenThrow(Exception('Network error'));

      // Assert later
      expectLater(
        cubit.stream,
        emitsInOrder([
          const QuranState.loading(),
          isA<QuranState>().having(
            (state) =>
                state.maybeMap(error: (e) => e.message, orElse: () => ''),
            'error message',
            contains('Network error'),
          ),
        ]),
      );

      // Act
      await cubit.getSurahList();
    });

    test('should emit downloading states during background download', () async {
      // Arrange
      when(mockRepo.getSurahList()).thenAnswer((_) async => testSurahs);
      when(mockRepo.isAllSurahsDownloaded()).thenReturn(false);
      when(mockRepo.getLastReadSurah()).thenReturn(null);
      when(mockRepo.getLastReadPage()).thenReturn(null);
      when(
        mockRepo.downloadAllSurahsStream(onProgress: anyNamed('onProgress')),
      ).thenAnswer((_) => Stream.value(null));

      // Assert later
      expectLater(
        cubit.stream,
        emitsInOrder([
          const QuranState.loading(),
          isA<QuranState>().having(
            (state) => state.maybeMap(
              success: (s) => s.isDownloadingInBackground,
              orElse: () => false,
            ),
            'isDownloadingInBackground',
            true,
          ),
        ]),
      );

      // Act
      await cubit.getSurahList();
    });

    test('should cancel download subscription on close', () async {
      // Arrange
      when(mockRepo.getSurahList()).thenAnswer((_) async => testSurahs);
      when(mockRepo.isAllSurahsDownloaded()).thenReturn(false);
      when(mockRepo.getLastReadSurah()).thenReturn(null);
      when(mockRepo.getLastReadPage()).thenReturn(null);
      when(
        mockRepo.downloadAllSurahsStream(onProgress: anyNamed('onProgress')),
      ).thenAnswer(
        (_) => Stream.periodic(
          const Duration(milliseconds: 100),
          (count) => null,
        ).take(10),
      );

      // Act
      await cubit.getSurahList();
      await cubit.close();

      // Assert
      expect(cubit.isClosed, true);
    });

    test(
      'updateLastReadPosition should update state with new position',
      () async {
        // Arrange
        when(mockRepo.getSurahList()).thenAnswer((_) async => testSurahs);
        when(mockRepo.isAllSurahsDownloaded()).thenReturn(true);
        when(mockRepo.getLastReadSurah()).thenReturn(1);
        when(mockRepo.getLastReadPage()).thenReturn(5);

        await cubit.getSurahList();

        // Change last read position
        when(mockRepo.getLastReadSurah()).thenReturn(2);
        when(mockRepo.getLastReadPage()).thenReturn(10);

        // Act
        cubit.updateLastReadPosition();

        // Assert
        final state = cubit.state;
        state.maybeMap(
          success: (s) {
            expect(s.lastReadSurah, 2);
            expect(s.lastReadPage, 10);
          },
          orElse: () => fail('Expected Success state'),
        );
      },
    );

    test('isAllSurahsDownloaded should return repo value', () {
      // Arrange
      when(mockRepo.isAllSurahsDownloaded()).thenReturn(true);

      // Act
      final result = cubit.isAllSurahsDownloaded();

      // Assert
      expect(result, true);
      verify(mockRepo.isAllSurahsDownloaded()).called(1);
    });

    test('getDownloadProgress should return repo value', () {
      // Arrange
      when(mockRepo.getDownloadProgress()).thenReturn(50);

      // Act
      final result = cubit.getDownloadProgress();

      // Assert
      expect(result, 50);
      verify(mockRepo.getDownloadProgress()).called(1);
    });
  });
}
