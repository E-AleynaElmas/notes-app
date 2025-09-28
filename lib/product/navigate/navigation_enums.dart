enum NavigationEnums {
  init,
  auth,
  home,
  newNote,
  editNote,
  noteDetail;

  String get rawValue => switch (this) {
    _ => '/$name',
  };
}

extension StringExtension on String {
  NavigationEnums get navValue {
    if (this == '/') return NavigationEnums.init;
    return NavigationEnums.values.firstWhere(
      (element) => element.name == substring(1),
      orElse: () => NavigationEnums.init,
    );
  }
}