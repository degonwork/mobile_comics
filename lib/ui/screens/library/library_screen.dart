import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/text_ui.dart';
import '../search_screen/search_screen.dart';
import 'widget/all_category.dart';
import 'widget/comic_filter_by_category.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackGroundApp(),
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.height45,
              left: SizeConfig.width15,
              right: SizeConfig.width15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppbar(
                    text: AppLocalizations.of(context)!.library,
                    iconRightWidget: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          SearchComicScreen.routeName,
                        ),
                        child: Icon(
                          Icons.search,
                          size: SizeConfig.icon25,
                          color: AppColor.iconAppbarColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height15),
                  TextUi(
                    text: AppLocalizations.of(context)!.genreComics,
                    fontSize: SizeConfig.font20,
                    color: AppColor.titleContentColor,
                  ),
                  SizedBox(height: SizeConfig.height15),
                  const AllCategory(),
                  SizedBox(height: SizeConfig.height15),
                  const ComicByCategory(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
