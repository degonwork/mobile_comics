import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
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
                  color: Colors.yellow,
                )),
              ),
            ],
          );
        } else if (isExpanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text),
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: Center(
                  child: TextUi(
                    text: AppLocalizations.of(context)!.collapse,
                    color: Colors.yellow,
                  ),
                ),
              )
            ],
          );
        } else {
          return Text(widget.text);
        }
      },
    );
  }
}
