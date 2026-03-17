import 'package:bharatnxt_app/application/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bharatnxt_app/presentation/chat_screen/widget/message_bubble.dart';
import 'package:bharatnxt_app/presentation/chat_screen/widget/typing_indicator.dart';
import 'package:bharatnxt_app/presentation/chat_screen/widget/chat_input.dart';
import 'package:bharatnxt_app/core/router/app_router.dart';

class ChatScreen extends StatefulWidget {
  final String? prefilledMessage;
  const ChatScreen({super.key, this.prefilledMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.prefilledMessage != null) {
      _textController.text = widget.prefilledMessage!;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<ChatBloc>().add(SendMessageEvent(text));
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assistant',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00D4AA),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF00D4AA),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.go(AppRouter.history),
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Chat history',
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final hasMessages =
                  state is ChatMessagesUpdated && state.messages.isNotEmpty;
              if (!hasMessages) return const SizedBox.shrink();
              return IconButton(
                onPressed: () => _confirmClear(context),
                icon: const Icon(Icons.delete_sweep_rounded),
                tooltip: 'Clear chat',
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatMessagesUpdated) _scrollToBottom();
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) return _buildEmptyState(context);

                final messages = switch (state) {
                  ChatMessagesUpdated(messages: final m) => m,
                  ChatError(messages: final m) => m,
                  _ => [],
                };

                final isTyping = state is ChatMessagesUpdated && state.isTyping;

                if (messages.isEmpty) return _buildEmptyState(context);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isTyping && index == messages.length) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TypingIndicator(),
                      );
                    }
                    return MessageBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final isTyping = state is ChatMessagesUpdated && state.isTyping;
              return ChatInput(
                controller: _textController,
                onSend: _send,
                disabled: isTyping,
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Clear Chat?'),
            content: const Text(
              'This will remove all messages in the current session.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<ChatBloc>().add(const ClearChatEvent());
                },
                child: Text(
                  'Clear',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.2),
                    colorScheme.secondary.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Start a conversation',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask me anything — I\'m here to help\nyou with tasks, ideas, and more.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                        'Explain Flutter BLoC',
                        'Write an email',
                        'Plan my day',
                        'Debug my code',
                      ]
                      .map(
                        (prompt) => GestureDetector(
                          onTap: () {
                            _textController.text = prompt;
                            _send();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              prompt,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
