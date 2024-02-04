import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key, required this.child, required this.isLoaded});

  final Widget child;
  final bool isLoaded;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoaded == true
        ? widget.child
        : const Center(child: CircularProgressIndicator());
  }
}
