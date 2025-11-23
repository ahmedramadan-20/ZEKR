# Flutter Project Audit Report (V2)

**Date:** 2025-11-23
**Status:** Critical Memory Leaks Resolved ✅ | High Priority Performance Issues Remaining ⚠️

---

## 1. Prioritized Issue Table

| Severity | File | Short Problem | Fix Summary | Status |
| :--- | :--- | :--- | :--- | :--- |
| **CRITICAL** | `lib/features/home/ui/home_screen.dart` | Memory Leak (Missing `dispose`) | Added `dispose()` & `_prayerTimesCubit.close()` | **✅ FIXED** |
| **CRITICAL** | `lib/features/quran/ui/quran_screen.dart` | Memory Leak (Missing `dispose`) | Added `dispose()` | **✅ FIXED** |
| **CRITICAL** | `lib/features/quran/ui/widgets/download_dialog.dart` | Memory Leak (Subscription) | Added `dispose()` | **✅ FIXED** |
| **CRITICAL** | `lib/features/settings/ui/settings_screen.dart` | Memory Leak (Async ops) | Added `dispose()` | **✅ FIXED** |
| **HIGH** | `lib/core/helpers/database_helper.dart` | Slow Search (O(n) scan) | Implement FTS4/FTS5 Virtual Table | **⚠️ OPEN** |
| **HIGH** | `lib/features/quran/data/repos/quran_repo.dart` | UI Freeze (Main Thread DB) | Move DB inserts to `Isolate` | **⚠️ OPEN** |
| **HIGH** | `lib/features/home/ui/home_screen.dart` | Async `setState` after dispose | Added `if (!mounted) return;` | **✅ FIXED** |
| **MEDIUM** | Global (50+ files) | Excessive Rebuilds | Add `const` constructors | **⚠️ OPEN** |
| **MEDIUM** | `lib/features/quran/ui/quran_screen.dart` | List Rendering Performance | Add `itemExtent` / `RepaintBoundary` | **🔄 PARTIAL** |
| **LOW** | `lib/features/home/ui/home_screen.dart` | Duplicate Dependency Init | Removed duplicate `getIt` call | **✅ FIXED** |

---

## 2. Full Detailed Issue Sections

### [HIGH] Inefficient Database Search
**Problem:** The `searchAyahs` method in `DatabaseHelper` likely performs a full table scan or iterates through JSON in Dart, which is O(n) and causes UI jank on large datasets (6000+ ayahs).
**File:** `lib/core/helpers/database_helper.dart`
**Current Code (Inferred):**
```dart
// Likely doing: SELECT * FROM surah_details WHERE ... LIKE '%query%'
// Or worse: fetching all and filtering in Dart
```
**Fix (FTS Implementation):**
```dart
Future<void> _createDB(Database db, int version) async {
  // Create Virtual Table for FTS
  await db.execute('''
    CREATE VIRTUAL TABLE ayahs_search USING fts5(
      surahNumber,
      ayahNumber,
      text,
      tokenize = 'unicode61'
    );
  ''');
}

// Fast Search Query
Future<List<Map<String, dynamic>>> searchAyahs(String query) async {
  return await _database!.rawQuery('''
    SELECT * FROM ayahs_search 
    WHERE ayahs_search MATCH ? 
    ORDER BY rank
  ''', ['$query*']);
}
```

### [HIGH] Blocking UI Thread with Heavy DB Operations
**Problem:** Downloading and inserting the entire Quran (6236 verses) happens on the main isolate. This causes the app to freeze/ANR during the "Downloading" dialog.
**File:** `lib/features/quran/data/repos/quran_repo.dart`
**Fix (Isolates):**
```dart
// Use compute() to offload JSON parsing and DB insertion
Future<void> saveSurahsToDb(List<Surah> surahs) async {
  await compute(_insertSurahsIsolate, surahs);
}

// Top-level function
Future<void> _insertSurahsIsolate(List<Surah> surahs) async {
  // Note: Requires passing RootIsolateToken or opening new DB connection
  final db = await DatabaseHelper.instance.database; 
  final batch = db.batch();
  for (var s in surahs) {
    batch.insert('surahs', s.toJson());
  }
  await batch.commit(noResult: true);
}
```

### [MEDIUM] Missing `const` Constructors
**Problem:** Many widgets (e.g., in `home_screen.dart`, `quran_screen.dart`) are instantiated without `const`. This prevents Flutter from caching the widget element, leading to unnecessary rebuilds of static sub-trees.
**Fix:**
```dart
// Before
Column(children: [
  SizedBox(height: 20), // Rebuilt every time
  Text('Title'),        // Rebuilt every time
])

// After
Column(children: [
  const SizedBox(height: 20), // Cached
  const Text('Title'),        // Cached
])
```

---

## 3. Architecture Review

### Strengths
*   **Clean Architecture Layers:** Clear separation of `data`, `domain` (logic/cubit), and `ui`.
*   **Dependency Injection:** Proper use of `get_it` for service location.
*   **BLoC Pattern:** Consistent use of Cubits for state management.
*   **Offline-First:** Robust local caching with `sqflite` and `shared_preferences`.

### Weaknesses & Improvements
*   **Missing Domain Entities:** The app seems to use Data Models (`SurahResponse`) directly in the UI. Ideally, map these to pure Domain Entities to decouple UI from API structure.
*   **Repo-Logic Coupling:** Some Repositories might be doing too much business logic (e.g., deciding *when* to fetch from API vs DB). This logic is better placed in a UseCase or the Cubit.
*   **Error Handling:** `try-catch` blocks are sporadic. Introduce a global `Failure` class (e.g., `ServerFailure`, `CacheFailure`) and use `Either<Failure, Success>` return types (using `fpdart` or `dartz`) for robust error handling.

---

## 4. Performance Optimization Plan

### Phase 1: Quick Wins (Done/In Progress)
- [x] Fix Memory Leaks (`dispose` methods)
- [x] Optimize `setState` calls
- [ ] Add `const` to all static widgets (Global find/replace)
- [ ] Add `itemExtent` to `ListView`s in `QuranScreen` (Fixed height list items significantly boost scroll performance)

### Phase 2: Heavy Lifting
- [ ] **Implement FTS:** Switch `DatabaseHelper` to use FTS5 for instant search.
- [ ] **Isolates:** Move bulk DB inserts to `compute()`.

### Phase 3: Advanced
- [ ] **Image Caching:** Ensure `cached_network_image` is used if fetching images, with proper `memCacheHeight` to reduce memory usage.
- [ ] **Shader Warmup:** If animations jank on first run (iOS), implement SkSL warmup.

---

## 5. Memory Leak & Dispose Checklist

| Component | Location | Action | Status |
| :--- | :--- | :--- | :--- |
| `PrayerTimesCubit` | `HomeScreen` | Call `close()` in `dispose()` | ✅ |
| `Timer` (Debounce) | `SearchScreen` | Call `cancel()` in `dispose()` | ✅ (Inferred) |
| `ScrollController` | `SurahReaderScreen` | Call `dispose()` | ✅ (Inferred) |
| `AnimationController` | Various | Call `dispose()` | ⚠️ Check all |
| `StreamSubscription` | `DownloadDialog` | Cancel in `dispose()` | ✅ |

---

## 6. Top 10 Highest Impact Fixes (Remaining)

1.  **`lib/core/helpers/database_helper.dart`**: Implement `FTS5` virtual table for search.
2.  **`lib/features/quran/data/repos/quran_repo.dart`**: Wrap bulk inserts in `compute()`.
3.  **`lib/features/quran/ui/quran_screen.dart`**: Add `itemExtent: 80.h` to `SliverList` (if fixed height).
4.  **`lib/main.dart`**: Ensure `SystemChrome.setPreferredOrientations` is awaited.
5.  **`lib/core/di/dependency_injection.dart`**: Ensure `SharedPreferences` is registered as a singleton (it is).
6.  **Global**: Run `dart fix --apply` to resolve `const` warnings.
7.  **`lib/features/surah_reader/ui/surah_reader_screen.dart`**: Verify `Wakelock` is enabled/disabled properly (if used).
8.  **`lib/core/networking/api_service.dart`**: Add timeout to Dio requests (default is often infinite).
9.  **`lib/features/home/ui/widgets/prayer_times_widget.dart`**: Ensure timer (if any) is cancelled.
10. **`pubspec.yaml`**: Upgrade `flutter_bloc` and `provider` to latest versions if old.

---

## 7. Recommended Tests

### Unit Test: Database FTS
```dart
test('Search returns results in < 100ms', () async {
  final db = DatabaseHelper.instance;
  final stopwatch = Stopwatch()..start();
  final results = await db.searchAyahs('Musa');
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
  expect(results, isNotEmpty);
});
```

### Widget Test: Home Screen Memory
```dart
testWidgets('HomeScreen disposes resources', (tester) async {
  await tester.pumpWidget(createHomeScreen());
  await tester.pumpAndSettle();
  
  // Push replacement to trigger dispose
  await tester.pushReplacement(newRoute);
  await tester.pumpAndSettle();
  
  // Verify (via Mock) that cubit.close() was called
  verify(mockPrayerTimesCubit.close()).called(1);
});
```

---

## 8. CI/CD Recommendations

**File:** `.github/workflows/flutter_ci.yml` (Already created ✅)

Ensure the workflow includes:
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze --fatal-infos
      - run: flutter test --coverage
```
