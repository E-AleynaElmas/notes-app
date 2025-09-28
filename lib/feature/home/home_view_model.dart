import 'dart:async';
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';
import 'package:notes_app/product/services/auth_service.dart';
import 'package:notes_app/product/services/note_service.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final IAuthService _auth;
  final INoteService _noteService;

  HomeViewModel({IAuthService? auth, INoteService? noteService})
    : _auth = auth ?? AuthService.instance,
      _noteService = noteService ?? NoteService.instance;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _searchDebounceTimer;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  final List<String> _filters = ['All', 'Work', 'Reading', 'Important'];
  List<String> get filters => _filters;

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NoteModel> get filteredNotes {
    List<NoteModel> filtered = _notes;
    if (_selectedFilter != 'All') {
      filtered = filtered.where((note) => note.tags.contains(_selectedFilter)).toList();
    }
    return filtered;
  }

  int get noteCount => filteredNotes.length;

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _noteService.getNotes(search: _searchQuery.isEmpty ? null : _searchQuery);

      if (result.status && result.data != null) {
        _notes = result.data!;
      } else {
        setError(result.message ?? 'Notlar yüklenemedi');
      }
    } catch (e) {
      setError('Bir hata oluştu: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadNotes();
    });
  }

  void selectFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      final result = await _noteService.deleteNote(noteId);

      if (result.status) {
        _notes.removeWhere((note) => note.id == noteId);
        notifyListeners();
        return true;
      } else {
        setError(result.message ?? 'Not silinemedi');
        return false;
      }
    } catch (e) {
      setError('Bir hata oluştu: $e');
      return false;
    }
  }

  Future<void> navigateToNewNote() async {
    final result = await NavigationService.instance.navigateToPage<bool>(navEnum: NavigationEnums.newNote);

    if (result == true) {
      loadNotes();
      NavigationService.instance.showSnackBar('Note saved successfully!');
    }
  }

  Future<bool> logout() async {
    setBusy(true);
    clearErrors();
    try {
      await _auth.logout();
      NavigationService.instance.navigateToPageClear(navEnum: NavigationEnums.init);
      return true;
    } catch (e) {
      setError('Çıkış başarısız: $e');
      return false;
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
