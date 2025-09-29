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
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: LayoutConstants.border12Button,
            border: Border.all(color: viewModel.isTitleFocused ? Color(0xFFFF9500) : Color(0xFF3A3A3C), width: 1),
          ),
          child: TextFormField(
            controller: viewModel.titleController,
            focusNode: viewModel.titleFocusNode,
            style: h4.white.bold,
            decoration: InputDecoration(
              hintText: 'Enter note title...',
              hintStyle: h4.copyWith(color: ThemeStyles.whiteColor.withValues(alpha: 0.54)),
              border: InputBorder.none,
              filled: false,
              fillColor: Colors.transparent,
              contentPadding: LayoutConstants.padding12All,
              isDense: true,
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
                    color: isSelected ? ThemeStyles.whiteColor : ThemeStyles.whiteColor.withValues(alpha: 0.1),
                    borderRadius: LayoutConstants.border20Button,
                    border: isSelected ? null : Border.all(color: ThemeStyles.whiteColor.withValues(alpha: 0.3)),
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
                      color: isSelected ? ThemeStyles.blackColor.withValues(alpha: 0.87) : Colors.transparent,
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
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: LayoutConstants.border12Button,
            border: Border.all(color: viewModel.isContentFocused ? Color(0xFFFF9500) : Color(0xFF3A3A3C), width: 1),
          ),
          child: Stack(
            children: [
              TextFormField(
                controller: viewModel.contentController,
                focusNode: viewModel.contentFocusNode,
                enabled: !viewModel.isAiProcessing,
                style: bodyXL.white.copyWith(
                  height: 1.5,
                  color: viewModel.isAiProcessing
                      ? ThemeStyles.whiteColor.withValues(alpha: 0.3)
                      : ThemeStyles.whiteColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Write your note here...',
                  hintStyle: bodyXL.copyWith(color: ThemeStyles.whiteColor.withValues(alpha: 0.54)),
                  border: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 50, 12),
                  isDense: true,
                ),
                maxLines: null,
                minLines: 8,
                onChanged: (value) => viewModel.notifyListeners(),
              ),
              if (viewModel.isAiProcessing)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 300),
                    child: AIProcessingOverlayView(),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: viewModel.canUseAI
                      ? () async {
                          await viewModel.improveContentWithAI();
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: LayoutConstants.padding8All,
                    decoration: BoxDecoration(
                      color: viewModel.isAiProcessing
                          ? Colors.orange.withValues(alpha: 0.3)
                          : viewModel.canUseAI
                          ? Colors.orange.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: LayoutConstants.border8Button,
                      border: Border.all(
                        color: viewModel.canUseAI
                            ? Colors.orange.withValues(alpha: 0.6)
                            : Colors.grey.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: viewModel.isAiProcessing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          )
                        : Icon(Icons.auto_awesome, color: viewModel.canUseAI ? Colors.orange : Colors.grey, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (viewModel.hasError)
          Padding(
            padding: LayoutConstants.padding8Vertical.copyWith(bottom: 0),
            child: Text(viewModel.modelError, style: bodyM.copyWith(color: Colors.red)),
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
