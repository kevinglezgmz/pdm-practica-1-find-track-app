import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IconUrlLauncher extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String url;
  final String tooltip;
  const IconUrlLauncher({
    Key? key,
    required this.color,
    required this.icon,
    required this.url,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      preferBelow: true,
      child: InkResponse(
        highlightShape: BoxShape.circle,
        onTap: () {
          launchUrlString(url, mode: LaunchMode.externalApplication);
        },
        radius: 40,
        child: Icon(
          icon,
          color: color,
          size: 64,
        ),
      ),
    );
  }
}
