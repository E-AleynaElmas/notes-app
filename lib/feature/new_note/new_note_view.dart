import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/feature/new_note/new_note_view_model.dart';
import 'package:notes_app/product/constants/typography_constants.dart';
import 'package:notes_app/product/theme/theme_styles.dart';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:stacked/stacked.dart';
part 'sub_view/new_note_view_widgets.dart';

class NewNoteView extends StatelessWidget {
  final NoteModel? noteToEdit;

  const NewNoteView({super.key, this.noteToEdit});

  bool get isEditMode => noteToEdit != null;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewNoteViewModel>.reactive(
      viewModelBuilder: () => NewNoteViewModel(noteToEdit: noteToEdit),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(context, viewModel),
          body: SingleChildScrollView(
            padding: LayoutConstants.padding20All,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(viewModel),
                LayoutConstants.emptyHeight20,
                _buildTagSection(viewModel),
                LayoutConstants.emptyHeight20,
                _buildColorSection(viewModel),
                LayoutConstants.emptyHeight20,
                _buildContentField(viewModel),
              ],
            ),
          ),
          floatingActionButton: _buildSaveButton(context, viewModel),
        );
      },
    );
  }
}