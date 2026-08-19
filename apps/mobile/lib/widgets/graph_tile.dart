import 'package:flutter/material.dart';

class GraphTile extends StatelessWidget {
  const GraphTile({
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.icon = Icons.place_outlined,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null || subtitle == title
          ? null
          : Text(subtitle!, style: theme.textTheme.bodySmall),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
