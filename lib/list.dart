import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapt/testgoogle.dart';

import 'details.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {



  @override
  get Mapo=>FirebaseFirestore.instance.collection
    ('Mapo')
      .orderBy('datee', descending: true).
  snapshots();

  void initState() {
    CollectionReference Mapo = FirebaseFirestore.instance.
    collection('Mapo');
    super.initState();
  }
  Future deleteUser(id)async {
    FirebaseFirestore.instance
        .collection("Mapo")
        .doc(id)
        .delete()
        .then((value) => print('Product Deleted'))
        .catchError((error) => print('failed to delete Product:$error'));


    //print("User Deleted $id");
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(stream: Mapo,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Scaffold(
              appBar: AppBar(
                title: Text('Home'),
                // backgroundColor: const Color.fromRGBO(100, 0, 0, 10),


              ),

              body:
              Center(
                  child:Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            FloatingActionButton.extended(
                              backgroundColor:Colors.blue,

                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Homepanel()));
                              },
                              //  icon: Icon(Icons.directions_bike),
                              label: Text('Upload '),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Text(snapshot.data!.docs.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount:   snapshot.data!.docs.length,

                            itemBuilder: (context,index){
                              final  produt = snapshot.data!.docs[index];


                              return Container(


                                child: Card(

                                  child:

                                  ListTile(

                                    leading: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          minWidth: 100,
                                          minHeight: 260,
                                          maxWidth: 104,
                                          maxHeight: 264
                                      ),


                                      child:Row(
                                        children: [
                                          Text((index+1).toString()),
                                          Image.network(produt.get('image'),width: 60,height: 60,),
                                        ],
                                      ),),
                                    title: Text(produt.get('title'),style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                                    subtitle: Text(produt.get('contact').toString(),style: TextStyle(fontSize: 15),),
                                    //   trailing: Text('Rs '+product.get('date').+'/-',style: TextStyle(fontSize: 15),),
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) => Maptest(produt.get('lati'),produt.get('long'))));
                                    },
                                    trailing: Column(
                                      children: [
                                        InkWell(
                                            onTap:(){
                                              deleteUser(produt.id);
                                            },
                                            child: Icon(Icons.delete)),

                                        InkWell(
                                            onTap:(){
                                             // Navigator.push(context, MaterialPageRoute(builder: (context)=>Edit(produt) ));
                                              print(produt.id);
                                            },
                                            child: Icon(Icons.edit)),
                                      ],
                                    ),

                                  ),

                                ),


                              );


                            }),
                      ),
                    ],
                  )


              )

          );
        }
    );
  }
}

