import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:flutter/material.dart';

Future<String?> promptForName(
  BuildContext context, {
  required String title,
  String? initial,
  String confirmLabel = 'Save',
}) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return _NamePromptDialog(
        title: title,
        initial: initial,
        confirmLabel: confirmLabel,
      );
    },
  );
  final trimmed = result?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

class _NamePromptDialog extends StatefulWidget {
  const _NamePromptDialog({
    required this.title,
    required this.confirmLabel,
    this.initial,
  });

  final String title;
  final String? initial;
  final String confirmLabel;

  @override
  State<_NamePromptDialog> createState() => _NamePromptDialogState();
}

class _NamePromptDialogState extends State<_NamePromptDialog> {
  late final TextEditingController _controller;
  var _popped = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_popped) {
      return;
    }
    _popped = true;
    Navigator.of(context).pop(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(hintText: 'Name'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

void showFailureSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showResultFailure<T>(BuildContext context, Result<T> result) {
  final failure = result.failureOrNull;
  if (failure != null) {
    showFailureSnackBar(context, failure.message);
  }
}
