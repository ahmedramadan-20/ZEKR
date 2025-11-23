import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/shared_pref_helper.dart';

class SearchHistoryList extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onTap;
  final VoidCallback onClear;
  final ValueChanged<String> onRemove;

  const SearchHistoryList({
    super.key,
    required this.items,
    required this.onTap,
    required this.onClear,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          child: Row(
            children: [
              Text(
                'عمليات البحث الأخيرة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontFamily: 'Amiri',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClear,
                child: const Text('مسح الكل'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final q = items[index];
              return Dismissible(
                key: ValueKey('hist_$q'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  color: Theme.of(context).colorScheme.error.withOpacity(0.08),
                  child: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                ),
                onDismissed: (_) async {
                  await getIt<SharedPrefHelper>().removeSearchHistoryItem(q);
                  onRemove(q);
                },
                child: ListTile(
                  title: Text(q, style: Theme.of(context).textTheme.bodyLarge),
                  leading: const Icon(Icons.history),
                  onTap: () => onTap(q),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
