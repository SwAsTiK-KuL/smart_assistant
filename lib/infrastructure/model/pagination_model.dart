import 'package:bharatnxt_app/domain/entities/pagination_entites.dart';

class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      totalItems: json['total_items'] as int,
      limit: json['limit'] as int,
      hasNext: json['has_next'] as bool,
      hasPrevious: json['has_previous'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'total_pages': totalPages,
    'total_items': totalItems,
    'limit': limit,
    'has_next': hasNext,
    'has_previous': hasPrevious,
  };

  PaginationEntity toEntity() => PaginationEntity(
    currentPage: currentPage,
    totalPages: totalPages,
    totalItems: totalItems,
    limit: limit,
    hasNext: hasNext,
    hasPrevious: hasPrevious,
  );

  factory PaginationModel.fromEntity(PaginationEntity entity) {
    return PaginationModel(
      currentPage: entity.currentPage,
      totalPages: entity.totalPages,
      totalItems: entity.totalItems,
      limit: entity.limit,
      hasNext: entity.hasNext,
      hasPrevious: entity.hasPrevious,
    );
  }

  @override
  String toString() =>
      'PaginationModel(currentPage: $currentPage, totalPages: $totalPages, '
      'totalItems: $totalItems, limit: $limit, hasNext: $hasNext, '
      'hasPrevious: $hasPrevious)';
}
