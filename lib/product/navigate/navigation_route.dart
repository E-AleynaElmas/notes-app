import 'package:flutter/material.dart';
import 'package:notes_app/feature/auth/auth_view.dart';
import 'package:notes_app/feature/home/home_view.dart';
import 'package:notes_app/feature/splash/splash_view.dart';
import 'package:notes_app/feature/new_note/new_note_view.dart';
import 'package:notes_app/feature/note_detail/note_detail_view.dart';
import 'package:notes_app/product/models/note_model.dart';
import 'package:notes_app/product/navigate/navigation_enums.dart';

class NavigationRoute {
  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name!.navValue) {
      case NavigationEnums.init:
        return _normalNavigate(const SplashView());
      case NavigationEnums.auth:
        return _normalNavigate(const AuthView());
      case NavigationEnums.home:
        return _normalNavigate(const HomeView());
      case NavigationEnums.newNote:
        return _normalNavigate(const NewNoteView());
      case NavigationEnums.editNote:
        final note = args.arguments as NoteModel;
        return _normalNavigate(NewNoteView(noteToEdit: note));
      case NavigationEnums.noteDetail:
        final note = args.arguments as NoteModel;
        return _normalNavigate(NoteDetailView(note: note));
    }
  }

  MaterialPageRoute _normalNavigate(Widget widget, {RouteSettings? settings, bool isFullScreen = false}) {
    return MaterialPageRoute(builder: (context) => widget, settings: settings, fullscreenDialog: isFullScreen);
  }
}
