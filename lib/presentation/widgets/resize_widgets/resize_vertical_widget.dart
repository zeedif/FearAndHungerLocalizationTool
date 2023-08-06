import 'dart:math';

import 'package:fear_and_hunger_localization_tool/presentation/widgets/resize_widgets/priority_size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResizableVerticalWidget extends StatefulWidget {
  final Widget child;
  final List<Widget> nextElements;
  final double height;
  final double minSize;
  final double maxSize;
  final String? heightKey;
  final double minSizeInPercentage;
  final double maxSizeInPercentage;
  final Priority priorityInMinSize;
  final Priority priorityInMaxSize;

  const ResizableVerticalWidget({
    super.key,
    required this.child,
    this.height = 100,
    this.minSize = 50,
    this.maxSize = 100,
    this.minSizeInPercentage = 0,
    this.maxSizeInPercentage = 100,
    this.priorityInMinSize = Priority.pixel,
    this.priorityInMaxSize = Priority.pixel,
    required this.nextElements,
    this.heightKey,
  });

  @override
  State<ResizableVerticalWidget> createState() => _ResizableVerticalWidgetState();
}

class _ResizableVerticalWidgetState extends State<ResizableVerticalWidget> {
  double heightContainer = 0;
  late double minSize;
  late double maxSize;
  late double parentHeight;
  late SharedPreferences prefs;
  bool isResizing = false;

  @override
  void initState() {
    super.initState();
    loadSharedPreferencesAndHeight();
  }

  void loadSharedPreferencesAndHeight() async {
    if (widget.heightKey != null) {
      prefs = await SharedPreferences.getInstance();
      heightContainer = prefs.getDouble(widget.heightKey!) ?? widget.height;
      setState(() {});
    } else {
      heightContainer = widget.height;
    }
  }

  @override
  void didUpdateWidget(covariant ResizableVerticalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isResizing ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize ||
        oldWidget.minSizeInPercentage != widget.minSizeInPercentage ||
        oldWidget.maxSizeInPercentage != widget.maxSizeInPercentage ||
        oldWidget.priorityInMaxSize != widget.priorityInMaxSize ||
        oldWidget.priorityInMinSize != widget.priorityInMinSize) {
      calculateSizes();
    }
  }

  void calculateSizes() {
    final minSizeInPixels = widget.minSizeInPercentage * parentHeight / 100;
    final maxSizeInPixels = widget.maxSizeInPercentage * parentHeight / 100;

    switch (widget.priorityInMinSize) {
      case Priority.percentage:
        minSize = minSizeInPixels;
        break;
      case Priority.pixel:
        minSize = widget.minSize;
        break;
      case Priority.larger:
        minSize = max(widget.minSize, minSizeInPixels);
        break;
      case Priority.smaller:
        minSize = min(widget.minSize, minSizeInPixels);
        break;
    }
    switch (widget.priorityInMaxSize) {
      case Priority.percentage:
        maxSize = maxSizeInPixels;
        break;
      case Priority.pixel:
        maxSize = widget.maxSize;
        break;
      case Priority.larger:
        maxSize = max(widget.maxSize, maxSizeInPixels);
        break;
      case Priority.smaller:
        maxSize = min(widget.maxSize, maxSizeInPixels);
        break;
    }

    minSize = minSize.clamp(0, parentHeight);
    maxSize = maxSize.clamp(minSize, parentHeight);

    if (heightContainer > maxSize) {
      heightContainer = maxSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        parentHeight = constraints.maxHeight;
        if (parentHeight == double.infinity) {
          parentHeight = MediaQuery.of(context).size.height;
        }
        if (!isResizing) {
          calculateSizes();
        }
        return Column(
          children: [
            SizedBox(
              height: heightContainer,
              child: widget.child,
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  isResizing = true;
                  heightContainer += details.delta.dy;
                  heightContainer = heightContainer.clamp(minSize, maxSize);
                });
              },
              onVerticalDragEnd: (details) {
                isResizing = false;
                if (widget.heightKey != null) {
                  prefs.setDouble(widget.heightKey!, heightContainer);
                }
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: Divider(
                  height: 4,
                  thickness: 1.5,
                ),
              ),
            ),
            ...widget.nextElements,
          ],
        );
      },
    );
  }
}
