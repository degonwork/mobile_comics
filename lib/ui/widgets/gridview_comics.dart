import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_color.dart';
import '../../blocs/comic_detail/comic_detail_bloc.dart';
import '../../config/size_config.dart';
import '../../data/models/comic_model.dart';
import '../screens/detail/comic_detail_screen.dart';
import 'text_ui.dart';

class GridviewComics extends StatelessWidget {
  const GridviewComics({
    super.key,
    required this.listComics,
  });

  final List<Comic> listComics;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SingleChildScrollView(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listComics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: SizeConfig.width20,
            mainAxisSpacing: SizeConfig.height20,
            crossAxisCount: 2,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                context
                    .read<ComicDetailBloc>()
                    .add(LoadDetailComic(listComics[index].id));
                Navigator.pushNamed(context, ComicDetailScreen.routeName);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listComics[index].image_thumnail_square_path != null
                      ? Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                listComics[index].image_thumnail_square_path!,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.radius10,
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/anh splash.jpg"),
                          ),
                        )
                      : Image.asset("assets/images/anh splash.jpg"),
                  SizedBox(
                    height: SizeConfig.height10,
                  ),
                  TextUi(
                    text: listComics[index].title,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    fontSize: SizeConfig.font20,
                    color: AppColor.titleComicColor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
