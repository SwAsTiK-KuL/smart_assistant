import 'package:bharatnxt_app/application/history/history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';
import 'package:bharatnxt_app/presentation/home_screen/widget/shimmer_card.dart';
import 'package:bharatnxt_app/core/router/app_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chat History',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Previous conversations',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed:
                  () =>
                      context.read<HistoryBloc>().add(const LoadHistoryEvent()),
              icon: Icon(
                Icons.refresh_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder:
            (context, state) => switch (state) {
              HistoryInitial() || HistoryLoading() => _buildSkeleton(),
              HistoryLoaded() => _buildLoaded(context, state.messages),
              HistoryError() => _buildError(context, state.message),
              _ => const SizedBox.shrink(),
            },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRouter.chat),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Chat'),
        elevation: 2,
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, List<ChatMessageEntity> messages) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (messages.isEmpty) return _buildEmpty(context);

    final turns = <_Turn>[];
    for (int i = 0; i < messages.length; i += 2) {
      turns.add(
        _Turn(
          user: messages[i],
          assistant: i + 1 < messages.length ? messages[i + 1] : null,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: turns.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${turns.length} conversation${turns.length != 1 ? "s" : ""}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return _TurnCard(turn: turns[index - 1]);
      },
    );
  }

  Widget _buildSkeleton() => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: 5,
    itemBuilder:
        (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerCard(height: 110, delay: i * 120),
        ),
  );

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: colorScheme.primary.withOpacity(0.25),
          ),
          const SizedBox(height: 20),
          Text('No history yet', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Start a conversation to see it here',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRouter.chat),
            icon: const Icon(Icons.chat_rounded, size: 16),
            label: const Text('Start Chatting'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load history',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () =>
                      context.read<HistoryBloc>().add(const LoadHistoryEvent()),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Turn {
  final ChatMessageEntity user;
  final ChatMessageEntity? assistant;
  const _Turn({required this.user, this.assistant});
}

class _TurnCard extends StatelessWidget {
  final _Turn turn;
  const _TurnCard({required this.turn});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          _MsgRow(
            message: turn.user.message,
            icon: Icons.person_rounded,
            iconColor: colorScheme.primary,
            label: 'You',
          ),
          if (turn.assistant != null) ...[
            Divider(
              height: 1,
              indent: 14,
              endIndent: 14,
              color: colorScheme.outlineVariant.withOpacity(0.3),
            ),
            _MsgRow(
              message: turn.assistant!.message,
              icon: Icons.smart_toy_rounded,
              iconColor: colorScheme.secondary,
              label: 'Assistant',
            ),
          ],
        ],
      ),
    );
  }
}

class _MsgRow extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final String label;

  const _MsgRow({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
