import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_chat/services/auth/auth_service.dart';
import 'package:flutter_chat/services/crud/notes_serive.dart';

class newNoteView extends StatefulWidget {
  const newNoteView({super.key});

  @override
  State<newNoteView> createState() => _newNotesViewState();
}

class _newNotesViewState extends State<newNoteView> {
  databasenote? _note; //? optional cx no value to start with
  late final notesService _noteservice;
  late final TextEditingController _textcontroller;

  void _textcontrollerlistener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _noteservice.updatenote(note: note, text: text);
  }

  void setuptextcontrollerlistener() {
    _textcontroller.removeListener(_textcontrollerlistener);
    _textcontroller.addListener(_textcontrollerlistener);
  }

  @override
  void initState() {
    _noteservice = notesService();
    _textcontroller = TextEditingController();
    super.initState(); //super calls the init of the parent class
  }

  Future<databasenote> createnewnote() async {
    final existingnote = _note;
    if (existingnote != null) {
      return existingnote;
    }
    final currentusser = authservice.firebase().currentuser!;
    final email = currentusser.email!;
    final owner = await _noteservice.getuser(email: email);
    return await _noteservice.createnote(owner: owner);
  }

  void deletenoteiftextisempty() {
    final note = _note;
    if (_textcontroller.text.isEmpty && note != null) {
      _noteservice.deletenote(id: note.id);
    }
  }

  void savenoteiftextisnotnull() async {
    final note = _note;
    final text = _textcontroller.text;
    if (note != null && text.isNotEmpty) {
      await _noteservice.updatenote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    deletenoteiftextisempty();
    savenoteiftextisnotnull();
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
          future: createnewnote(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                print("hahahah");
              }
              _note = snapshot.data; ////////////////////////////

              setuptextcontrollerlistener();
              return TextField(
                controller: _textcontroller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note',
                ),
              );
            } else {
              return const CircularProgressIndicator(); // loading
            }
          }),
    );
  }
}
