import 'package:notes_app/product/manager/network_manager.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:notes_app/product/models/pagination_info.dart';
import 'package:notes_app/product/models/simple_result.dart';
import 'package:notes_app/product/constants/note_endpoints.dart';
import 'package:notes_app/product/constants/note_query_params.dart';

abstract class INoteService {
  Future<SimpleResult<List<NoteModel>>> getNotes({
    String? search,
    int page = NoteQueryParams.defaultPage,
    int limit = NoteQueryParams.defaultLimit,
  });

  Future<SimpleResult<NoteModel>> createNote(NoteModel note);
  Future<SimpleResult<NoteModel>> updateNote(String id, NoteModel note);
  Future<SimpleResult<bool>> deleteNote(String id);
}

class NoteService implements INoteService {
  NoteService._init();
  static final NoteService _instance = NoteService._init();
  static NoteService get instance => _instance;

  final NetworkManager _networkManager = NetworkManager.instance;

  @override
  Future<SimpleResult<List<NoteModel>>> getNotes({
    String? search,
    int page = NoteQueryParams.defaultPage,
    int limit = NoteQueryParams.defaultLimit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{NoteQueryParams.page: page, NoteQueryParams.limit: limit};

      if (search != null && search.isNotEmpty) {
        queryParameters[NoteQueryParams.search] = search;
      }

      final result = await _networkManager.request(
        RequestType.get,
        NoteEndpoints.notes.path,
        queryParameters: queryParameters,
        isBaseResponse: false,
      );

      if (result.status && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final notesList = responseData['notes'] as List<dynamic>;

        final pagination = PaginationInfo.fromJson(responseData);

        final notes = notesList.map((noteJson) => NoteModel.fromJson(noteJson)).toList();

        return SimpleResult<List<NoteModel>>(status: true, data: notes, pagination: pagination);
      } else {
        return SimpleResult<List<NoteModel>>(status: false, message: result.message ?? 'Not listesi alınamadı');
      }
    } catch (e) {
      return SimpleResult<List<NoteModel>>(status: false, message: 'Bir hata oluştu: $e');
    }
  }

  @override
  Future<SimpleResult<NoteModel>> createNote(NoteModel note) async {
    try {
      final result = await _networkManager.request(
        RequestType.post,
        NoteEndpoints.notes.path,
        data: note.toJson(),
        isBaseResponse: false,
      );

      if (result.status) {
        final noteModel = NoteModel.fromJson(result.data);
        return SimpleResult<NoteModel>(status: true, data: noteModel);
      } else {
        return SimpleResult<NoteModel>(status: false, message: result.message ?? 'Not oluşturulamadı');
      }
    } catch (e) {
      return SimpleResult<NoteModel>(status: false, message: 'Bir hata oluştu: $e');
    }
  }

  @override
  Future<SimpleResult<NoteModel>> updateNote(String id, NoteModel note) async {
    try {
      final result = await _networkManager.request(
        RequestType.put,
        NoteEndpoints.noteById.getPath(id: id),
        data: note.toJson(),
        isBaseResponse: false,
      );

      if (result.status) {
        final noteModel = NoteModel.fromJson(result.data);
        return SimpleResult<NoteModel>(status: true, data: noteModel);
      } else {
        return SimpleResult<NoteModel>(status: false, message: result.message ?? 'Not güncellenemedi');
      }
    } catch (e) {
      return SimpleResult<NoteModel>(status: false, message: 'Bir hata oluştu: $e');
    }
  }

  @override
  Future<SimpleResult<bool>> deleteNote(String id) async {
    try {
      final result = await _networkManager.request(
        RequestType.delete,
        NoteEndpoints.noteById.getPath(id: id),
        isBaseResponse: false,
      );

      return SimpleResult<bool>(status: result.status, data: result.status, message: result.message);
    } catch (e) {
      return SimpleResult<bool>(status: false, data: false, message: 'Bir hata oluştu: $e');
    }
  }
}
