import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool disabled;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.disabled = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onTextChange() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: !widget.disabled,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    widget.disabled
                        ? 'Assistant is typing...'
                        : 'Message Assistant...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: colorScheme.primary.withOpacity(0.6),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  (_hasText && !widget.disabled)
                      ? colorScheme.primary
                      : colorScheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: (_hasText && !widget.disabled) ? widget.onSend : null,
              icon:
                  widget.disabled
                      ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      )
                      : Icon(
                        Icons.send_rounded,
                        size: 18,
                        color:
                            (_hasText && !widget.disabled)
                                ? Colors.white
                                : colorScheme.primary.withOpacity(0.4),
                      ),
              tooltip: 'Send',
            ),
          ),
        ],
      ),
    );
  }
}
