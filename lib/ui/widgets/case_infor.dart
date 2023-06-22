import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_comics_frontend/ui/widgets/text_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/size_config.dart';

class CaseInfor extends StatelessWidget {
  const CaseInfor({
    super.key,
    required this.imageSquare,
    required this.title,
    required this.reads,
    required this.numericChapter,
  });

  final String? imageSquare;
  final String? title;
  final int? reads;
  final int numericChapter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        imageSquare != null
            ? CachedNetworkImage(
                imageUrl: imageSquare!,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: SizeConfig.width100,
                    height: SizeConfig.height100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeConfig.radius10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/banner_splash.png"),
              )
            : Image.asset("assets/images/banner_splash.png"),
        SizedBox(width: SizeConfig.width20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUi(
                        text: title != null ? title! : "",
                        fontSize: SizeConfig.font20,
                        color: Colors.yellow.withBlue(2),
                      ),
                      SizedBox(height: SizeConfig.height10),
                      TextUi(
                        text:
                            "${reads ?? ""} ${AppLocalizations.of(context)!.reads}",
                        fontSize: SizeConfig.font14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 0.8),
              TextUi(
                text:
                    "${AppLocalizations.of(context)!.reading}: ${AppLocalizations.of(context)!.chapters} $numericChapter",
                fontSize: SizeConfig.font14,
                color: Colors.black,
              )
            ],
          ),
        ),
      ],
    );
  }
}
