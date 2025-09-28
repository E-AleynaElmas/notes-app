enum NoteEndpoints {
  notes('notes'),
  noteById('notes/{id}');

  const NoteEndpoints(this.path);
  
  final String path;
  
  String getPath({String? id}) {
    if (this == noteById && id != null) {
      return path.replaceAll('{id}', id);
    }
    return path;
  }
}
