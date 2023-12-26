library animated_border;

import 'dart:ui';

import 'package:flutter/material.dart';

/// Animated Border.
class AnimatedBorder extends StatefulWidget {
  final AnimatedBorderController? controller;
  final bool glow;
  final double glowSpread;
  final bool clipGlowAtMargin;
  final double margin;
  final double borderWidth;
  final AnimatedBorderRadius? borderRadius;
  late final BorderRadius? glowBorderRadius;
  late final BorderRadius? outerBorderRadius;
  late final BorderRadius? innerBorderRadius;
  final Color childBackgroundColor;
  final Duration duration;
  final bool autoStart;
  final AnimatedBorderSegments animationSegments;
  final AnimatedBorderSegments? reverseAnimationSegments;
  final Widget child;

  AnimatedBorder({
    super.key,
    this.controller,
    this.glow = true,
    this.glowSpread = 3.7,
    this.clipGlowAtMargin = true,
    this.margin = 8,
    this.borderWidth = 2,
    this.borderRadius,
    this.childBackgroundColor = Colors.white,
    required this.duration,
    this.autoStart = true,
    required this.animationSegments,
    this.reverseAnimationSegments,
    required this.child,
  }) {
    if (borderRadius != null) {
      glowBorderRadius = BorderRadius.only(
        topLeft: Radius.circular((borderRadius?.topLeft ?? 0) + borderWidth + margin),
        topRight: Radius.circular((borderRadius?.topRight ?? 0) + borderWidth + margin),
        bottomLeft: Radius.circular((borderRadius?.bottomLeft ?? 0) + borderWidth + margin),
        bottomRight: Radius.circular((borderRadius?.bottomRight ?? 0) + borderWidth + margin),
      );
      outerBorderRadius = BorderRadius.only(
        topLeft: Radius.circular((borderRadius?.topLeft ?? 0) + borderWidth),
        topRight: Radius.circular((borderRadius?.topRight ?? 0) + borderWidth),
        bottomLeft: Radius.circular((borderRadius?.bottomLeft ?? 0) + borderWidth),
        bottomRight: Radius.circular((borderRadius?.bottomRight ?? 0) + borderWidth),
      );
      innerBorderRadius = BorderRadius.only(
        topLeft: Radius.circular(borderRadius?.topLeft ?? 0),
        topRight: Radius.circular(borderRadius?.topRight ?? 0),
        bottomLeft: Radius.circular(borderRadius?.bottomLeft ?? 0),
        bottomRight: Radius.circular(borderRadius?.bottomRight ?? 0),
      );
    } else {
      glowBorderRadius = null;
      outerBorderRadius = null;
      innerBorderRadius = null;
    }
  }

  @override
  State<AnimatedBorder> createState() => _AnimatedBorderState();
}

class _AnimatedBorderState extends State<AnimatedBorder> with SingleTickerProviderStateMixin {
  late (double, double) Function() getDimens;
  double parentHeight = 0;
  double parentWidth = 0;
  bool isAnimationVisible = false;
  bool stopAnimationOnNextCycle = false;
  bool get isInitialized => (parentHeight != 0 && parentWidth != 0);

  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> reverseAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = Tween<double>(begin: 0.0, end: 400.0).animate(animationController);
    reverseAnimation = Tween<double>(begin: -400.0, end: 0.0).animate(animationController);
    widget.controller?._state = this;
    animationController.addListener(_animationListener);
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    animationController.removeListener(_animationListener);
    animationController.dispose();
    super.dispose();
  }

  initialize() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 1));
      if (isInitialized) {
        if (widget.autoStart) {
          animationController.repeat();
          isAnimationVisible = true;
        }
        setState(() {});
        break;
      }
    }
  }

  _startAnimation() {
    if (isAnimationVisible) {
      return;
    }

    isAnimationVisible = true;
    stopAnimationOnNextCycle = false;
    setState(() {});
    if (animationController.isAnimating) {
      return;
    }
    animationController.repeat();
  }

  _stopAnimation({bool force = false}) {
    if (force && isAnimationVisible) {
      isAnimationVisible = false;
      setState(() {});
      animationController.stop();
      animationController.reset();
      return;
    }
    if (isAnimationVisible) {
      stopAnimationOnNextCycle = true;
    }
  }

  _animationListener() {
    if (stopAnimationOnNextCycle && isAnimationVisible && animation.value > 350) {
      isAnimationVisible = false;
      setState(() {});
    }
    if (stopAnimationOnNextCycle && isAnimationVisible && animation.value > 390) {
      animationController.stop();
      animationController.reset();
      stopAnimationOnNextCycle = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
        parentHeight = getDimens().$1 + (widget.borderWidth * 2);
        parentWidth = getDimens().$2 + (widget.borderWidth * 2);
      },
    );
    return Center(
      child: Stack(
        children: [
          if (widget.glow && isInitialized && widget.reverseAnimationSegments != null)
            ...List.generate(
              widget.reverseAnimationSegments!.segments.length,
                  (index) => Positioned.fill(
                child: AnimatedBuilder(
                  animation: reverseAnimation,
                  builder: (context, child) {
                    final pos = positions(
                      reverseAnimation.value.abs(),
                      widget.reverseAnimationSegments!.segments[index],
                      widget.reverseAnimationSegments!.segmentationType,
                    );
                    return Container(
                      margin: EdgeInsets.all(widget.margin),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: widget.outerBorderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            left: pos.$1,
                            bottom: pos.$2,
                            child: AnimatedOpacity(
                              opacity: isAnimationVisible ? 1 : 0,
                              duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 4),
                              child: Container(
                                height: widget.reverseAnimationSegments!.segments[index].getRadius(parentHeight) * 2,
                                width: widget.reverseAnimationSegments!.segments[index].getRadius(parentHeight) * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.reverseAnimationSegments!.segments[index].color,
                                      widget.reverseAnimationSegments!.segments[index].color.withOpacity(0),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if (widget.glow && isInitialized) ...[
            ...List.generate(
              widget.animationSegments.segments.length,
                  (index) => Positioned.fill(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final pos = positions(
                      animation.value.abs(),
                      widget.animationSegments.segments[index],
                      widget.animationSegments.segmentationType,
                    );
                    return Container(
                      margin: EdgeInsets.all(widget.margin),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: widget.outerBorderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            left: pos.$1,
                            bottom: pos.$2,
                            child: AnimatedOpacity(
                              opacity: isAnimationVisible ? 1 : 0,
                              duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 4),
                              child: Container(
                                height: widget.animationSegments.segments[index].getRadius(parentHeight) * 2,
                                width: widget.animationSegments.segments[index].getRadius(parentHeight) * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.animationSegments.segments[index].color,
                                      widget.animationSegments.segments[index].color.withOpacity(0),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                clipBehavior: widget.clipGlowAtMargin ? Clip.hardEdge : Clip.none,
                decoration: BoxDecoration(
                  borderRadius: widget.glowBorderRadius,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.glowSpread,
                    sigmaY: widget.glowSpread,
                  ),
                  blendMode: BlendMode.src,
                  child: Container(
                    color: Colors.white.withOpacity(0),
                  ),
                ),
              ),
            ),
          ],
          if (isInitialized && widget.reverseAnimationSegments != null)
            ...List.generate(
              widget.reverseAnimationSegments!.segments.length,
                  (index) => Positioned.fill(
                child: AnimatedBuilder(
                  animation: reverseAnimation,
                  builder: (context, child) {
                    final pos = positions(
                      reverseAnimation.value.abs(),
                      widget.reverseAnimationSegments!.segments[index],
                      widget.reverseAnimationSegments!.segmentationType,
                    );
                    return Container(
                      margin: EdgeInsets.all(widget.margin),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: widget.outerBorderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            left: pos.$1,
                            bottom: pos.$2,
                            child: AnimatedOpacity(
                              opacity: isAnimationVisible ? 1 : 0,
                              duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 4),
                              child: Container(
                                height: widget.reverseAnimationSegments!.segments[index].getRadius(parentHeight) * 2,
                                width: widget.reverseAnimationSegments!.segments[index].getRadius(parentHeight) * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.reverseAnimationSegments!.segments[index].color,
                                      widget.reverseAnimationSegments!.segments[index].color.withOpacity(0),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if (isInitialized)
            ...List.generate(
              widget.animationSegments.segments.length,
                  (index) => Positioned.fill(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final pos = positions(
                      animation.value.abs(),
                      widget.animationSegments.segments[index],
                      widget.animationSegments.segmentationType,
                    );
                    return Container(
                      margin: EdgeInsets.all(widget.margin),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: widget.outerBorderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            left: pos.$1,
                            bottom: pos.$2,
                            child: AnimatedOpacity(
                              opacity: isAnimationVisible ? 1 : 0,
                              duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 4),
                              child: Container(
                                height: widget.animationSegments.segments[index].getRadius(parentHeight) * 2,
                                width: widget.animationSegments.segments[index].getRadius(parentHeight) * 2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.animationSegments.segments[index].color,
                                      widget.animationSegments.segments[index].color.withOpacity(0),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          Container(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.all(widget.borderWidth + widget.margin),
            decoration: BoxDecoration(
              color: widget.childBackgroundColor,
              borderRadius: widget.innerBorderRadius,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  getDimens = (() => (context.size!.height, context.size!.width));
                  return widget.child;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  (double, double) positions(double animationValue, BorderSegment segment, SegmentationType segmentationType) {
    double currentPosition = (animationValue + segment.position) % 400;
    double pixelLength = 400 / ((parentHeight * 2) + (parentWidth * 2));
    double width = pixelLength * parentWidth;
    double height = pixelLength * parentHeight;

    if (segmentationType == SegmentationType.alignmentBased) {
      AnimatedBorderSide borderSide = segment.alignment!.borderSide;
      double positionMultiplier = (segment.alignment!.position.clamp(0, 100).toDouble() / 100);

      if (borderSide == AnimatedBorderSide.left) {
        currentPosition = (animationValue + (height * positionMultiplier)) % 400;
      }
      if (borderSide == AnimatedBorderSide.top) {
        currentPosition = (animationValue + (height + (width * positionMultiplier))) % 400;
      }
      if (borderSide == AnimatedBorderSide.right) {
        currentPosition = (animationValue + (height + width + (height * positionMultiplier))) % 400;
      }
      if (borderSide == AnimatedBorderSide.bottom) {
        currentPosition = (animationValue + (height + width + height + (width * positionMultiplier))) % 400;
      }
    }

    double leftPosition = 0;
    double bottomPosition = 0;

    if (currentPosition >= 0 && currentPosition <= height) {
      leftPosition = -segment.getRadius(parentHeight);
      bottomPosition = -segment.getRadius(parentHeight) + ((currentPosition / height) * parentHeight);
    }
    if (currentPosition > height && currentPosition <= (height + width)) {
      leftPosition = -segment.getRadius(parentHeight) + (((currentPosition - height) / width) * parentWidth);
      bottomPosition = -segment.getRadius(parentHeight) + parentHeight;
    }
    if (currentPosition > (height + width) && currentPosition <= (height + width + height)) {
      leftPosition = -segment.getRadius(parentHeight) + parentWidth;
      bottomPosition =
          -segment.getRadius(parentHeight) + (((height - (currentPosition - height - width)) / height) * parentHeight);
    }
    if (currentPosition > (height + width + height)) {
      leftPosition =
          -segment.getRadius(parentHeight) + (((width - (currentPosition - height - width - height)) / width) * parentWidth);
      bottomPosition = -segment.getRadius(parentHeight);
    }

    return (leftPosition, bottomPosition);
  }
}

class AnimatedBorderController {
  _AnimatedBorderState? _state;

  startAnimation() {
    _state?._startAnimation();
  }

  stopAnimation({bool force = false}) {
    _state?._stopAnimation(force: force);
  }
}

class AnimatedBorderRadius {
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;

  AnimatedBorderRadius._(
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight,
      );

  factory AnimatedBorderRadius.only({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return AnimatedBorderRadius._(
      topLeft,
      topRight,
      bottomLeft,
      bottomRight,
    );
  }

  factory AnimatedBorderRadius.circular(double? radius) {
    return AnimatedBorderRadius._(
      radius,
      radius,
      radius,
      radius,
    );
  }

  factory AnimatedBorderRadius.vertical({
    double? top,
    double? bottom,
  }) {
    return AnimatedBorderRadius._(
      top,
      top,
      bottom,
      bottom,
    );
  }

  factory AnimatedBorderRadius.horizontal({
    double? left,
    double? right,
  }) {
    return AnimatedBorderRadius._(
      left,
      right,
      left,
      right,
    );
  }
}

class BorderSegment {
  final double initialSize;
  final double heightFactor;
  final BorderSegmentAlignment? alignment;
  late double position;
  final Color color;

  BorderSegment({
    this.initialSize = 220.0,
    this.heightFactor = 0.6,
    this.alignment,
    double position = 0,
    required this.color,
  }) {
    this.position = position.abs();
  }

  double getRadius(double parentHeight) {
    return (initialSize + (parentHeight * heightFactor)) / 2;
  }
}

class AnimatedBorderSegments {
  final SegmentationType segmentationType;
  final List<BorderSegment> segments;

  AnimatedBorderSegments._({
    required this.segmentationType,
    required this.segments,
  });

  factory AnimatedBorderSegments.spacedEvenly(List<EvenlySpacedBorderSegment> segments) {
    List<BorderSegment> modifiedSegments = segments;
    int count = modifiedSegments.length;
    for (var i = 0; i < count; i++) {
      modifiedSegments[i].position = (400 / count) * i;
    }
    return AnimatedBorderSegments._(
      segmentationType: SegmentationType.spacedEvenly,
      segments: modifiedSegments,
    );
  }

  factory AnimatedBorderSegments.alignmentBased(List<AlignmentBasedBorderSegment> segments) {
    return AnimatedBorderSegments._(
      segmentationType: SegmentationType.alignmentBased,
      segments: segments,
    );
  }

  factory AnimatedBorderSegments.distanceBased(List<DistanceBasedBorderSegment> segments) {
    return AnimatedBorderSegments._(
      segmentationType: SegmentationType.distanceBased,
      segments: segments,
    );
  }
}

class EvenlySpacedBorderSegment extends BorderSegment {
  EvenlySpacedBorderSegment({
    super.initialSize,
    super.heightFactor,
    required super.color,
  });
}

class AlignmentBasedBorderSegment extends BorderSegment {
  AlignmentBasedBorderSegment({
    super.initialSize,
    super.heightFactor,
    required BorderSegmentAlignment alignment,
    required super.color,
  }) : super(alignment: alignment);
}

class DistanceBasedBorderSegment extends BorderSegment {
  DistanceBasedBorderSegment({
    super.initialSize,
    super.heightFactor,
    required double position,
    required super.color,
  }) : super(position: position);
}

class BorderSegmentAlignment {
  final AnimatedBorderSide borderSide;
  late final double position;

  BorderSegmentAlignment({
    required this.borderSide,
    required double position,
  }) {
    this.position = position.abs();
  }
}

enum SegmentationType {
  spacedEvenly,
  alignmentBased,
  distanceBased,
}

enum AnimatedBorderSide {
  left,
  top,
  right,
  bottom,
}
