import 'package:crud/services/firebase_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase - CRUD'),
      ),
      body: FutureBuilder(
          future: getPeople(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: ((context, index) {
                    return Dismissible(
                      onDismissed: ((direction) async {
                        await deletePeople(snapshot.data?[index]['uid'])
                            .then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Eliminado'),
                          ));

                          snapshot.data?.removeAt(index);
                        });
                      }),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      key: Key(snapshot.data?[index]['uid']),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  '¿Quieres eliminar a ${snapshot.data?[index]['name']}?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes'),
                                )
                              ],
                            );
                          },
                        );
                        return confirmed;
                      },
                      child: ListTile(
                        title: Text(snapshot.data?[index]['name']),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/edit',
                              arguments: {
                                'name': snapshot.data?[index]['name'],
                                'uid': snapshot.data?[index]['uid'],
                              });

                          setState(() {});
                        },
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
