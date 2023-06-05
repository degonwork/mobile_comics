import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/comic_detail/comic_detail_bloc.dart';
import 'package:full_comics_frontend/blocs/filter_comic_by_category/filter_comic_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_bloc.dart';
import 'package:full_comics_frontend/l10n/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/repository/device_repository.dart';
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
import 'blocs/case/case_bloc.dart';
import 'data/providers/firebase/notification/firebase_messaging_service.dart';
import 'data/providers/firebase/notification/local_notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FireBaseMessagingService.subscribeTopicOnFirebase();
    LocalNotificationService.initialize(
        context, flutterLocalNotificationsPlugin);
    FireBaseMessagingService.getMessage(
        channel, flutterLocalNotificationsPlugin);
    super.initState();
  }

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
          create: (context) => const CategoryRepo(
              apiClient: ApiClient(baseServerUrl: AppConstant.baseServerUrl)),
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
            apiClient:
                const ApiClient(baseServerUrl: AppConstant.baseServerUrl),
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
              create: (context) => ReadChapterBloc(
                    chapterRepo: context.read<ChapterRepo>(),
                  )),
          BlocProvider<FilterComicBloc>(
              create: (_) =>
                  FilterComicBloc(comicRepo: context.read<ComicRepo>())),
          BlocProvider<CaseBloc>(
            create: (context) => CaseBloc(
              comicRepo: context.read<ComicRepo>(),
            ),
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
