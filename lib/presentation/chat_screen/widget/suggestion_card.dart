import 'package:flutter/material.dart';
import 'package:bharatnxt_app/domain/entities/sugeestion_entities.dart';

const List<Map<String, dynamic>> _iconThemes = [
  {'icon': Icons.auto_awesome_rounded, 'color': Color(0xFF6C63FF)},
  {'icon': Icons.email_rounded, 'color': Color(0xFF00D4AA)},
  {'icon': Icons.school_rounded, 'color': Color(0xFFFF6B6B)},
  {'icon': Icons.work_rounded, 'color': Color(0xFFFFBE0B)},
  {'icon': Icons.code_rounded, 'color': Color(0xFF4CAF50)},
  {'icon': Icons.translate_rounded, 'color': Color(0xFF2196F3)},
  {'icon': Icons.checklist_rounded, 'color': Color(0xFFFF9800)},
  {'icon': Icons.sentiment_satisfied_alt_rounded, 'color': Color(0xFFE91E63)},
  {'icon': Icons.lightbulb_rounded, 'color': Color(0xFF9C27B0)},
  {'icon': Icons.spellcheck_rounded, 'color': Color(0xFF00BCD4)},
];

class SuggestionCard extends StatelessWidget {
  final SuggestionEntity suggestion;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeData = _iconThemes[suggestion.id % _iconThemes.length];
    final iconColor = themeData['color'] as Color;
    final iconData = themeData['icon'] as IconData;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: iconColor, size: 20),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: colorScheme.primary,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                suggestion.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                suggestion.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.55),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
