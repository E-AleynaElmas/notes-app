import 'dart:async';
import 'package:flutter/widgets.dart'; // <-- scroll controller için
import 'package:notes_app/core/services/navigation_service.dart';
import 'package:notes_app/product/constants/note_query_params.dart';
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
      _noteService = noteService ?? NoteService.instance {
    scrollController.addListener(() {
      if (!_hasMore || _isLoadingMore || _isLoading) return;
      final pos = scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 300) {
        loadMoreNotes();
      }
    });
  }
  final ScrollController scrollController = ScrollController();

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _searchDebounceTimer;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  final List<String> _filters = ['All', 'Work', 'Reading', 'Important'];
  List<String> get filters => _filters;

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  int _page = 1;
  int _limit = NoteQueryParams.defaultLimit;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<NoteModel> get filteredNotes {
    List<NoteModel> filtered = _notes;
    if (_selectedFilter != 'All') {
      filtered = filtered.where((note) => note.tags.contains(_selectedFilter)).toList();
    }
    return filtered;
  }

  int get noteCount => filteredNotes.length;

  Future<void> loadNotes({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _notes = [];
    }
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _noteService.getNotes(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        page: _page,
        limit: _limit,
      );

      if (result.status && result.data != null) {
        final fetched = result.data!;
        if (_page == 1 && !reset) _notes = [];
        _notes.addAll(fetched);
        if (result.pagination != null) {
          _limit = result.pagination!.pageSize;
          _hasMore = result.pagination!.hasNext;
        } else {
          _hasMore = fetched.length == _limit;
        }
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

  Future<void> loadMoreNotes() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _page + 1;
      final result = await _noteService.getNotes(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        page: nextPage,
        limit: _limit,
      );

      if (result.status && result.data != null) {
        final fetched = result.data!;
        _notes.addAll(fetched);

        if (result.pagination != null) {
          _hasMore = result.pagination!.hasNext;
          _page = result.pagination!.page;
        } else {
          _hasMore = fetched.length == _limit;
          if (_hasMore) _page = nextPage;
        }
      } else {
        setError(result.message ?? 'Notlar yüklenemedi');
      }
    } catch (e) {
      setError('Bir hata oluştu: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadNotes(reset: true);
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
      await loadNotes(reset: true);
      NavigationService.instance.showSnackBar('Note saved successfully!');
    }
  }

  Future<void> navigateToNoteDetail(NoteModel note) async {
    final result = await NavigationService.instance.navigateToPage<bool>(
      navEnum: NavigationEnums.noteDetail,
      data: note,
    );
    await loadNotes(reset: true);

    if (result == true) {
      NavigationService.instance.showSnackBar('Note deleted successfully!');
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
    scrollController.dispose();
    super.dispose();
  }
}
