import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NoteModel {
  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final List<String> tags;
  final String color;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool synced;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.isPinned = false,
    this.tags = const [],
    this.color = '#FFFFFF',
    this.createdAt,
    this.updatedAt,
    this.synced = false,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    bool? isPinned,
    List<String>? tags,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
