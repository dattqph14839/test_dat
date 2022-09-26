class NoteModel {
  String? title;
  String? content;
  DateTime? time;

  NoteModel({this.title, this.content, this.time});

  NoteModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['time'] = time;
    return data;
  }
}
