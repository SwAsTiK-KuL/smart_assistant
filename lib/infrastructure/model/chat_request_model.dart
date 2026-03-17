class ChatRequestModel {
  final String message;

  const ChatRequestModel({required this.message});

  Map<String, dynamic> toJson() => {'message': message};

  @override
  String toString() => 'ChatRequestModel(message: "$message")';
}
