import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  const Pagination({super.key, required this.currentPage, required this.totalPages, required this.onPageChanged});

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  List<int> _pages() {
    const int maxVisible = 5;
    final int half = maxVisible ~/ 2;
    int start = (currentPage - half).clamp(1, totalPages);
    int end = (start + maxVisible - 1).clamp(1, totalPages);
    if (end - start + 1 < maxVisible) {
      start = (end - maxVisible + 1).clamp(1, totalPages);
    }
    return List<int>.generate(end - start + 1, (i) => start + i);
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    ButtonStyle style({bool active = false}) => TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          backgroundColor: active ? const Color(0xFFE04E39) : Theme.of(context).colorScheme.surface,
          foregroundColor: active ? Colors.white : Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          TextButton(onPressed: currentPage == 1 ? null : () => onPageChanged(1), style: style(), child: const Text('«')),
          TextButton(onPressed: currentPage == 1 ? null : () => onPageChanged(currentPage - 1), style: style(), child: const Text('‹')),
          ..._pages().map((p) => TextButton(onPressed: p == currentPage ? null : () => onPageChanged(p), style: style(active: p == currentPage), child: Text('$p'))),
          TextButton(onPressed: currentPage == totalPages ? null : () => onPageChanged(currentPage + 1), style: style(), child: const Text('›')),
          TextButton(onPressed: currentPage == totalPages ? null : () => onPageChanged(totalPages), style: style(), child: const Text('»')),
        ],
      ),
    );
  }
}

