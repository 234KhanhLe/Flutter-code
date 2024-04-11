import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'id': int id,
        'title': String title,
      } =>
        Album(userId: userId, id: id, title: title),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

Future<List<Album>> fetchAlbum(int page) async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => Album.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Map<String, dynamic>> fetchAlbumDetails(int id) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to load album detail');
  }
}

class FetchDataDetailApp extends StatelessWidget {
  final Map<String, dynamic> albumDetails;

  const FetchDataDetailApp({super.key, required this.albumDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar('Album Detail', context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                'User Id: ${albumDetails['userId']}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 20,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.normal),
              ),
              subtitle: Text('Title: ${albumDetails['title']}'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class FetchDataApp extends StatefulWidget {
  const FetchDataApp({super.key});

  @override
  State<FetchDataApp> createState() => _FetchDataApp();
}

PreferredSizeWidget _buildAppBar(String appTitle, BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.blueAccent.shade400),
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue, Colors.red],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          appTitle,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontSize: 35,
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

class _FetchDataApp extends State<FetchDataApp> {
  late Future<List<Album>> futureAlbum;
  int _currentPage = 0;
  late ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 50);
    futureAlbum = fetchAlbum(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: _buildAppBar('Album List', context),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final List<Album> albums = snapshot.data!;
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: albums.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == albums.length) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(albums[index].title),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  final id = albums[index].id;
                                  final detailData =
                                      await fetchAlbumDetails(id);
                                  if (context.mounted) {
                                    _moveToDetailView(context, detailData);
                                  }
                                },
                                icon: const Icon(Icons.more_vert))
                          ],
                        ));
                  },
                );
              } else {
                return const Text('No data');
              }
            },
          ),
        ),
      ),
    );
  }

  void _moveToDetailView(
      BuildContext context, Map<String, dynamic> detailDataAlbum) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FetchDataDetailApp(albumDetails: detailDataAlbum),
    ));
  }
}
