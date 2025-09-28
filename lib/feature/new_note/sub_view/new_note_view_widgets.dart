part of '../new_note_view.dart';

extension _NewNoteViewParts on NewNoteView {
  PreferredSizeWidget _buildAppBar(BuildContext context, NewNoteViewModel viewModel) {
    return AppBar(
      elevation: LayoutConstants.elevation0,
      leading: IconButton(onPressed: () => NavigationService.instance.pop(), icon: const Icon(Icons.arrow_back)),
      title: Text(isEditMode ? 'Edit Note' : 'New Note', style: h6.white.w600),
      actions: [
        IconButton(
          onPressed: () => viewModel.togglePin(),
          icon: Icon(
            viewModel.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: viewModel.isPinned ? Colors.orange : null,
          ),
        ),
        IconButton(onPressed: () => viewModel.clearForm, icon: const Icon(Icons.refresh)),
      ],
    );
  }

  Widget _buildTitleField(NewNoteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title', style: bodyXL.white.w600),
        LayoutConstants.emptyHeight8,
        Container(
          padding: LayoutConstants.padding16All,
          decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: LayoutConstants.border12Button),
          child: TextFormField(
            controller: viewModel.titleController,
            style: h4.white.bold,
            decoration: InputDecoration(
              hintText: 'Enter note title...',
              hintStyle: h4.copyWith(color: ThemeStyles.whiteColor.withValues(alpha:0.54)),
              border: InputBorder.none,
              fillColor: Color(0xFF2C2C2E),
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => viewModel.notifyListeners(),
          ),
        ),
      ],
    );
  }

  Widget _buildTagSection(NewNoteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tag', style: bodyXL.white.w600),
        LayoutConstants.emptyHeight8,
        SizedBox(
          height: LayoutConstants.size40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.tags.length,
            separatorBuilder: (context, index) => LayoutConstants.emptyWidth12,
            itemBuilder: (context, index) {
              final tag = viewModel.tags[index];
              final isSelected = tag == viewModel.selectedTag;

              return GestureDetector(
                onTap: () => viewModel.selectTag(tag),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: LayoutConstants.size16, vertical: LayoutConstants.size8),
                  decoration: BoxDecoration(
                    color: isSelected ? ThemeStyles.whiteColor : ThemeStyles.whiteColor.withValues(alpha:0.1),
                    borderRadius: LayoutConstants.border20Button,
                    border: isSelected ? null : Border.all(color: ThemeStyles.whiteColor.withValues(alpha:0.3)),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? ThemeStyles.blackColor : ThemeStyles.whiteColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSection(NewNoteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: bodyXL.white.w600),
        LayoutConstants.emptyHeight8,
        SizedBox(
          height: LayoutConstants.size48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.availableColors.length,
            separatorBuilder: (context, index) => LayoutConstants.emptyWidth12,
            itemBuilder: (context, index) {
              final color = viewModel.availableColors[index];
              final isSelected = color == viewModel.selectedColor;

              return GestureDetector(
                onTap: () => viewModel.selectColor(color),
                child: Container(
                  width: LayoutConstants.size48,
                  height: LayoutConstants.size48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(LayoutConstants.radius20),
                    border: Border.all(
                      color: isSelected ? ThemeStyles.blackColor.withValues(alpha:0.87) : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: ThemeStyles.blackColor, size: LayoutConstants.size24)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentField(NewNoteViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content', style: bodyXL.white.w600),
        LayoutConstants.emptyHeight8,
        Container(
          padding: LayoutConstants.padding16All,
          decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: LayoutConstants.border12Button),
          child: TextFormField(
            controller: viewModel.contentController,
            style: bodyXL.white.copyWith(height: 1.5),
            decoration: InputDecoration(
              hintText: 'Write your note here...',
              hintStyle: bodyXL.copyWith(color: ThemeStyles.whiteColor.withValues(alpha:0.54)),
              border: InputBorder.none,
              fillColor: Color(0xFF2C2C2E),
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            minLines: LayoutConstants.size8.toInt(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, NewNoteViewModel viewModel) {
    return FloatingActionButton.extended(
      onPressed: viewModel.canSave
          ? () async {
              final result = await viewModel.saveNote();
              if (result.status) {
                NavigationService.instance.pop(isEditMode ? result.data : true);
                NavigationService.instance.showSnackBar(
                  isEditMode ? 'Note updated successfully!' : 'Note saved successfully!',
                );
              } else {
                NavigationService.instance.showSnackBar(
                  isEditMode ? 'Failed to update note' : 'Failed to save note',
                  isError: true,
                );
              }
            }
          : null,
      backgroundColor: viewModel.canSave ? ThemeStyles.whiteColor : ThemeStyles.grayColor,
      foregroundColor: ThemeStyles.blackColor,
      label: viewModel.isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
          : Text('Save', style: bodyXL.w600),
      icon: viewModel.isLoading ? null : const Icon(Icons.save),
    );
  }
}