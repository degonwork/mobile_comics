import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/ui/screens/library/widget/comic_filter_by_category.dart';
import 'package:full_comics_frontend/ui/screens/library/widget/filter_by_category.dart';
import 'package:full_comics_frontend/ui/screens/library/widget/search_screen.dart';
import 'package:full_comics_frontend/ui/widgets/back_ground_app.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          const BackGroundApp(),
          Container(
            padding: EdgeInsets.only(left: SizeConfig.screenWidth / 18),
            child: SingleChildScrollView(
              child: Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchScreen(),
                  SizedBox(height: SizeConfig.screenHeight / 75.6,),
                  const Text(
                    'Thể loại',style: TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 75.6,
                  ),
                  const FilterComicByCategory(),
                  SizedBox(height: SizeConfig.screenHeight / 50.4,),
                  const ComicByCategory(),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
