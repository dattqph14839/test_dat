import 'package:flutter/cupertino.dart';
import 'package:untitled/models/note_model.dart';

class NoteController extends ChangeNotifier {
  List<NoteModel> listOfNotes = [
    NoteModel(
        title: 'first',
        content:
            'abc',
        time: DateTime.now())
  ];

  void sortNewest() {
    listOfNotes.sort((a, b) {
      return a.time!.millisecondsSinceEpoch
          .compareTo(b.time!.millisecondsSinceEpoch);
    });
    listOfNotes = listOfNotes.reversed.toList();
    notifyListeners();
  }

  void sortAlphabet() {
    listOfNotes.sort((a, b) {
      return a.title!.compareTo(b.title!);
    });
    notifyListeners();
  }

  void addNote(NoteModel noteModel) {
    listOfNotes.add(noteModel);
    notifyListeners();
  }

  void editNote(NoteModel editedNote, int index) {
    listOfNotes[index] = editedNote;
    notifyListeners();
  }

  void deleteNote(int index) {
    listOfNotes.removeAt(index);
    notifyListeners();
  }
  NoteModel? findByTitle(String title){
    return listOfNotes.firstWhere((element) => element.title == title);
  }
  // void search(String keyword) async {
  //   List<Map<String, dynamic>> res = await databaseHelper.search(keyword);
  //   searchResults.assignAll((res.map((task) => Task.fromJson(task))).toList());
  // }
}
