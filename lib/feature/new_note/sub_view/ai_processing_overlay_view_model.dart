import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:notes_app/product/constants/ai_constants.dart';

class AIProcessingOverlayViewModel extends BaseViewModel {
  late AnimationController _typewriterController;
  late AnimationController _pulseController;

  late Animation<int> _typewriterAnimation;
  late Animation<double> _pulseAnimation;

  late String _overlayText = AIConstants.overlayText;

  Animation<int> get typewriter => _typewriterAnimation;
  Animation<double> get pulse => _pulseAnimation;
  Listenable get listenable => Listenable.merge([_typewriterController, _pulseController]);

  void init(TickerProvider vsync, {String? textOverride}) {
    if (textOverride != null) {
      _overlayText = textOverride;
    }

    _typewriterController = AnimationController(
      duration: Duration(milliseconds: AIConstants.typewriterDuration),
      vsync: vsync,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: AIConstants.pulseDuration),
      vsync: vsync,
    );

    _typewriterAnimation = IntTween(
      begin: 0,
      end: _overlayText.length,
    ).animate(CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(
      begin: AIConstants.overlayOpacityMin,
      end: AIConstants.overlayOpacityMax,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _typewriterController.forward();
    _pulseController.repeat(reverse: true);
  }

  String visibleText() {
    final end = typewriter.value.clamp(0, _overlayText.length);
    return _overlayText.substring(0, end);
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
