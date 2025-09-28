import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/core/constants/layout_constants.dart';
import 'package:notes_app/core/utils/color_utils.dart';
import 'package:notes_app/feature/home/home_view_model.dart';
import 'package:notes_app/product/theme/theme_styles.dart';
import 'package:notes_app/product/constants/typography_constants.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) => viewModel.loadNotes(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: _buildSearchBar(viewModel),
            actions: [
              IconButton(tooltip: 'Çıkış', icon: const Icon(Icons.logout), onPressed: () => viewModel.logout()),
            ],
          ),
          body: Column(
            children: [
              LayoutConstants.emptyHeight20,
              _buildFilterChips(viewModel),
              Expanded(
                child: viewModel.isLoading && viewModel.filteredNotes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildNotesGrid(viewModel, context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => viewModel.navigateToNewNote(),
            backgroundColor: ThemeStyles.whiteColor,
            foregroundColor: ThemeStyles.blackColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(HomeViewModel viewModel) {
    return Padding(
      padding: LayoutConstants.padding16All,
      child: Container(
        decoration: BoxDecoration(color: ThemeStyles.secondaryColor, borderRadius: LayoutConstants.border12Button),
        child: TextFormField(
          onChanged: (value) => viewModel.updateSearchQuery(value),
          style: bodyXL.white,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            hintText: 'Search your notes',
            hintStyle: bodyXL.gray,
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: LayoutConstants.size20),
            suffixIcon: viewModel.isLoading && viewModel.searchQuery.isNotEmpty
                ? const SizedBox(
                    width: LayoutConstants.size20,
                    height: LayoutConstants.size20,
                    child: Padding(
                      padding: LayoutConstants.padding12All,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(HomeViewModel viewModel) {
    return Padding(
      padding: LayoutConstants.padding20Horizontal,
      child: SizedBox(
        height: LayoutConstants.size40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: viewModel.filters.length,
          separatorBuilder: (context, index) => LayoutConstants.emptyWidth12,
          itemBuilder: (context, index) {
            final filter = viewModel.filters[index];
            final isSelected = filter == viewModel.selectedFilter;

            return GestureDetector(
              onTap: () => viewModel.selectFilter(filter),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: LayoutConstants.size16, vertical: LayoutConstants.size8),
                decoration: BoxDecoration(
                  color: isSelected ? ThemeStyles.whiteColor : Colors.transparent,
                  borderRadius: LayoutConstants.border20Button,
                  border: isSelected ? null : Border.all(color: Colors.grey.withValues(alpha:0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filter,
                      style: bodyXL.copyWith(
                        color: isSelected ? ThemeStyles.blackColor : ThemeStyles.whiteColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotesGrid(HomeViewModel viewModel, BuildContext context) {
    if (viewModel.filteredNotes.isEmpty) {
      return _buildEmptyState(viewModel, context);
    }

    return Padding(
      padding: LayoutConstants.padding20All.copyWith(bottom: 0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: LayoutConstants.size12,
        crossAxisSpacing: LayoutConstants.size12,
        itemCount: viewModel.filteredNotes.length,
        itemBuilder: (context, index) {
          final note = viewModel.filteredNotes[index];
          return _buildNoteCard(note, context, viewModel);
        },
      ),
    );
  }

  Widget _buildEmptyState(HomeViewModel viewModel, BuildContext context) {
    final isFiltered = viewModel.selectedFilter != 'All';
    final hasSearch = viewModel.searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: LayoutConstants.padding20All,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered || hasSearch ? Icons.search_off : Icons.note_add,
              size: 80,
              color: ThemeStyles.whiteColor.withValues(alpha:0.3),
            ),
            LayoutConstants.emptyHeight20,
            Text(
              isFiltered || hasSearch ? 'No notes found' : 'No notes yet',
              style: h4.white.w600,
              textAlign: TextAlign.center,
            ),
            LayoutConstants.emptyHeight8,
            Text(
              isFiltered || hasSearch
                  ? 'Try adjusting your search or filter'
                  : 'Tap the + button to create your first note',
              style: bodyL.copyWith(color: ThemeStyles.whiteColor.withValues(alpha:0.7)),
              textAlign: TextAlign.center,
            ),
            if (!isFiltered && !hasSearch) ...[
              LayoutConstants.emptyHeight24,
              ElevatedButton.icon(
                onPressed: () => viewModel.navigateToNewNote(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeStyles.whiteColor,
                  foregroundColor: ThemeStyles.blackColor,
                  padding: EdgeInsets.symmetric(horizontal: LayoutConstants.size24, vertical: LayoutConstants.size12),
                  shape: RoundedRectangleBorder(borderRadius: LayoutConstants.border20Button),
                ),
                icon: const Icon(Icons.add),
                label: Text('Create Note', style: bodyL.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(NoteModel note, BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.navigateToNoteDetail(note),
      child: Container(
        padding: LayoutConstants.padding16All,
        decoration: BoxDecoration(
          color: ColorUtils.parseColor(note.color),
          borderRadius: LayoutConstants.border16Button,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(note.title, style: bodyXL.black.w600)),
                if (note.isPinned) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.push_pin, size: 16, color: Colors.black.withValues(alpha:0.6)),
                ],
              ],
            ),

            if (note.content.isNotEmpty) ...[
              LayoutConstants.emptyHeight8,
              Text(
                note.content,
                style: bodyS.black.copyWith(height: 1.4),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            if (note.tags.isNotEmpty) ...[
              LayoutConstants.emptyHeight8,
              Wrap(
                spacing: 4,
                children: note.tags
                    .take(3)
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('#$tag', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
