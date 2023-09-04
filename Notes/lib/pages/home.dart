import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Notlar/constants/colors.dart';
import 'package:Notlar/models/note.dart';
import 'package:Notlar/pages/edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}


class _HomePage extends State<HomePage> {
  List<Note> filteredNotes = [];
  List<Note> sampleNotes = Note.sampleNotes;
  bool sorted = false;
  bool lightModeEnabled = false;

  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }

  List<Note> sortNotesByModifierTime(List<Note> notes) {
    if(sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;

    return notes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = sampleNotes
          .where((note) =>
            note.content.toLowerCase().contains(searchText.toLowerCase()) ||
            note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
    });
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
                const Text(
                  "Notlar",
                  style: TextStyle(
                    color: Color.fromARGB(255, 230, 172, 0), fontSize: 30, fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(onPressed: (){
                  setState(() {
                    filteredNotes = sortNotesByModifierTime(filteredNotes);
                  });
                },
                    icon: Icon(Icons.sort, color: Colors.white),
                  ),
              ],
            ),

           const SizedBox(
             height: 20,
           ),

           TextField(
             onChanged: (value) {
               onSearchTextChanged(value);
             },
             style: const TextStyle(fontSize: 16, color: Colors.white),
             decoration: InputDecoration(
               contentPadding: const EdgeInsets.symmetric(vertical: 12),
               hintText: "Notları ara...",
               hintStyle: const TextStyle(color: Colors.grey),
               prefixIcon: const Icon(Icons.search, color: Colors.grey,),
               fillColor: Colors.grey.shade800,
               filled: true,
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(30),
                 borderSide: const BorderSide(color: Colors.transparent)
               ),
               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(30),
                 borderSide: const BorderSide(color: Colors.transparent)
               ),
             ),
           ),

           Expanded(
               child: ListView.builder(
                 padding: EdgeInsets.only(top: 30),
                 itemCount: filteredNotes.length,
                 itemBuilder: (context, index) {
                   return Card(
                     color: Colors.white,
                     elevation: 3,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditPage(note: filteredNotes[index]),
                            ),
                          );
                          if(result!=null){
                            setState(() {
                              int originalIndex = sampleNotes.indexOf(filteredNotes[index]);
                              sampleNotes[originalIndex] = (Note(
                                  title: result[0],
                                  modifiedTime: DateTime.now(),
                                  id: sampleNotes[originalIndex].id,
                                  content: result[1])
                              );
                              filteredNotes[index] = (Note(
                                  title: result[0],
                                  modifiedTime: DateTime.now(),
                                  id: sampleNotes[index].id,
                                  content: result[1])
                              );
                            });
                          }
                        },
                         title: RichText(
                           maxLines: 4,
                           text: TextSpan(
                             text: "${filteredNotes[index].title} \n",
                             style: TextStyle(
                                 color: Colors.grey.shade900,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18,
                                 height: 1.5
                             ),
                             children: [
                               TextSpan(
                                 text: "${filteredNotes[index].content}",
                                 style: TextStyle(
                                     color: Colors.grey.shade800,
                                     fontWeight: FontWeight.normal,
                                     fontSize: 14,
                                     height: 1.5
                                 ),
                               ),
                             ],
                           ),
                         ),
                         subtitle: Padding(
                           padding: EdgeInsets.only(top: 8.0),
                           child: Text(
                             'Düzenlendi: ${DateFormat('M d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                             style: TextStyle(
                                 fontSize: 10,
                                 fontStyle:
                                 FontStyle.italic,
                                 color: Colors.grey.shade700
                             ),
                           ),
                         ),
                         trailing: IconButton(
                           onPressed: () async{
                             final result = await confirmDialogue(context);
                             if(result) {
                               deleteNote(index);
                             }
                           },
                           icon: Icon(Icons.delete, color: Colors.grey.shade800,),
                         ),
                       ),
                     ),
                   );
                 },
               ),
           ),
         ],
       ),
     ),
     floatingActionButton: FloatingActionButton(
       onPressed: () async {
      final result = await Navigator.push(context,
          MaterialPageRoute(
          builder: (BuildContext context) => const EditPage(),
          ),
        );

        if(result!=null){ 
          setState(() {
            sampleNotes.add(Note(
                title: result[0],
                modifiedTime: DateTime.now(),
                id: sampleNotes.length,
                content: result[1])
            );
            filteredNotes = sampleNotes;
          });
        }

       },
       elevation: 10,
       backgroundColor: Colors.grey.shade800,
       child: Icon(Icons.add, size: 38,),
     ),
   );
  }



  Future<dynamic> confirmDialogue(BuildContext context) {
    return showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   backgroundColor: Colors.grey.shade900,
                                   icon: Icon(Icons.info, color: Colors.grey,),
                                   title: Text(
                                     'Silmek istediğinizden emin misiniz?',
                                     style: TextStyle(
                                       color: Colors.white,
                                     ),
                                   ),
                                   content: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       ElevatedButton(
                                         onPressed: () {
                                           Navigator.pop(context, true);
                                         },
                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green,),
                                         child: SizedBox(
                                           width: 60,
                                           child: Text(
                                             'Evet',
                                             textAlign: TextAlign.center,
                                           ),
                                         ),
                                       ),
                                       ElevatedButton(
                                         onPressed: (){
                                           Navigator.pop(context, false);
                                         },
                                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                                         child: SizedBox(
                                           width: 60,
                                           child: Text(
                                             'Hayır',
                                             textAlign: TextAlign.center,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 );
                               }
                           );
  }

}

