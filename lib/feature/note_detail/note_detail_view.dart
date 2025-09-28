import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/core/utils/color_utils.dart';
import 'package:notes_app/feature/note_detail/note_detail_view_model.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:notes_app/product/theme/theme_styles.dart';
import 'package:notes_app/product/constants/typography_constants.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

class NoteDetailView extends StatelessWidget {
  final NoteModel note;

  const NoteDetailView({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NoteDetailViewModel>.reactive(
      viewModelBuilder: () => NoteDetailViewModel(note),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(context, viewModel),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: LayoutConstants.padding20All,
                  padding: LayoutConstants.padding20All,
                  decoration: BoxDecoration(
                    color: ColorUtils.parseColor(viewModel.note.color),
                    borderRadius: LayoutConstants.border16Button,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(viewModel.note.title, style: h3.black.bold),
                      LayoutConstants.emptyHeight16,
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: LayoutConstants.size12,
                              vertical: LayoutConstants.size4 + LayoutConstants.size2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha:0.1),
                              borderRadius: LayoutConstants.border20Button,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(viewModel.categoryIcon, style: bodyL),
                                LayoutConstants.emptyWidth8,
                                Text(viewModel.primaryCategory, style: bodyL.black.medium),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(viewModel.formattedDate, style: bodyL.copyWith(color: Colors.black.withValues(alpha:0.6))),
                        ],
                      ),

                      if (viewModel.hasContent) ...[
                        LayoutConstants.emptyHeight24,
                        Text(viewModel.note.content, style: h6.black.copyWith(height: 1.6)),
                      ],
                      if (viewModel.note.tags.isNotEmpty) ...[
                        LayoutConstants.emptyHeight20,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: viewModel.note.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.1),
                                    borderRadius: LayoutConstants.border16Button,
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => viewModel.navigateToEdit(),
            backgroundColor: ThemeStyles.whiteColor,
            foregroundColor: ThemeStyles.blackColor,
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, NoteDetailViewModel viewModel) {
    return AppBar(
      elevation: 0,
      leading: IconButton(onPressed: () => NavigationService.instance.pop(), icon: const Icon(Icons.arrow_back)),
      title: Text('Note Details', style: h6.white.w600),
      actions: [
        IconButton(
          onPressed: () => _togglePin(context, viewModel),
          icon: Icon(
            viewModel.note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: viewModel.note.isPinned ? Colors.orange : null,
          ),
        ),
        IconButton(
          onPressed: () => _showDeleteDialog(context, viewModel),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }


  void _togglePin(BuildContext context, NoteDetailViewModel viewModel) async {
    final success = await viewModel.togglePin();

    if (success) {
      NavigationService.instance.showSnackBar(viewModel.note.isPinned ? 'Note pinned!' : 'Note unpinned!');
    } else {
      NavigationService.instance.showSnackBar('Failed to toggle pin status', isError: true);
    }
  }

  void _showDeleteDialog(BuildContext context, NoteDetailViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeStyles.secondaryColor,
          title: Text('Delete Note', style: h6.white),
          content: Text(
            'Are you sure you want to delete this note? This action cannot be undone.',
            style: bodyL.copyWith(color: ThemeStyles.whiteColor.withValues(alpha:0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () => NavigationService.instance.pop(),
              child: Text('Cancel', style: bodyL.white),
            ),
            TextButton(
              onPressed: () async {
                NavigationService.instance.pop();

                final success = await viewModel.deleteNote();
                if (success) {
                  NavigationService.instance.pop(true);
                } else {
                  NavigationService.instance.showSnackBar('Failed to delete note', isError: true);
                }
              },
              child: Text('Delete', style: bodyL.error),
            ),
          ],
        );
      },
    );
  }

}
