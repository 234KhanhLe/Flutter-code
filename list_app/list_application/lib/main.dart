import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // runApp(MyApp(
  //   items: List<ListItem>.generate(
  //     1000,
  //     (i) => i % 6 == 0
  //         ? HeadingItem('Heading $i')
  //         : MessageItem('Sender $i', 'Message $i'),
  //   ),
  // ));

  // runApp(const SpaceItemList());
  // runApp(
  //     LongItemList(itemsList: List<String>.generate(1000, (i) => 'Item $i')));
  // runApp(const FloatingAppBar());

  // runApp(const OrientationView());
  runApp(const ThemeShareColorsAndFont());
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubTitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildSubTitle(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildTitle(BuildContext context) {
    return Text(heading, style: Theme.of(context).textTheme.headlineSmall);
  }
}

class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildSubTitle(BuildContext context) => Text(body);
  @override
  Widget buildTitle(BuildContext context) => Text(sender);
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;
  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubTitle(context),
            );
          },
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String text;
  const ItemWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    Card card = Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text(text),
        ),
      ),
    );
    return card;
  }
}

class SpaceItemList extends StatelessWidget {
  const SpaceItemList({super.key});

  @override
  Widget build(BuildContext context) {
    const items = 10;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LayoutBuilder(builder: ((context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                    items, (index) => ItemWidget(text: 'Item $index')),
              ),
            ),
          );
        })),
      ),
    );
  }
}

class LongItemList extends StatelessWidget {
  final List<String> itemsList;
  const LongItemList({super.key, required this.itemsList});
  @override
  Widget build(BuildContext context) {
    const title = 'Long List';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: itemsList.length,
          prototypeItem: ListTile(
            title: Text(itemsList.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(itemsList[index]),
            );
          },
        ),
      ),
    );
  }
}

class FloatingAppBar extends StatelessWidget {
  const FloatingAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    const supperTitle = 'Floating app bar';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: supperTitle,
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text(supperTitle),
              floating: true,
              flexibleSpace: Placeholder(),
              expandedHeight: 200,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text('Item #$index')),
              childCount: 1000,
            ))
          ],
        ),
      ),
    );
  }
}

class OrientationView extends StatelessWidget {
  const OrientationView({super.key});
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Orientation Demo';

    return const MaterialApp(
      title: appTitle,
      home: OrientationList(
        title: appTitle,
      ),
    );
  }
}

class OrientationList extends StatelessWidget {
  final String title;

  const OrientationList({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            children: List.generate(100, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                )),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Text with a background color',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                ),
          ),
        ),
      ),
      floatingActionButton: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          )),
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          )),
      bottomNavigationBar: NavigationBar(destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.circle_notifications), label: 'Notification'),
        NavigationDestination(
            icon: Icon(Icons.account_circle), label: 'Profile'),
      ]),
    );
  }
}

class ThemeShareColorsAndFont extends StatelessWidget {
  const ThemeShareColorsAndFont({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'Custom Themes';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displayMedium: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(title: appName),
    );
  }
}
