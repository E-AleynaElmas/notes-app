import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:notes_app/core/utils/color_utils.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:notes_app/product/models/simple_result.dart';
import 'package:notes_app/product/services/note_service.dart';
import 'package:notes_app/product/services/gemini_service.dart';
import 'package:notes_app/product/constants/ai_constants.dart';

class NewNoteViewModel extends BaseViewModel {
  final NoteModel? _noteToEdit;

  NewNoteViewModel({NoteModel? noteToEdit}) : _noteToEdit = noteToEdit {
    if (noteToEdit != null) {
      titleController.text = noteToEdit.title;
      contentController.text = noteToEdit.content;
      _selectedColor = ColorUtils.parseColor(noteToEdit.color);
      _selectedTag = noteToEdit.tags.isNotEmpty ? noteToEdit.tags.first : 'Work';
      _isPinned = noteToEdit.isPinned;
    }
    _setupFocusListeners();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  bool _isTitleFocused = false;
  bool get isTitleFocused => _isTitleFocused;

  bool _isContentFocused = false;
  bool get isContentFocused => _isContentFocused;

  Color _selectedColor = const Color(0xFFFFF2CC);
  Color get selectedColor => _selectedColor;

  String _selectedTag = 'Work';
  String get selectedTag => _selectedTag;

  bool _isPinned = false;
  bool get isPinned => _isPinned;

  final List<String> _tags = ['Work', 'Reading', 'Important', 'Personal'];
  List<String> get tags => _tags;

  final List<Color> _availableColors = [
    const Color(0xFFFFF2CC),
    const Color(0xFFFFCDD2),
    const Color(0xFFE1BEE7),
    const Color(0xFFE8F5E8),
    const Color(0xFFE3F2FD),
    const Color(0xFFF5F5DC),
    const Color(0xFFFFE0B2),
    const Color(0xFFE0F2F1),
  ];
  List<Color> get availableColors => _availableColors;

  final NoteService _noteService = NoteService.instance;
  final GeminiService _geminiService = GeminiService.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAiProcessing = false;
  bool get isAiProcessing => _isAiProcessing;

  bool get canUseAI {
    return contentController.text.trim().length >= AIConstants.minContentLength && !_isAiProcessing;
  }

  void selectColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void selectTag(String tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  bool get canSave {
    return titleController.text.trim().isNotEmpty && !_isLoading;
  }

  Future<SimpleResult<NoteModel>> saveNote() async {
    if (!canSave) {
      return SimpleResult<NoteModel>(status: false, message: 'Cannot save note');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final note = NoteModel(
        id: _noteToEdit?.id ?? '',
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        color: ColorUtils.colorToHex(_selectedColor),
        tags: [_selectedTag],
        isPinned: _isPinned,
        createdAt: _noteToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = _noteToEdit != null
          ? await _noteService.updateNote(_noteToEdit.id, note)
          : await _noteService.createNote(note);

      _isLoading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return SimpleResult<NoteModel>(status: false, message: 'An error occurred: $e');
    }
  }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    _selectedColor = const Color(0xFFFFF2CC);
    _selectedTag = 'Work';
    _isPinned = false;
    notifyListeners();
  }

  void togglePin() {
    _isPinned = !_isPinned;
    notifyListeners();
  }

  void _setupFocusListeners() {
    titleFocusNode.addListener(() {
      _isTitleFocused = titleFocusNode.hasFocus;
      notifyListeners();
    });

    contentFocusNode.addListener(() {
      _isContentFocused = contentFocusNode.hasFocus;
      notifyListeners();
    });
  }

  Future<void> improveContentWithAI() async {
    final currentContent = contentController.text.trim();

    if (currentContent.isEmpty) {
      setError(AIConstants.emptyContentMessage);
      return;
    }

    _isAiProcessing = true;
    clearErrors();
    notifyListeners();

    try {
      final result = await _geminiService.improveText(currentContent);

      if (result.status && result.data != null) {
        contentController.text = result.data!;
        notifyListeners();
      } else {
        setError(result.message ?? AIConstants.aiErrorMessage);
      }
    } catch (e) {
      setError('${AIConstants.aiErrorMessage}: $e');
    } finally {
      _isAiProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    super.dispose();
  }
}
