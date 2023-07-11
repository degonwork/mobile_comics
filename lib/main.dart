import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/ui/screens/router/router_screen.dart';
import '../data/repository/device_repository.dart';
import '../data/repository/chapter_repository.dart';
import '../data/repository/image_repository.dart';
import '../data/providers/api/api_client.dart';
import '../config/app_constant.dart';
import '../data/repository/comic_repository.dart';
import '../config/app_router.dart';
import '../blocs/view_more/view_more_bloc.dart';
import '../data/repository/categories_comics_repository.dart';
import '../data/repository/category_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'blocs/ads/ads_bloc.dart';
import 'blocs/bottom_navbar/bottom_navbar_bloc.dart';
import 'blocs/case/case_bloc.dart';
import 'blocs/comic_detail/comic_detail_bloc.dart';
import 'blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'blocs/filter_comic_by_category/filter_comic_event.dart';
import 'blocs/get_all_category/get_all_category_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/read_chapter/read_chapter_bloc.dart';
import 'blocs/search_comic/search_comic_bloc.dart';
import 'config/size_config.dart';
import 'l10n/l10n.dart';

Future<void> main() async {
  await Future.delayed(const Duration(milliseconds: 1000));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>(
          create: (context) =>
              const ApiClient(baseServerUrl: AppConstant.baseServerUrl),
        ),
        RepositoryProvider<ImageRepo>(
          create: (context) => ImageRepo(apiClient: context.read<ApiClient>()),
        ),
        RepositoryProvider<CategoryRepo>(
          create: (context) => const CategoryRepo(
            apiClient: ApiClient(baseServerUrl: AppConstant.baseServerUrl),
          ),
        ),
        RepositoryProvider<CategoriesComicsRepo>(
          create: (context) => CategoriesComicsRepo(
            categoryRepo: context.read<CategoryRepo>(),
          ),
        ),
        RepositoryProvider<ChapterRepo>(
          create: (context) => ChapterRepo(
            imageRepo: context.read<ImageRepo>(),
            chapterUrl: AppConstant.chapterUrl,
            apiClient: const ApiClient(
              baseServerUrl: AppConstant.baseServerUrl,
            ),
          ),
        ),
        RepositoryProvider<ComicRepo>(
          create: (context) => ComicRepo(
            apiClient: context.read<ApiClient>(),
            imageRepo: context.read<ImageRepo>(),
            chapterRepo: context.read<ChapterRepo>(),
            categoriesComicsRepo: context.read<CategoriesComicsRepo>(),
            comicUrl: AppConstant.comicUrl,
          ),
        ),
        RepositoryProvider<DeviceRepo>(
          create: (context) => DeviceRepo(
            apiClient: context.read<ApiClient>(),
            deviceUrl: AppConstant.deviceUrl,
          ),
        ),
        RepositoryProvider<CategoryRepo>(
          create: (context) => CategoryRepo(
            apiClient: context.read<ApiClient>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavbarBloc>(
            create: (context) => BottomNavbarBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(comicRepo: context.read<ComicRepo>())
              ..add(LoadHomeComic()),
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
              create: (context) => ReadChapterBloc(
                    chapterRepo: context.read<ChapterRepo>(),
                  )),
          BlocProvider<CaseBloc>(
            create: (context) => CaseBloc(
              comicRepo: context.read<ComicRepo>(),
            ),
          ),
          BlocProvider<GetAllCategoryBloc>(
            create: (context) => GetAllCategoryBloc(
              context.read<CategoryRepo>(),
            ),
          ),
          BlocProvider<FilterComicBloc>(
            create: (context) => FilterComicBloc(
              comicRepo: context.read<ComicRepo>(),
              categoryRepo: context.read<CategoryRepo>(),
            )..add(FilterComicStart()),
          ),
          BlocProvider<SearchComicBloc>(
            create: (context) => SearchComicBloc(
              comicRepo: context.read<ComicRepo>(),
            ),
          ),
          BlocProvider(
            create: (context) => AdsBloc()..add(LoadAds()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: ThemeData(
            fontFamily: "Raleway",
          ),
          title: 'Làng Truyện',
          initialRoute: RouterScreen.routeName,
          routes: AppRouter.routes,
        ),
      ),
    );
  }
}
