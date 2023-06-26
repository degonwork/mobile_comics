// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:full_comics_frontend/config/app_color.dart';
// import '../../../../config/app_constant.dart';
// import '../../../widgets/read_button.dart';

// class LoadReabutton extends StatelessWidget {
//   const LoadReabutton(
//       {super.key, });
//   // final Comic? comic;
//   // final CaseComic? caseComic;
//   @override
//   Widget build(BuildContext context) {
//     if (comic!.chapters.isNotEmpty) {
//       if (caseComic != AppConstant.caseComicNotExist) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ReadButton(
//               id: comic.chapters!.first.id,
//               comic: comic,
//               numericChapter: 1,
//               color: AppColor.backGroundButtonColor,
//               title: AppLocalizations.of(context)!.readFirstChapter,
//             ),
//             ReadButton(
//               id: caseComic.chapterId,
//               comic: comic,
//               numericChapter: caseComic.numericChapter,
//               color: AppColor.backGroundButtonColor,
//               title: AppLocalizations.of(context)!.continueReading,
//             ),
//           ],
//         );
//       } else {
//         return Center(
//           child: ReadButton(
//             id: comic.chapters!.first.id,
//             comic: comic,
//             numericChapter: 1,
//             color: AppColor.backGroundButtonColor,
//             title: AppLocalizations.of(context)!.readComics,
//           ),
//         );
//       }
//     } else {
//       return ReadButton(
//         title: AppLocalizations.of(context)!.readComics,
//         color: AppColor.disable,
//       );
//     }
//   }
// }
