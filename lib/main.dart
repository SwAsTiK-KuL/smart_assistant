import 'package:bharatnxt_app/application/chat_bloc/chat_bloc.dart';
import 'package:bharatnxt_app/application/history/history_bloc.dart';
import 'package:bharatnxt_app/application/suggestion/suggestion_bloc.dart';
import 'package:bharatnxt_app/core/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bharatnxt_app/core/router/app_router.dart';
import 'package:bharatnxt_app/domain/repository/suggestion_repository.dart';
import 'package:bharatnxt_app/domain/repository/chat_repository.dart';
import 'package:bharatnxt_app/infrastructure/data_source/chat_remote_data_source.dart';
import 'package:bharatnxt_app/infrastructure/repository/sugeestion_repository.dart';
import 'package:bharatnxt_app/infrastructure/repository/chat_repository.dart';

import 'infrastructure/data_source/suggestions_remote_data_source.dart';

void main() {
  runApp(const BharatNxtApp());
}

class BharatNxtApp extends StatelessWidget {
  const BharatNxtApp({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestionDataSource = SuggestionsRemoteDataSourceMock();
    final chatDataSource = ChatRemoteDataSourceMock();

    final SuggestionsRepository suggestionsRepo = SuggestionsRepositoryImpl(
      suggestionDataSource,
    );

    final ChatRepository chatRepo = ChatRepositoryImpl(chatDataSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SuggestionsRepository>(
          create: (_) => suggestionsRepo,
        ),
        RepositoryProvider<ChatRepository>(create: (_) => chatRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SuggestionsBloc>(
            create: (ctx) => SuggestionsBloc(ctx.read<SuggestionsRepository>()),
          ),
          BlocProvider<ChatBloc>(
            create: (ctx) => ChatBloc(ctx.read<ChatRepository>()),
          ),
          BlocProvider<HistoryBloc>(
            create: (ctx) => HistoryBloc(ctx.read<ChatRepository>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'BharatNxt',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
