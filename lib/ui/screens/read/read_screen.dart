import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/case/case_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_state.dart';
import '../../../config/size_config.dart';
import '../../../data/models/comic_model.dart';
import '../../widgets/back_button_screen.dart';
import '../detail/comic_detail_screen.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({
    super.key,
    this.chapterId,
    this.comic,
    this.numericChapter,
  });
  final String? chapterId;
  final Comic? comic;
  final int? numericChapter;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  bool visialbe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                visialbe = !visialbe;
              });
            },
            child: BlocBuilder<ReadChapterBloc, ReadChapterState>(
              builder: (context, state) {
                if (state is LoadingChapter) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                } else if (state is LoadedChapter) {
                  final listImage = state.listImageContent;
                  if (listImage.isNotEmpty) {
                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: listImage.length,
                      itemBuilder: (context, index) {
                        return listImage[index].height != null &&
                                listImage[index].width != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.width8,
                                ),
                                margin: index == listImage.length - 1
                                    ? EdgeInsets.only(
                                        bottom: SizeConfig.height20)
                                    : const EdgeInsets.only(bottom: 0),
                                child: CachedNetworkImage(
                                  imageUrl: listImage[index].path,
                                  imageBuilder: (context, imageProvider) {
                                    return SizedBox(
                                      width: SizeConfig.screenWidth,
                                      height: SizeConfig.screenWidth *
                                          (listImage[index].width! /
                                              listImage[index].height!),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/banner_splash.png"),
                                ),
                              )
                            : Image.asset("assets/images/banner_splash.png");
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: SizeConfig.height8,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              },
            ),
          ),
          AnimatedOpacity(
            opacity: visialbe ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: BackButtonScreen(
              onTap: () {
                if (widget.comic != null &&
                    widget.chapterId != null &&
                    widget.numericChapter != null) {
                  context.read<CaseBloc>().add(
                        AddCaseComic(
                          chapterId: widget.chapterId!,
                          comicId: widget.comic!.id,
                          imageThumnailSquareComicPath:
                              widget.comic!.image_thumnail_square_path!,
                          numericChapter: widget.numericChapter!,
                          titleComic: widget.comic!.title!,
                          reads: widget.comic!.reads!,
                        ),
                      );
                }
                Navigator.pushNamed(context, ComicDetailScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
