import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MdPreview extends StatefulWidget {
  MdPreview({
    Key key,
    this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.onTapLink,
    this.basicStyle,
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  /// Custom to p, a and others basic style.
  final TextStyle basicStyle;

  /// Call this method when it tap link of markdown.
  /// If [onTapLink] is null,it will open the link with your default browser.
  final TapLinkCallback onTapLink;

  @override
  State<StatefulWidget> createState() => MdPreviewState();
}

class MdPreviewState extends State<MdPreview> with AutomaticKeepAliveClientMixin {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var style = widget.basicStyle ?? Theme.of(context).textTheme.body1;

    return SingleChildScrollView(
      child: Padding(
        padding: widget.padding,
        child: MarkdownBody(
          data: widget.text ?? '',
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            a: style.copyWith(color: Colors.blue),
            p: style,
            img: style,
            blockquote: style,
            blockquoteDecoration: new BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey.shade300,
                  width: 5,
                ),
              ),
            ),
            blockquotePadding: const EdgeInsets.only(top: 15),
          ),
          onTapLink: (href) {
            print(href);
            if (widget.onTapLink == null) {
              _launchURL(href);
            } else {
              widget.onTapLink(href);
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

typedef void TapLinkCallback(String link);
