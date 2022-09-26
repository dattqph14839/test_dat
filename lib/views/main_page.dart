import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/controllers/note_controller.dart';
import 'package:untitled/models/note_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _value = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void handleClick(int item) {
    switch (item) {
      case 0:
        {
          context.read<NoteController>().sortAlphabet();
          break;
        }

      case 1:
        {
          context.read<NoteController>().sortNewest();
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            _buildDialog("Add Todo");
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('ToDo'),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(value: 0, child: Text('A-Z')),
                const PopupMenuItem<int>(value: 1, child: Text('Newest')),
              ],
            ),
          ],
        ),
        body: context.watch<NoteController>().listOfNotes.isEmpty
            ? const Center(child: Text('Empty'))
            : ListView.builder(
          itemCount: context.watch<NoteController>().listOfNotes.length,
          itemBuilder: ((context, index) => GestureDetector(
            onTap: () => _buildDetailsDialog(
                Provider.of<NoteController>(context, listen: false)
                    .listOfNotes[index]),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _value = !_value;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: _value
                                      ? const Icon(
                                    Icons.check,
                                    size: 20.0,
                                    color: Colors.green,
                                  )
                                      : const SizedBox(
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width:
                          MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                context
                                    .watch<NoteController>()
                                    .listOfNotes[index]
                                    .title!,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                context
                                    .watch<NoteController>()
                                    .listOfNotes[index]
                                    .content!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                context
                                    .watch<NoteController>()
                                    .listOfNotes[index]
                                    .time
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.edit,
                                ),
                              ),
                              onTap: () {
                                _buildDialog("Edit ToDo",
                                    editIndex: index,
                                    note: Provider.of<NoteController>(
                                        context,
                                        listen: false)
                                        .listOfNotes
                                        .elementAt(index));
                              },
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.delete,
                                ),
                              ),
                              onTap: () {
                                _buildDeleteDialog(
                                    context,
                                    Provider.of<NoteController>(
                                        context,
                                        listen: false)
                                        .listOfNotes
                                        .elementAt(index)
                                        .title!,
                                    index);
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          )),
        ));
  }

  _buildDeleteDialog(BuildContext context, String title, int index) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      context.read<NoteController>().deleteNote(index);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue),
                    )),
              ],
              content: Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'You sure want to delete this item?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              )));

  _buildDialog(String action, {NoteModel? note, int? editIndex}) {
    if (note != null) {
      _titleController.text = note.title!;
      _contentController.text = note.content!;
    } else {
      _titleController.text = '';
      _contentController.text = '';
    }
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 330,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      action,
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Title can not empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: _contentController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Content can not empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Content',
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (note != null) {
                                context.read<NoteController>().editNote(
                                    NoteModel(
                                        title: _titleController.text,
                                        content: _contentController.text,
                                        time: DateTime.now()),
                                    editIndex!);
                              } else {
                                context.read<NoteController>().addNote(
                                    NoteModel(
                                        title: _titleController.text,
                                        content: _contentController.text,
                                        time: DateTime.now()));
                              }
                              _titleController.clear();
                              _contentController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            action,
                            style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            )));
  }

  _buildDetailsDialog(NoteModel note) {
    DateFormat dateFormat = DateFormat("HH:mm:ssa dd-MM-yyyy");
    _titleController.text = note.title!;
    _contentController.text = note.content!;
    _dateController.text = dateFormat.format(note.time!);

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 280,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ToDo details',
                      style:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            readOnly: true,
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: _contentController,
                            decoration: const InputDecoration(
                              labelText: 'Content',
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: _dateController,
                            decoration: const InputDecoration(
                              labelText: 'Time',
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
