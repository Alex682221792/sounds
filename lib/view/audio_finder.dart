import 'package:flutter/material.dart';

class AudioFinder extends StatelessWidget {
  const AudioFinder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {

              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          /*Expanded(
            child: FutureBuilder<List<File>>(
              future: AudioFinderUtils.getMp3Files(),
              builder: (context, dataSnapshot) {
                if (!dataSnapshot.hasData) {
                  return Container();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    return AudioItem(dataSnapshot.data![index]);
                  },
                );
              }
            ),
          )*/
        ]
      )
    );
  }
}
