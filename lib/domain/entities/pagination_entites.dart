import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationEntity({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.limit,
    required this.hasNext,
    required this.hasPrevious,
  });

  bool get isFirstPage => currentPage == 1;

  bool get isLastPage => currentPage == totalPages;

  String get pageLabel => 'Page $currentPage of $totalPages';

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    totalItems,
    limit,
    hasNext,
    hasPrevious,
  ];

  @override
  String toString() =>
      'PaginationEntity(currentPage: $currentPage, totalPages: $totalPages, '
      'totalItems: $totalItems, limit: $limit, hasNext: $hasNext, '
      'hasPrevious: $hasPrevious)';
}
