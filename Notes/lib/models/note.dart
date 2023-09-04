import 'package:flutter/material.dart';

class Note {
  String title;
  String content;
  int id;
  DateTime modifiedTime;

  Note({
    required this.title,
    required this.modifiedTime,
    required this.id,
    required this.content,
  });

  static List<Note> sampleNotes = [];
}