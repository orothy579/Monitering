import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CO2moniter extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest CO2 PPM Data'),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _firestore.collection('my_collection').orderBy('timestamp', descending: true).limit(1).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Assuming 'xbee_data' contains the data we want to display
              String xbeeData = snapshot.data!.docs.first['xbee_data'] ?? "Data Unavailable";

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('CO2 PPM', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 20),
                    Text(xbeeData, style: Theme.of(context).textTheme.headline3),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GraphPage()),
                        );
                      },
                      child: Text('View Graph'),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
