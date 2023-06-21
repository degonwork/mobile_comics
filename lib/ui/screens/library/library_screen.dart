import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/ui/screens/library/widget/comic_filter_by_category.dart';
import 'package:full_comics_frontend/ui/screens/library/widget/all_category.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/ui/widgets/custom_appbar.dart';

import '../../widgets/text_ui.dart';
import '../search_screen/search_screen.dart';

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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchComicScreen(),
                          ),
                        ),
                        child: Icon(
                          Icons.search,
                          size: SizeConfig.width25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height15),
                  TextUi(
                    text: AppLocalizations.of(context)!.genreComics,
                    fontSize: SizeConfig.font20,
                    fontWeight: FontWeight.w500,
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
