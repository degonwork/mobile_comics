import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/app_color.dart';
import '../../config/size_config.dart';
import 'text_ui.dart';

class CaseInfor extends StatelessWidget {
  const CaseInfor({
    super.key,
    required this.imageSquare,
    required this.title,
    required this.reads,
    required this.numericChapter,
  });

  final String? imageSquare;
  final String title;
  final int reads;
  final int numericChapter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        imageSquare != null
            ? Container(
                width: SizeConfig.width100,
                height: SizeConfig.height100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.radius10),
                  image: DecorationImage(
                    image: NetworkImage(imageSquare!),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Image.asset("assets/images/anh splash.jpg"),
        SizedBox(width: SizeConfig.width20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUi(
                          text: title,
                          fontSize: SizeConfig.font20,
                          color: AppColor.titleComicColor,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: SizeConfig.height10),
                        TextUi(
                          text: "$reads ${AppLocalizations.of(context)!.reads}",
                          fontSize: SizeConfig.font14,
                          color: AppColor.caseReadsColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 0.8),
              TextUi(
                text:
                    "${AppLocalizations.of(context)!.reading}: ${AppLocalizations.of(context)!.chapters} $numericChapter",
                fontSize: SizeConfig.font14,
                color: AppColor.contentInforColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}
