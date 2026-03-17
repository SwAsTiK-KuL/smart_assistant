import 'package:bharatnxt_app/domain/entities/suggestion_page_entites.dart';
import 'package:bharatnxt_app/infrastructure/model/pagination_model.dart';

import 'suggestion_model.dart';

class SuggestionsResponseModel {
  final String status;
  final List<SuggestionModel> data;
  final PaginationModel pagination;

  const SuggestionsResponseModel({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory SuggestionsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>;
    return SuggestionsResponseModel(
      status: json['status'] as String,
      data:
          rawList
              .map(
                (item) =>
                    SuggestionModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((m) => m.toJson()).toList(),
    'pagination': pagination.toJson(),
  };

  SuggestionsPageEntity toEntity() => SuggestionsPageEntity(
    suggestions: data.map((m) => m.toEntity()).toList(),
    pagination: pagination.toEntity(),
  );

  bool get isSuccess => status == 'success';

  @override
  String toString() =>
      'SuggestionsResponseModel(status: $status, count: ${data.length}, pagination: $pagination)';
}
