import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/case/case_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_bloc.dart';
import '../../../blocs/read_chapter/read_chapter_state.dart';
import '../../../config/size_config.dart';
import '../../../data/models/comic_model.dart';

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
  late ScrollController controller;
  bool visialbe = true;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        visialbe =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadChapterBloc, ReadChapterState>(
      builder: (context, state) {
        if (state is LoadedChapter) {
          final listImage = state.listImageContent;
          if (listImage.isNotEmpty) {
            return SafeArea(
              child: Scaffold(
                body: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          visialbe = !visialbe;
                        });
                      },
                      child: ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listImage.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: listImage[index].path,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/banner_splash.png"),
                          );
                        },
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: visialbe ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            if (widget.comic != null &&
                                widget.chapterId != null &&
                                widget.numericChapter != null) {
                              context.read<CaseBloc>().add(
                                    AddCaseComic(
                                      chapterId: widget.chapterId!,
                                      comicId: widget.comic!.id,
                                      imageThumnailSquareComicPath: widget
                                          .comic!.image_thumnail_square_path!,
                                      numericChapter: widget.numericChapter!,
                                      titleComic: widget.comic!.title!,
                                      reads: widget.comic!.reads!,
                                    ),
                                  );
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_circle_left,
                            size: 50,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const Text(
          "Chapter has not content",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        );
      },
    );
  }
}
