import 'package:flutter/material.dart';
import 'package:Notlar/models/note.dart';

class EditPage extends StatefulWidget {
  final Note? note;
  const EditPage({super.key, this.note});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if(widget.note != null) {
    _titleController = TextEditingController(text: widget.note!.title);
    _contentController = TextEditingController(text: widget.note!.content);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
       padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(.8),
                        borderRadius: BorderRadius.circular(10)
                      ),
                    child: const Icon(Icons.arrow_back, color: Colors.white,),
                  ),
                ),
              ],
            ),
            Expanded(child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Başlık",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)
                  ),
                ),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Colors.white,),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Buraya bir şeyler yazın",
                    hintStyle: TextStyle(color: Colors.grey,)
                  ),
                )
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, [_titleController.text, _contentController.text]);
        },
        backgroundColor: Colors.grey.shade800,
        child: Icon(Icons.save),
      ),
    );
  }
}