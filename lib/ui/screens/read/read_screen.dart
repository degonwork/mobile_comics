import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/read_chapter/read_chapter_event.dart';

import 'package:full_comics_frontend/config/app_color.dart';
import 'package:full_comics_frontend/ui/widgets/build_ads_banner.dart';

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
          Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width20),
              child: const BannerAD()),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height50),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  visialbe = !visialbe;
                });
              },
              child: BlocBuilder<ReadChapterBloc, ReadChapterState>(
                builder: (context, state) {
                  if (state is LoadingChapter) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.disable),
                    );
                  } else if (state is LoadedChapter) {
                    final listImage = state.listImageContent;
                    // print(
                    // '${state.currentNumeric} -----------------------------+++++++++++++++++++++++++++++++++++++++++++++');
                    if (listImage.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listImage.length,
                              itemBuilder: (context, index) {
                                return listImage[index].height != null &&
                                        listImage[index].width != null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.width10,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: listImage[index].path,
                                          imageBuilder:
                                              (context, imageProvider) {
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
                                    : Image.asset(
                                        "assets/images/banner_splash.png");
                              },
                            ),
                            BlocBuilder<ReadChapterBloc, ReadChapterState>(
                              builder: (context, state) {
                                if (state is LoadedChapter) {
                                  if (widget.numericChapter != null) {
                                    return TextButton(
                                        onPressed: () {
                                          // if (state.currentNumeric != 0) {
                                          context.read<ReadChapterBloc>().add(
                                              LoadChapter(widget.comic!.id));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ReadScreen(
                                                        numericChapter: widget
                                                            .numericChapter,
                                                        chapterId:
                                                            widget.chapterId,
                                                      )));
                                          // }
                                          // context.read<ReadChapterBloc>().add(LoadNextChapter(widget.comic!.id, widget.numericChapter!));
                                          print(
                                              '${widget.numericChapter} -----------------------------------------------------------------------------------');
                                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>  ReadScreen(numericChapter: widget.numericChapter,chapterId: widget.chapterId,)));
                                        },
                                        child: const Text(
                                          "Đọc chương kế tiếp",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ));
                                  }
                                } else {
                                  return const Text("Chưa có chương mới");
                                }
                                return const Text("data");
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: AppColor.disable),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.disable),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.height50),
            child: AnimatedOpacity(
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
          ),
        ],
      ),
    );
  }
}
