import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_article_state.dart';

class AddArticleCubit extends Cubit<AddArticleState> {
  AddArticleCubit() : super(AddArticleInitial());

  String _currentFileName = 'Markdown';

  Future<void> openFile() async {
    emit(AddArticleLoading());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
      );
      if (result != null) {
        final path = result.files.single.path ?? "";
        final fileName = path.substring(
          path.lastIndexOf("/") + 1,
          path.lastIndexOf("."),
        );
        final file = File(path);
        final content = await file.readAsString();
        _currentFileName = fileName;
        emit(AddArticleFileLoaded(content, fileName));
      } else {
        emit(AddArticleInitial());
      }
    } catch (e) {
      emit(AddArticleError("Unable to open file: $e"));
    }
  }

  Future<void> saveFile(String currentContent) async {
    if (currentContent.trim().isEmpty) {
      emit(const AddArticleError("Content is empty"));
      return;
    }
    
    try {
      await FilePicker.platform.saveFile(
        dialogTitle: 'Save Markdown File',
        fileName: (!kIsWeb && Platform.isWindows) ? null : "$_currentFileName.md",
        type: FileType.custom,
        allowedExtensions: ['md'],
        bytes: utf8.encode(currentContent),
      );
      emit(AddArticleInitial());
    } catch (e) {
      emit(AddArticleError("Unable to save file: $e"));
    }
  }

  void clearText() {
    emit(const AddArticleFileLoaded('', 'Markdown'));
  }
}
