import 'package:flutter/material.dart';
import 'package:full_comics_frontend/config/app_constant.dart';
import 'package:full_comics_frontend/data/models/case_comic_model.dart';
import '../../../../data/models/comic_model.dart';
import '../../../screens/detail/widgets/read_button.dart';
import '../../../../config/size_config.dart';

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
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              height: SizeConfig.screenHeight / 15.12,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth / 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.remove_red_eye),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Đã đọc'),
                              Text(
                                comic.reads != null ? '${comic.reads}' : "",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 36),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 15,
                              child: Icon(Icons.favorite)),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Đánh giá'),
                              Row(
                                children: [
                                  Text('1.1K'),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amberAccent,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth / 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.library_books),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Chương'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thể loại',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  comic.categories![index],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
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
            Container(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tóm tắt',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 75.6,
                  ),
                  Text(
                    comic.description != null ? comic.description! : "",
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight / 25.2),
            _loadReadButton(),
          ],
        ),
      ),
    );
  }

  Widget _loadReadButton() {
    if (comic.chapters!.isNotEmpty) {
      if (caseComic != AppConstant.CASECOMICNOTEXIST) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReadButton(
              id: comic.chapters!.first.id,
              comic: comic,
              numericChapter: 1,
              color: Colors.orangeAccent,
              title: "Đọc từ đầu",
            ),
            ReadButton(
              id: caseComic.chapterId,
              comic: comic,
              numericChapter: caseComic.numericChapter,
              color: Colors.orangeAccent,
              title: "Đọc tiếp",
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
            title: "Đọc truyện",
          ),
        );
      }
    } else {
      return const ReadButton(title: "Đọc truyện ", color: Colors.grey);
    }
  }
}
