import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  int _selectedIndex = 0;
  bool _notificationsEnabled = true;
  double _notificationThreshold = 10;

  final List<String> _notifications = [
    'Notification 1',
    'Notification 2',
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_notificationsEnabled && _counter % _notificationThreshold.toInt() == 0  && _counter != 0) {
        _notifications.insert(0, 'You made $_counter taps!');
      }
    });
  }

  void _resetCounter() {
  setState(() {
    _counter = 0;
  });
  
  // Optional: Task for the students
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Counter reset to zero')),
  );
  _notifications.insert(0, 'You reset the counter to 0');
}

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [

      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Counter'),
            ),
          ],
        ),
      ),

      Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(_notifications[index] + index.toString()),

                onDismissed: (direction){
                  if (direction == DismissDirection.startToEnd){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notification Archived")),
                    );
                    setState(() {
                    _notifications.removeAt(index);
                  });
                  }else {
                    setState((){
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notification Deleted")),
                    );
                  }
                },
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.archive, color: Colors.white),
                ),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text(_notifications[index]),
                  subtitle: Text('This is a dynamic notification'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                  }, 
                ),
                ),
              ),);
            },
            ),
            ),
            ListView(
    children: [
      const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text("Notifications", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
      SwitchListTile(
        title: const Text("Enable Tap Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Get notified when hitting milestones"),
        value: _notificationsEnabled,
        secondary: const Icon(Icons.vibration),
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
      ),
      const Divider(),
      ListTile(
  title: const Text("Hitting milestone", style: TextStyle(fontWeight: FontWeight.bold)),
  subtitle: Text("Every ${_notificationThreshold.toInt()} taps"),
  leading: const Icon(Icons.emoji_events),
  onTap: () {
    // Create a controller to handle the text inside the dialog
    TextEditingController customController = TextEditingController(text: _notificationThreshold.toInt().toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Milestone"),
          content: TextField(
            controller: customController,
            keyboardType: TextInputType.number,
            autofocus: true, // Automatically opens the keyboard
            decoration: const InputDecoration(
              labelText: "Number of taps",
              suffixText: "taps",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                double? newValue = double.tryParse(customController.text);
                if (newValue != null && newValue > 0) {
                  setState(() => _notificationThreshold = newValue);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  },
),
    ],
  ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: pages[_selectedIndex],

      floatingActionButton: _selectedIndex == 0
      ? FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      )
      : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.calculate),
            icon: Icon(Icons.calculate_outlined),
            label: 'Counter',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_sharp),
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),

          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        
      ),
    );
  }
}