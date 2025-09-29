import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/feature/new_note/sub_view/ai_processing_overlay_view_model.dart';
import 'package:stacked/stacked.dart';

class AIProcessingOverlayView extends StatefulWidget {
  const AIProcessingOverlayView({super.key, this.text});
  final String? text;

  @override
  State<AIProcessingOverlayView> createState() => _AIProcessingOverlayViewState();
}

class _AIProcessingOverlayViewState extends State<AIProcessingOverlayView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AIProcessingOverlayViewModel>.reactive(
      viewModelBuilder: () => AIProcessingOverlayViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(this, textOverride: widget.text),
      builder: (context, viewModel, child) {
        return AnimatedBuilder(
          animation: viewModel.listenable,
          builder: (context, __) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: LayoutConstants.border12Button,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF9500).withValues(alpha: 0.1),
                    const Color(0xFFFF9500).withValues(alpha: 0.05),
                    const Color(0xFFFF9500).withValues(alpha: 0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: AnimatedOpacity(
                  opacity: viewModel.pulse.value,
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    viewModel.visibleText(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFFFF9500), Colors.white, Color(0xFFFF9500)],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
