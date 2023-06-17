import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:full_comics_frontend/config/size_config.dart';
import 'package:full_comics_frontend/config/ui_constant.dart';
import '../../../../blocs/case/case_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Reading extends StatelessWidget {
  const Reading({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseBloc, CaseState>(
      builder: (context, state) {
        if (state is CaseLoaded) {
          final listCaseComic = state.listCaseComic;
          if (listCaseComic.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: listCaseComic.length,
                itemBuilder: (context, int index) {
                  return SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        listCaseComic[index].imageThumnailSquareComicPath !=
                                null
                            ? InkWell(
                              onTap: (){
                               context.read<CaseBloc>().add(const LoadCaseComic());
                              },
                              child: CachedNetworkImage(
                                  imageUrl: listCaseComic[index]
                                      .imageThumnailSquareComicPath!,
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      width: SizeConfig.screenWidth / 3.6,
                                      height: SizeConfig.screenHeight / 7.56,
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
                                      Image.asset(
                                          "assets/images/banner_splash.png"),
                                ),
                            )
                            : Image.asset("assets/images/banner_splash.png"),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listCaseComic[index].titleComic != null
                                            ? listCaseComic[index].titleComic!
                                            : "",
                                        style: titleComic,    
                                        // style: const TextStyle(
                                        //   color: Colors.black,
                                        //   fontSize: 20,
                                        //   fontWeight: FontWeight.bold,
                                        // ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${listCaseComic[index].reads ?? ""} ${AppLocalizations.of(context)!.reads}",
                                        style: const  TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(thickness: 0.8,),
                              // const SizedBox(
                              //   height: 10,
                              //   width: double.infinity,
                              //   child: DottedLine(
                              //     dashColor: Colors.black,
                              //   ),
                              // ),
                              Text(
                                "${AppLocalizations.of(context)!.reading}: Chương ${listCaseComic[index].numericChapter}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.green,
                  thickness: 0.5,
                ),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            "Danh sách trống ",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }
}
