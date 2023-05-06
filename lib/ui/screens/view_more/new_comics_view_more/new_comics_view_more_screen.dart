import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_comics_frontend/blocs/view_more/view_more_bloc.dart';
import '../../../../config/size_config.dart';

class NewComicViewMoreScreen extends StatelessWidget {
  const NewComicViewMoreScreen({super.key});
  static const String routeName = '/new-comics-view-more';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Comics"),
        centerTitle: true,
      ),
      body: BlocBuilder<ViewMoreBloc, ViewMoreState>(
        builder: (context, state) {
          if (state is ViewMoreLoaded) {
            final listNewComicsViewMore = state.listNewComicsViewMore;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: listNewComicsViewMore.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 20,
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: SizeConfig.screenHeight / 3.78,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: listNewComicsViewMore[index]
                                .image_thumnail_square_path!,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height: SizeConfig.screenHeight / 4.2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(listNewComicsViewMore[index].title!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    );
                  }),
            );
          }
          return const Center(
            child: Icon(Icons.error),
          );
        },
      ),
    );
  }
}
