import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/widgets/create_task.dart';
import 'package:firebase_application/widgets/default_textfiled.dart';
import 'package:firebase_application/widgets/popup_menu_item_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const route = '/home-screen';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Item? selectedMenu;
  final CollectionReference _tasks =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.brown,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return const CreateTask();
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleController.text = documentSnapshot['title'];
      _descriptionController.text = documentSnapshot['description'].toString();
      _dateController.text = documentSnapshot['date'].toString();
    }
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.brown,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
              color: Colors.brown,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30,
                bottom: 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    controller: _titleController,
                    hintText: 'Title',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    controller: _descriptionController,
                    hintText: 'Description',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DefaultTextField(
                    controller: _dateController,
                    hintText: 'Due Date(dd/MM/yyyy)',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // Set border radius here
                        ),
                        primary: Colors.red, // Set the button color to red
                      ),
                      child: const Text('Update'),
                      onPressed: () async {
                        final String title = _titleController.text;
                        final String description = _descriptionController.text;
                        final String date = _dateController.text;

                        if (title != null) {
                          await _tasks.doc(documentSnapshot!.id).update({
                            "title": title,
                            "description": description,
                            "date": date,
                          });
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _tasks.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('All Tasks')),
      ),drawer: const SizedBox(),
      body: StreamBuilder(
        stream: _tasks.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            List<DataRow> rows = [];
            for (int index = 0;
            index < streamSnapshot.data!.docs.length;
            index++) {
              final DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];
              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      Text(
                        documentSnapshot['title'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton<Item>(
                          icon: const Icon(
                            Icons.more_vert, // Change the icon as needed
                            color: Colors.white, // Change the icon color here
                          ),
                          initialValue: selectedMenu,
                          onSelected: (Item item) async {
                            if (item == Item.edit) {
                              _update(streamSnapshot.data!.docs[index]);
                            }
                            if (item == Item.delete) {
                              _delete(streamSnapshot.data!.docs[index].id);
                            }
                            if (item == Item.completed) {
                              await _tasks
                                  .doc(documentSnapshot!.id)
                                  .update({
                                "completed": true,
                              });
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Item>>[
                            PopupMenuItem(
                                child: Text(
                                  documentSnapshot['title'].toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            PopupMenuItem(
                              child: Text(
                                documentSnapshot['description'].toString(),
                              ),
                            ),
                            const PopupMenuItem<Item>(
                                value: Item.status,
                                child: PopupMenuItemWidget(
                                  title: 'Status(Completed/Pending)',
                                  color: Colors.orange,
                                )),
                            const PopupMenuItem<Item>(
                              value: Item.edit,
                              child: PopupMenuItemWidget(
                                title: 'Edit',
                                color: Colors.blue,
                              ),
                            ),
                            const PopupMenuItem<Item>(
                              value: Item.delete,
                              child: PopupMenuItemWidget(
                                title: 'Delete',
                                color: Colors.red,
                              ),
                            ),
                            PopupMenuItem<Item>(
                              value: Item.completed,
                              child: PopupMenuItemWidget(
                                title: documentSnapshot['completed'] == false
                                    ? 'Mark as Completed'
                                    : 'Completed',
                                color: documentSnapshot['completed'] == false
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            const PopupMenuItem(
                              child: SizedBox(
                                height: 10,
                              ),
                            ),
                          ],
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width),
                          position: PopupMenuPosition.under,
                          offset: const Offset(0, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.white, // Choose your desired border color
                        width: 1.0, // Adjust the width of the border
                      ),
                      bottom: BorderSide(
                        color: Colors.white, // Choose your desired border color
                        width: 1.0, // Adjust the width of the border
                      ),
                    ),
                    showBottomBorder: true,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Title',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(left: 150),
                          child: Text(
                            'Action',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: rows,
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: InkWell(
        onTap: () => _create(),
        child: Container(
            padding: const EdgeInsets.only(left: 20),
            height: 70,
            decoration: const BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    color: Colors.brown,
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

enum Item { status, edit, delete, completed }