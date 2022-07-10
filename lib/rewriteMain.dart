//this a rewrite of the main,dart file with the aim to fully understand the change notifier and the value
///listenable widgets
///according to my tos the contact app was created with a homepage to show the app
///and methodas to add , remove the contacts was also done
///the homepage has list tiles that wraps a text widget which is also wrapped by a valuelistenable
///widget that listens to the changenotifier that is extended by the class contactbook and this same class is
///called in the cta button in the add contact page
///so i will be trying to recreate what i learnt b4 peeping back
///god speed damilare

import "package:flutter/material.dart";
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    home: const DashboardPage(),
  ));
}

class dContact {
  String id;
  String name;
  dContact(this.name) : id = const Uuid().v4();
}

class dContactBook extends ValueNotifier<List<dContact>> {
  dContactBook._dSharedInstance() : super([]);
  static final dContactBook _dShared = dContactBook._dSharedInstance();
  factory dContactBook() => _dShared;

  void add({required dContact contact}) {
    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void delete({required dContact contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  dContact? contact({required int dIndex}) {
    value.length > dIndex ? value[dIndex] : null;
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts!!!'),
      ),
      body: ValueListenableBuilder(
          valueListenable: dContactBook(),
          builder: (BuildContext context, List<dContact> value, Widget? child) {
            final contacts = value;
            return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        dContactBook().delete(contact: contact);
                      },
                      key: ValueKey(contact.id),
                      child: Material(
                        elevation: 6.0,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(contact.name),
                        ),
                      ));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const AddContactsPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({Key? key}) : super(key: key);

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  final dController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contacts'),
      ),
      body: Column(
        children: [
          TextField(
            controller: dController,
            decoration:
                const InputDecoration(hintText: 'what do you want to save'),
          ),
          TextButton(
              onPressed: () {
                final contact = dContact(dController.text);
                dContactBook().add(contact: contact);
                Navigator.pop(context);
              },
              child: const Text('Add D Contact'))
        ],
      ),
    );
  }
}
