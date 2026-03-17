import 'package:bharatnxt_app/application/suggestion/suggestion_bloc.dart';
import 'package:bharatnxt_app/presentation/chat_screen/widget/suggestion_card.dart';
import 'package:bharatnxt_app/presentation/home_screen/widget/pagination_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bharatnxt_app/presentation/home_screen/widget/shimmer_card.dart';
import 'package:bharatnxt_app/core/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SuggestionsBloc>().add(const LoadSuggestionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;
    final isDesktop = width >= 900;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart Assistant',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'What can I help you with today?',
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
                  () => context.read<SuggestionsBloc>().add(
                    const LoadSuggestionsEvent(),
                  ),
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
      body: BlocBuilder<SuggestionsBloc, SuggestionsState>(
        builder: (context, state) {
          return switch (state) {
            SuggestionsInitial() ||
            SuggestionsLoading() => _buildShimmer(isTablet, isDesktop),
            SuggestionsLoaded() => _buildLoaded(
              context,
              state,
              isTablet,
              isDesktop,
            ),
            SuggestionsError() => _buildError(context, state.message),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    SuggestionsLoaded state,
    bool isTablet,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final crossAxisCount =
        isDesktop
            ? 3
            : isTablet
            ? 2
            : 1;

    return Column(
      children: [
        // Stats badge
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '${state.pagination.totalItems} suggestions available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  state.pagination.pageLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio:
                  isDesktop
                      ? 1.3
                      : isTablet
                      ? 1.2
                      : 2.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.suggestions.length,
            itemBuilder:
                (context, i) => SuggestionCard(
                  suggestion: state.suggestions[i],
                  onTap:
                      () => context.go(
                        AppRouter.chat,
                        extra: {'message': state.suggestions[i].title},
                      ),
                ),
          ),
        ),

        // Pagination
        PaginationBar(pagination: state.pagination),
      ],
    );
  }

  Widget _buildShimmer(bool isTablet, bool isDesktop) {
    final crossAxisCount =
        isDesktop
            ? 3
            : isTablet
            ? 2
            : 1;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio:
            isDesktop
                ? 1.3
                : isTablet
                ? 1.2
                : 2.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => const ShimmerCard(),
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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: colorScheme.error,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
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
                  () => context.read<SuggestionsBloc>().add(
                    const LoadSuggestionsEvent(),
                  ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
