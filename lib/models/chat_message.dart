enum MessageRole { user, assistant }

class ChatMessage {
  final MessageRole role;
  final String content;
  final bool isPartial;

  ChatMessage(this.role, this.content, {this.isPartial = false});

  ChatMessage.user(String text)
    : this(MessageRole.user, text, isPartial: false);

  ChatMessage.assistant(String text, {bool isPartial = true})
    : this(MessageRole.assistant, text, isPartial: isPartial);

  Map<String, dynamic> toApiMap() => {
    'role': role == MessageRole.user ? 'user' : 'assistant',
    'content': content,
  };

  ChatMessage copyWith({String? content, bool? isPartial}) {
    return ChatMessage(
      role,
      content ?? this.content,
      isPartial: isPartial ?? this.isPartial,
    );
  }
}
