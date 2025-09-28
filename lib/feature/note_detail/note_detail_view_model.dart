import 'package:stacked/stacked.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:notes_app/product/services/note_service.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';
import 'package:notes_app/core/services/navigation_service.dart';

class NoteDetailViewModel extends BaseViewModel {
  NoteModel _note;
  NoteModel get note => _note;

  final NoteService _noteService = NoteService.instance;

  NoteDetailViewModel(this._note);

  String get formattedDate {
    return '${_note.createdAt?.day}/${_note.createdAt?.month}/${_note.createdAt?.year}';
  }

  String get categoryIcon {
    if (_note.tags.isEmpty) return '📝';

    final firstTag = _note.tags.first.toLowerCase();
    switch (firstTag) {
      case 'work':
        return '💼';
      case 'reading':
        return '📚';
      case 'important':
        return '⭐';
      case 'personal':
        return '👤';
      default:
        return '📝';
    }
  }

  String get primaryCategory {
    return _note.tags.isNotEmpty ? _note.tags.first : 'General';
  }

  bool get hasContent {
    return _note.content.isNotEmpty;
  }

  Future<bool> deleteNote() async {
    try {
      final result = await _noteService.deleteNote(_note.id);
      return result.status;
    } catch (e) {
      return false;
    }
  }

  Future<bool> togglePin() async {
    try {
      final updatedNote = NoteModel(
        id: _note.id,
        title: _note.title,
        content: _note.content,
        color: _note.color,
        tags: _note.tags,
        isPinned: !_note.isPinned,
        createdAt: _note.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await _noteService.updateNote(_note.id, updatedNote);

      if (result.status && result.data != null) {
        _note = result.data!;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> navigateToEdit() async {
    final result = await NavigationService.instance.navigateToPage<NoteModel>(
      navEnum: NavigationEnums.editNote,
      data: _note,
    );
    if (result != null) {
      NavigationService.instance.pop(false);
    }
  }
}
