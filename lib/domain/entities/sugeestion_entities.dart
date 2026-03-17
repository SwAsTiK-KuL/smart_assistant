import 'package:equatable/equatable.dart';

class SuggestionEntity extends Equatable {
  final int id;
  final String title;
  final String description;

  const SuggestionEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];

  @override
  String toString() =>
      'SuggestionEntity(id: $id, title: $title, description: $description)';
}
