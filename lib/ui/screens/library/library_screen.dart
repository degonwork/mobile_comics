import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../config/app_color.dart';
import '../../../config/size_config.dart';
import '../../widgets/back_ground_app.dart';
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
                  TextField(
                    textAlign: TextAlign.start,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchComicScreen()));
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          AppColor.unSelectItemGenreComicolor.withOpacity(0.9),
                      hintText: AppLocalizations.of(context)!.search,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
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
