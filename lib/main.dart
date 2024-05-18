import 'package:contacts/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  var name = ['asad', 'zohaib', 'hassan', 'Niaz', 'awais', 'ameer', 'aamir', 'noor', 'junaid', 'hamid', 'hyder', 'ali', 'ayaz', 'ahmed', 'waseem'];
  var no = ['03000000082', '03400000002', '03700000008', '03368000000', '03470000012', '03056000034', '03996376800', '0347478', '03573577', '03556737', '0347376', '034563677', '0311555270', '0465636700', '03666288800'];

  void _addContact(String newName, String newNumber) {
    setState(() {
      name.add(newName);
      no.add(newNumber);
    });
  }

  void _deleteContact(int index) {
    setState(() {
      name.removeAt(index);
      no.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.contact_phone, color: Colors.black, size: 30),
        title: Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate(name, no, _deleteContact));
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              _showAddContactDialog(context);
            },
            icon: Icon(Icons.add),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.chat)),
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_rounded, color: Colors.yellowAccent)),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              _showDeleteContactDialog(context, index);
            },
            leading: Icon(Icons.call, color: Colors.green, size: 30),
            title: Text(name[index], style: TextStyle(fontSize: 22)),
            subtitle: Text(no[index]),
            trailing: Icon(Icons.chat, color: Colors.blue),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 5, thickness: 1, color: Colors.black);
        },
        itemCount: name.length,
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: 'Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                  _addContact(nameController.text, numberController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteContactDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                _deleteContact(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  final List<String> name;
  final List<String> no;
  final Function(int) deleteContactCallback;

  ContactSearchDelegate(this.name, this.no, this.deleteContactCallback);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildContactList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildContactList();
  }

  Widget _buildContactList() {
    final List<String> filteredNames = name.where((n) => n.toLowerCase().contains(query.toLowerCase())).toList();
    final List<String> filteredNumbers = filteredNames.map((filteredName) => no[name.indexOf(filteredName)]).toList();

    return ListView.separated(
      itemBuilder: (context, index) {
        final int actualIndex = name.indexOf(filteredNames[index]);
        return ListTile(
          onTap: () {
            _showDeleteContactDialog(context, actualIndex);
          },
          leading: Icon(Icons.call, color: Colors.green, size: 30),
          title: Text(filteredNames[index], style: TextStyle(fontSize: 22)),
          subtitle: Text(filteredNumbers[index]),
          trailing: Icon(Icons.chat, color: Colors.blue),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 5, thickness: 1, color: Colors.black);
      },
      itemCount: filteredNames.length,
    );
  }

  void _showDeleteContactDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                deleteContactCallback(index);
                Navigator.of(context).pop();
                showResults(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
