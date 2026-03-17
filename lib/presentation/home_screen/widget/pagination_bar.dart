import 'package:bharatnxt_app/application/suggestion/suggestion_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bharatnxt_app/domain/entities/pagination_entites.dart';

class PaginationBar extends StatelessWidget {
  final PaginationEntity pagination;
  const PaginationBar({super.key, required this.pagination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bloc = context.read<SuggestionsBloc>();
    final pages = _pageNumbers(pagination);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavBtn(
            icon: Icons.chevron_left_rounded,
            enabled: pagination.hasPrevious,
            onTap: () => bloc.add(const PreviousPageEvent()),
            tooltip: 'Previous',
          ),
          const SizedBox(width: 8),
          ...pages.map((p) {
            if (p == -1) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              );
            }
            final isActive = p == pagination.currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: isActive ? null : () => bloc.add(GoToPageEvent(p)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$p',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isActive ? Colors.white : colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          _NavBtn(
            icon: Icons.chevron_right_rounded,
            enabled: pagination.hasNext,
            onTap: () => bloc.add(const NextPageEvent()),
            tooltip: 'Next',
          ),
        ],
      ),
    );
  }

  List<int> _pageNumbers(PaginationEntity p) {
    final total = p.totalPages;
    final current = p.currentPage;
    if (total <= 5) return List.generate(total, (i) => i + 1);

    if (current <= 3) return [1, 2, 3, 4, -1, total];
    if (current >= total - 2)
      return [1, -1, total - 3, total - 2, total - 1, total];
    return [1, -1, current - 1, current, current + 1, -1, total];
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final String tooltip;

  const _NavBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color:
                enabled
                    ? colorScheme.primary.withOpacity(0.1)
                    : colorScheme.onSurface.withOpacity(0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  enabled
                      ? colorScheme.primary.withOpacity(0.2)
                      : colorScheme.outlineVariant.withOpacity(0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color:
                enabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}
