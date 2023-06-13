import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/models/case_comic_model.dart';
import 'package:full_comics_frontend/ui/screens/detail/screens/read_button.dart';
import 'package:full_comics_frontend/ui/screens/detail/widgets/descreption.dart';


import '../../../../data/models/comic_model.dart';
import '../../../../config/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Infor extends StatelessWidget {
  const Infor({super.key, required this.comic, required this.caseComic});
  final Comic comic;
  final CaseComic caseComic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              height: SizeConfig.screenHeight / 15.12,
              child: Row(
                children: [
                  Expanded(
                    flex: 42,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                            spreadRadius: 0.5,
                            // offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth / 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            
                            radius: 15,
                            child: Icon(Icons.remove_red_eye),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.numberReads),
                              Text(
                                comic.reads != null ? '${comic.reads}' : "",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 42,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                            spreadRadius: 0.5,
                            // offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 36),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                              // backgroundColor: Colors.white,
                              radius: 12,
                              child: Icon(Icons.star,color: Colors.white,)),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Đánh giá'),
                              Text('1.1K'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 42,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0.1,
                            spreadRadius: 0.5,
                            // offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            // backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.library_books),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.totalChapters),
                              comic.chapters!.isNotEmpty
                                  ? Text('${comic.chapters!.length}')
                                  : const Text(""),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Container(
              padding: EdgeInsets.zero,
              height: SizeConfig.screenHeight / 10,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.genreComics,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 80,
                  ),
                  Expanded(
                    child: comic.categories!.isNotEmpty
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screenWidth / 50,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withBlue(50),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  comic.categories![index],
                                  style:   TextStyle(
                                      color: Colors.blue.withGreen(50).withOpacity(0.8), fontSize: 18),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemCount: comic.categories!.length,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight / 40),
            const Divider(thickness: 1),
            Text(
              AppLocalizations.of(context)!.describe,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: SizeConfig.screenHeight / 75.6,
            ),
            Descreption(
              maxLines: 2,
              text: comic.description != null ? comic.description! : "",
               ),
            // Text(
            //   comic.description != null ? comic.description! : "",
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),
            SizedBox(height: SizeConfig.screenHeight / 25.2),
            _loadReadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loadReadButton(BuildContext context) {
    if (comic.chapters!.isNotEmpty) {
      if (caseComic != AppConstant.caseComicNotExist) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReadButton(
              id: comic.chapters!.first.id,
              comic: comic,
              numericChapter: 1,
              color: Colors.orangeAccent,
              title: AppLocalizations.of(context)!.readFirstChapter,
            ),
            ReadButton(
              id: caseComic.chapterId,
              comic: comic,
              numericChapter: caseComic.numericChapter,
              color: Colors.orangeAccent,
              title: AppLocalizations.of(context)!.continueReading,
            ),
          ],
        );
      } else {
        return Center(
          child: ReadButton(
            id: comic.chapters!.first.id,
            comic: comic,
            numericChapter: 1,
            color: Colors.orangeAccent,
            title: AppLocalizations.of(context)!.readComics,
          ),
        );
      }
    } else {
      return ReadButton(
          title: AppLocalizations.of(context)!.readComics, color: Colors.grey);
    }
  }
}
