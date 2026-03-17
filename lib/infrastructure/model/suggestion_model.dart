import 'package:bharatnxt_app/domain/entities/sugeestion_entities.dart';

class SuggestionModel {
  final int id;
  final String title;
  final String description;

  const SuggestionModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
  };

  SuggestionEntity toEntity() =>
      SuggestionEntity(id: id, title: title, description: description);

  factory SuggestionModel.fromEntity(SuggestionEntity entity) {
    return SuggestionModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
    );
  }

  SuggestionModel copyWith({int? id, String? title, String? description}) =>
      SuggestionModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  @override
  String toString() =>
      'SuggestionModel(id: $id, title: $title, description: $description)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionModel &&
          other.id == id &&
          other.title == title &&
          other.description == description;

  @override
  int get hashCode => Object.hash(id, title, description);
}
