import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:full_comics_frontend/config/app_color.dart';
import '../../../widgets/text_ui.dart';

class Descreption extends StatefulWidget {
  const Descreption({super.key, required this.maxLines, required this.text});
  final String text;
  final int maxLines;
  @override
  State<Descreption> createState() => _DescreptionState();
}

class _DescreptionState extends State<Descreption> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: isExpanded ? null : 3,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);
        if (textPainter.didExceedMaxLines && !isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUi(
                text: widget.text,
                textOverflow: TextOverflow.ellipsis,
                color: AppColor.contentDecripberColor,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                child: Center(
                  child: TextUi(
                    text: AppLocalizations.of(context)!.viewMore,
                    color: AppColor.buttonTextSelectColor,
                  ),
                ),
              ),
            ],
          );
        } else if (isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUi(
                text: widget.text,
                color: AppColor.contentDecripberColor,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: Center(
                  child: TextUi(
                    text: AppLocalizations.of(context)!.collapse,
                    color: AppColor.buttonTextSelectColor,
                  ),
                ),
              )
            ],
          );
        } else {
          return TextUi(
            text: widget.text,
            color: AppColor.contentDecripberColor,
          );
        }
      },
    );
  }
}
