import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_bloc.dart';
import 'package:full_comics_frontend/data/models/chapter_model.dart';
import '../blocs/home/home_bloc.dart';
import '../data/repository/chapter_repository.dart';
import '../data/repository/image_repository.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../data/providers/api/api_client.dart';
import '../config/app_constant.dart';
import '../data/repository/comic_repository.dart';
import '../blocs/bottom_navbar_bloc/bottom_navbar_bloc.dart';
import '../config/app_router.dart';
import '../blocs/view_more/view_more_bloc.dart';
import '../data/repository/categories_comics_repository.dart';
import '../data/repository/category_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (context) =>
              const ApiClient(baseServerUrl: AppConstant.baseServerUrl),
        ),
        RepositoryProvider<ImageRepo>(
          create: (context) => ImageRepo(),
        ),
        RepositoryProvider<CategoryRepo>(
          create: (context) => CategoryRepo(),
        ),
        RepositoryProvider<CategoriesComicsRepo>(
          create: (context) => CategoriesComicsRepo(
            categoryRepo: context.read<CategoryRepo>(),
          ),
        ),
        RepositoryProvider<ChapterRepo>(
          create: (context) => ChapterRepo(
            imageRepo: context.read<ImageRepo>(),
            chapterUrl: AppConstant.CHAPTERURL,apiClient:const ApiClient(baseServerUrl: AppConstant.baseServerUrl),
          ),
        ),
        RepositoryProvider<ComicRepo>(
          create: (context) => ComicRepo(
            apiClient: context.read<ApiClient>(),
            imageRepo: context.read<ImageRepo>(),
            chapterRepo: context.read<ChapterRepo>(),
            categoriesComicsRepo: context.read<CategoriesComicsRepo>(),
            comicUrl: AppConstant.COMICURL,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavbarBloc>(
            create: (context) => BottomNavbarBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              comicRepo: context.read<ComicRepo>(),
            )..add(LoadHomeComic()),
          ),
          BlocProvider<ViewMoreBloc>(
            create: (context) => ViewMoreBloc(
              comicRepo: context.read<ComicRepo>(),
            ),
          ),
          BlocProvider<ComicDetailBloc>(
            create: (context) => ComicDetailBloc(
              comicRepo: context.read<ComicRepo>(),
            ),
          ),
          BlocProvider<ReadChapterBloc>(
            create: (context) => ReadChapterBloc(chapterRepo: context.read<ChapterRepo>(),
            ))
        ],

        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: SplashScreen.routeName,
          routes: AppRouter.routes,
        ),
      ),
    );
  }
}
