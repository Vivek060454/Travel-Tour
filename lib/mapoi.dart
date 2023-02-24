import 'dart:async';
import 'dart:convert';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapt/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import 'details.dart';
import 'login.dart';

class Draweer extends StatefulWidget {
  @override
  _DraweerState createState() => _DraweerState();
}

class _DraweerState extends State<Draweer> {
  Completer<GoogleMapController> _controller = Completer();



static final CameraPosition _kgoogleplex=const CameraPosition(
    target: LatLng(19.1955645,72.9630627),
  zoom: 14

);
// List<Marker> _marker=[
//   Marker(
//       markerId: MarkerId('1'),
//       position:  LatLng(19.1957717,72.9626841),
//       infoWindow: InfoWindow(
//           title: 'hji'
//       ),
//       onTap: (){
//         // Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
//
//       }
//
//
//   ),
//   Marker(
//       markerId: MarkerId('2'),
//       position:  LatLng(19.1962183,72.957856,),
//       infoWindow: InfoWindow(
//           title: 'hurrhj'
//       )
//
//   ),
//   Marker(
//       markerId: MarkerId('3'),
//       position:  LatLng(19.190957,72.961532),
//       infoWindow: InfoWindow(
//           title: 'hj'
//       ),
//
//       onTap: (){
//
//       }
//
//   ),
// ];


 List<Marker> _list=[
  Marker(
    markerId: MarkerId('1'),
    position:  LatLng(19.1957717,72.9626841),
    infoWindow: InfoWindow(
      title: 'hji'
    ),
    onTap: (){
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));

    }


  ),
  Marker(
      markerId: MarkerId('2'),
      position:  LatLng(19.1962183,72.957856,),
      infoWindow: InfoWindow(
          title: 'huhj'
      )

  ),
   Marker(
      markerId: MarkerId('3'),
      position:  LatLng(19.190957,72.961532),
      infoWindow: InfoWindow(
          title: 'hj'
      ),

     onTap: (){

     }

  ),
] ;

  get MapoStream =>FirebaseFirestore.instance.collection
    ('Mapo').

  snapshots();

  void initState(){
    final _auth = FirebaseAuth.instance;
    _getCurrentPosition();
    CollectionReference Mapo = FirebaseFirestore.instance.
    collection('Mapo');
  }
  String? _currentAddress;
  Position? _currentPosition;
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getnearbylocation() async{


  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
//
  CustomInfoWindowController _customInfoWindowController=CustomInfoWindowController();
  @override
  Widget build(BuildContext context) {

    return _currentPosition==null ?
    //check if loading is true or false
    Loading()

        :StreamBuilder<QuerySnapshot>(stream:MapoStream,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          final List  storedocs  = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String,dynamic>;
            storedocs .add(a);
            a['id'] = document.id;
          }).toList();
    //       var c;
    //       for (var i=0; i<storedocs.length;i++){
    //  var s=     Geolocator.distanceBetween( _currentPosition!.latitude,_currentPosition!.longitude,double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long']));
    // var a= s/1000;
    //  c = a.toString().substring(0, 4);
    //  print(c);
    //       }

          List<Marker> _marker=[
            for (var i=0; i<storedocs.length;i++)...[

            Marker(
                markerId: MarkerId(storedocs[i]['id']),
                position:  LatLng(double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long'])),
               infoWindow: InfoWindow(
                   title: storedocs[i]['title']

               ),

                onTap: (){

                  showModalBottomSheet(context: context,
                      isScrollControlled:true,

                      builder:(context,


                          )

                      {




                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                ),
                                color: Colors.transparent,
                              ),
                              height: 600,

                              child: Container(decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30),),

                              ),
                                  child:Column(
                                    children: [


                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.linear_scale),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Table(
                                          columnWidths: {
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(2),


                                          },

                                          children: [

                                            TableRow(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap:(){
                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                              },
                                                              child: Text('  View Detail',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                                          Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        InkWell(

                                                            onTap:() async {
                                                              final mapDir =
                                                                  "https://www.google.com/maps/dir/?api=1&destination=${storedocs[i]['lati']},${storedocs[i]['long']}";
                                                              if (await canLaunch(mapDir)) {
                                                                launch(mapDir);
                                                              }
                                                            },
                                                            child: Text('Direction',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                                        Icon(Icons.directions,color: Color.fromRGBO(246, 99, 9, 100)),
                                                      ],
                                                    ),
                                                  ),




                                                ]
                                            ),

                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                        child: SizedBox(
                                          height: 200,
                                          child: Container(
                                            color:   Colors.white,
                                            child: CarouselSlider(items: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      image: DecorationImage(

                                                          image: NetworkImage(storedocs[i]['image'] ),fit: BoxFit.fill
                                                      )
                                                  ),

                                                ),
                                              ), Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(storedocs[i]['img1'] ),fit: BoxFit.fill
                                                      )
                                                  ),

                                                ),
                                              ), Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      image: DecorationImage(
                                                          image: NetworkImage(storedocs[i]['img2'] ),fit: BoxFit.fill
                                                      )
                                                  ),

                                                ),
                                              ),
                                            ], options: CarouselOptions(
                                                enlargeCenterPage: true,
                                                viewportFraction: 0.9,

                                                autoPlay: true,
                                                autoPlayInterval: const Duration(seconds: 5),
                                                height: 450





                                            )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          color:   Colors.white,
                                          child: Column(
                                            children: [

                                              Padding(
                                                padding: const  EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                child:   storedocs[i]['title']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                Text(storedocs[i]['title'],maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromRGBO(246, 99, 9, 100)),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DefaultTabController(
                                            length: 3, // length of tabs
                                            initialIndex: 0,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                              Container(
                                                child: TabBar(
                                                  indicatorColor: Color.fromRGBO(246, 99, 9, 100),
                                                  labelColor: Color.fromRGBO(246, 99, 9, 100),
                                                  unselectedLabelColor: Colors.black,
                                                  tabs: [
                                                    Tab(text: 'Overview'),
                                                    Tab(text: 'Photos'),
                                                    Tab(text: 'Amentities'),
                                                    // Tab(text: 'Tab 4'),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 240, //height of TabBarView
                                                  decoration: BoxDecoration(
                                                      border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                                                  ),
                                                  child: TabBarView(children: <Widget>[
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Container(
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                child: Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(1),
                                                                    1: FlexColumnWidth(3),

                                                                  },

                                                                  children: [

                                                                    TableRow(

                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [

                                                                                    Icon(Icons.location_pin,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [

                                                                                storedocs[i]['Addrese']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                Text(storedocs[i]['Addrese'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                                                              ],
                                                                            ),
                                                                          ),




                                                                        ]
                                                                    ),
                                                                    TableRow(

                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [

                                                                                    Icon(Icons.handshake,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [

                                                                                storedocs[i]['trust_name']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                Column(
                                                                                  children: [
                                                                                    Text(storedocs[i]['trust_name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                                  ],
                                                                                ),

                                                                              ],
                                                                            ),
                                                                          ),




                                                                        ]
                                                                    ),
                                                                    TableRow(

                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [

                                                                                    Icon(Icons.call,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [

                                                                                storedocs[i]['contact']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                InkWell(
                                                                                    onTap:(){

                                                                                      FlutterPhoneDirectCaller.callNumber(storedocs[i]['contact']);
                                                                                    },
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(storedocs[i]['contact'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                                      ],
                                                                                    )),

                                                                              ],
                                                                            ),
                                                                          ),




                                                                        ]
                                                                    ),
                                                                    TableRow(

                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [

                                                                                    Icon(Icons.webhook_sharp,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Column(
                                                                              children: [

                                                                                storedocs[i]['website']==''? Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                InkWell  (
                                                                                    onTap:() async{


                                                                                      var uri = Uri.parse(storedocs[i]['website'].toString());
                                                                                      if (await canLaunchUrl(uri)){
                                                                                        await launchUrl(uri);
                                                                                      } else {
                                                                                        // can't launch url
                                                                                      }


                                                                                    },
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(storedocs[i]['website'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blue),),
                                                                                      ],
                                                                                    )),

                                                                              ],
                                                                            ),
                                                                          ),




                                                                        ]
                                                                    ),


                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Container(
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                child: Table(
                                                                  columnWidths: {
                                                                    0: FlexColumnWidth(2),
                                                                    1: FlexColumnWidth(2),
                                                                    2: FlexColumnWidth(2),

                                                                  },

                                                                  children: [

                                                                    TableRow(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Container(
                                                                              color:   Colors.white,
                                                                              child:
                                                                              FadeInImage.assetNetwork(
                                                                                  placeholder: 'assets/tem.jpg',
                                                                                  image:  storedocs[i]['image'],width: 130,height: 70
                                                                              ),


                                                                              //  Image.network(storedocs[i]['image'],width: 130,height: 70)
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Container(
                                                                              color:   Colors.white,
                                                                              child:
                                                                              FadeInImage.assetNetwork(
                                                                                  placeholder: 'assets/tem.jpg',
                                                                                  image:  storedocs[i]['img1'],width: 130,height: 70
                                                                              ),
                                                                              // Image.network(storedocs[i]['img1'],width: 130,height: 70)
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Container(
                                                                              color:   Colors.white,
                                                                              child:
                                                                              FadeInImage.assetNetwork(
                                                                                  placeholder: 'assets/tem.jpg',
                                                                                  image: storedocs[i]['img2'],width: 130,height: 70
                                                                              ),
                                                                              // Image.network(storedocs[i]['img2'],width: 130,height: 70)
                                                                            ),
                                                                          ),




                                                                        ]
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection: Axis.vertical,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          child: Center(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  child: storedocs[i]['Ami1']==''?  null: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:  Container(

                                                                      color:   Colors.white,

                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                        },
                                                                        child:ListTile(
                                                                          title:
                                                                          Text(storedocs[i]['Ami1'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                          leading: ConstrainedBox(
                                                                              constraints: const BoxConstraints(
                                                                                  minWidth: 50,
                                                                                  minHeight: 80,
                                                                                  maxWidth: 55,
                                                                                  maxHeight: 85
                                                                              ),
                                                                              child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: storedocs[i]['Ami2']==''?  null: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:  Container(

                                                                      color:   Colors.white,

                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                        },
                                                                        child:ListTile(
                                                                          title:
                                                                          Text(storedocs[i]['Ami2'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                          leading: ConstrainedBox(
                                                                              constraints: const BoxConstraints(
                                                                                  minWidth: 50,
                                                                                  minHeight: 80,
                                                                                  maxWidth: 55,
                                                                                  maxHeight: 85
                                                                              ),
                                                                              child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: storedocs[i]['Ami3']==''?  null: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:  Container(

                                                                      color:   Colors.white,

                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                        },
                                                                        child:ListTile(
                                                                          title:
                                                                          Text(storedocs[i]['Ami3'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                          leading: ConstrainedBox(
                                                                              constraints: const BoxConstraints(
                                                                                  minWidth: 50,
                                                                                  minHeight: 80,
                                                                                  maxWidth: 55,
                                                                                  maxHeight: 85
                                                                              ),
                                                                              child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: storedocs[i]['Ami4']==''?  null: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:  Container(

                                                                      color:   Colors.white,

                                                                      child: InkWell(
                                                                        onTap: (){
                                                                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                        },
                                                                        child:ListTile(
                                                                          title:
                                                                          Text(storedocs[i]['Ami4'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                          leading: ConstrainedBox(
                                                                              constraints: const BoxConstraints(
                                                                                  minWidth: 50,
                                                                                  minHeight: 80,
                                                                                  maxWidth: 55,
                                                                                  maxHeight: 85
                                                                              ),
                                                                              child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),


                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // SingleChildScrollView(
                                                    //   scrollDirection: Axis.vertical,
                                                    //   child: Container(
                                                    //     child: Center(
                                                    //       child: Column(
                                                    //         children: [
                                                    //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                    //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                    //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                    //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                    //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ])
                                              )
                                            ])
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        );
                      }
                  );

                }


            ),
]
          ];
          return snapshot.connectionState==ConnectionState.waiting||_currentPosition==null ? //check if loading is true or false
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Check internet connection or location')
              ],
            ),
          ):MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text('Maps '),

                backgroundColor: Color.fromRGBO(246, 99, 9, 100)
              ),
              drawer: Container(
                color:Colors.white,
                child: Drawer(

                  // Add a ListView to the drawer. This ensures the user can scroll
                  // through the options in the drawer if there isn't enough vertical
                  // space to fit everything.
                    child: Container(
                      child: ListView(
                        //Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[




                          ListTile(
                            leading: const Icon(Icons.logout_outlined,color: Color.fromARGB(255,0 , 18, 50),),
                            title: const Text("Sign Out"),
                            onTap: ()  async {
                              FirebaseAuth.instance.signOut();
                              // await storage.delete(key: 'uid');
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));
                              //  Navigator.popAndPushNamed(context, 'login');
                            },
                          ),
                        ],
                      ),
                    )
                ),
              ),
              body: Stack(
                children: [

                  Positioned(
                    child: snapshot.connectionState==ConnectionState.waiting||_currentPosition==null ? //check if loading is true or false
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          Text('Check internet connection or location')
                        ],
                      ),
                    ):
                    GoogleMap(
                        markers:Set<Marker>.of(_marker),
                        onTap: (position){

                       //   _customInfoWindowController.);
                        },
                        onCameraMove: (position){
                          _customInfoWindowController.onCameraMove!();
                        },
                        mapType: MapType.normal,

                        compassEnabled: true,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller){
                          _controller.complete(controller);
                          _customInfoWindowController.googleMapController=controller;


                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition!.latitude,_currentPosition!.longitude),
                            zoom: 14

                        ),
                    ),
                  ),
                  CustomInfoWindow(controller: _customInfoWindowController,height: 100,width: 100,),

Align(
  alignment: Alignment.bottomLeft,
  child:snapshot.connectionState==ConnectionState.waiting ?   Container(
      // height: 100,
      width: 200,
      margin: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    )
  :
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child:   Row(
      children: [
        for (var  i=0; i<storedocs.length;i++)...[

    Padding(

                  padding: const EdgeInsets.all(8.0),

                  child: InkWell(

                    onTap: (){

                      showModalBottomSheet(context: context,
                          isScrollControlled:true,

                          builder:(context,


                              )

                          {




                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  height: 600,

                                  child: Container(decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),),

                                  ),
                                      child:Column(
                                        children: [


                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.linear_scale),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: Table(
                                              columnWidths: {
                                                0: FlexColumnWidth(4),
                                                1: FlexColumnWidth(2),


                                              },

                                              children: [

                                                TableRow(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                  onTap:(){
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                  },
                                                                  child: Text('  View Detail',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                                              Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          children: [
                                                            InkWell(

                                                                onTap:() async {
                                                                  final mapDir =
                                                                      "https://www.google.com/maps/dir/?api=1&destination=${storedocs[i]['lati']},${storedocs[i]['long']}";
                                                                  if (await canLaunch(mapDir)) {
                                                                    launch(mapDir);
                                                                  }
                                                                },
                                                                child: Text('Direction',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black26),maxLines: 1,overflow:TextOverflow.ellipsis,)),
                                                            Icon(Icons.directions,color: Color.fromRGBO(246, 99, 9, 100)),
                                                          ],
                                                        ),
                                                      ),
   ]
                                                ),

                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                            child: SizedBox(
                                              height: 200,
                                              child: Container(
                                                color:   Colors.white,
                                                child: CarouselSlider(items: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          image: DecorationImage(

                                                              image: NetworkImage(storedocs[i]['image'] ),fit: BoxFit.fill
                                                          )
                                                      ),

                                                    ),
                                                  ), Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          image: DecorationImage(
                                                              image: NetworkImage(storedocs[i]['img1'] ),fit: BoxFit.fill
                                                          )
                                                      ),

                                                    ),
                                                  ), Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          image: DecorationImage(
                                                              image: NetworkImage(storedocs[i]['img2'] ),fit: BoxFit.fill
                                                          )
                                                      ),

                                                    ),
                                                  ),
                                                ], options: CarouselOptions(
                                                    enlargeCenterPage: true,
                                                    viewportFraction: 0.9,

                                                    autoPlay: true,
                                                    autoPlayInterval: const Duration(seconds: 5),
                                                    height: 450





                                                )),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              color:   Colors.white,
                                              child: Column(
                                                children: [

                                                  Padding(
                                                    padding: const  EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                    child:   storedocs[i]['title']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                    Text(storedocs[i]['title'],maxLines:1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromRGBO(246, 99, 9, 100)),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: DefaultTabController(
                                                length: 3, // length of tabs
                                                initialIndex: 0,
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                                                  Container(
                                                    child: TabBar(
                                                      indicatorColor: Color.fromRGBO(246, 99, 9, 100),
                                                      labelColor: Color.fromRGBO(246, 99, 9, 100),
                                                      unselectedLabelColor: Colors.black,
                                                      tabs: [
                                                        Tab(text: 'Overview'),
                                                        Tab(text: 'Photos'),
                                                        Tab(text: 'Amentities'),
                                                        // Tab(text: 'Tab 4'),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      height: 240, //height of TabBarView
                                                      decoration: BoxDecoration(
                                                          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                                                      ),
                                                      child: TabBarView(children: <Widget>[
                                                        SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Container(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                    child: Table(
                                                                      columnWidths: {
                                                                        0: FlexColumnWidth(1),
                                                                        1: FlexColumnWidth(3),

                                                                      },

                                                                      children: [

                                                                        TableRow(

                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [

                                                                                        Icon(Icons.location_pin,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [

                                                                                    storedocs[i]['Addrese']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                    Text(storedocs[i]['Addrese'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                                                                  ],
                                                                                ),
                                                                              ),




                                                                            ]
                                                                        ),
                                                                        TableRow(

                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [

                                                                                        Icon(Icons.handshake,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [

                                                                                    storedocs[i]['trust_name']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                    Column(
                                                                                      children: [
                                                                                        Text(storedocs[i]['trust_name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                                      ],
                                                                                    ),

                                                                                  ],
                                                                                ),
                                                                              ),




                                                                            ]
                                                                        ),
                                                                        TableRow(

                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [

                                                                                        Icon(Icons.call,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [

                                                                                    storedocs[i]['contact']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                    InkWell(
                                                                                        onTap:(){

                                                                                          FlutterPhoneDirectCaller.callNumber(storedocs[i]['contact']);
                                                                                        },
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text(storedocs[i]['contact'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                                          ],
                                                                                        )),

                                                                                  ],
                                                                                ),
                                                                              ),




                                                                            ]
                                                                        ),
                                                                        TableRow(

                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [

                                                                                        Icon(Icons.webhook_sharp,color: Color.fromRGBO(246, 99, 9, 100))
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  children: [

                                                                                    storedocs[i]['website']==''? Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                                                                                    InkWell  (
                                                                                        onTap:() async{


                                                                                          var uri = Uri.parse(storedocs[i]['website'].toString());
                                                                                          if (await canLaunchUrl(uri)){
                                                                                            await launchUrl(uri);
                                                                                          } else {
                                                                                            // can't launch url
                                                                                          }


                                                                                        },
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text(storedocs[i]['website'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.blue),),
                                                                                          ],
                                                                                        )),

                                                                                  ],
                                                                                ),
                                                                              ),




                                                                            ]
                                                                        ),


                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Container(
                                                            child: Center(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                                                    child: Table(
                                                                      columnWidths: {
                                                                        0: FlexColumnWidth(2),
                                                                        1: FlexColumnWidth(2),
                                                                        2: FlexColumnWidth(2),

                                                                      },

                                                                      children: [

                                                                        TableRow(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  color:   Colors.white,
                                                                                  child:
                                                                                  FadeInImage.assetNetwork(
                                                                                      placeholder: 'assets/tem.jpg',
                                                                                      image:  storedocs[i]['image'],width: 130,height: 70
                                                                                  ),


                                                                                  //  Image.network(storedocs[i]['image'],width: 130,height: 70)
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  color:   Colors.white,
                                                                                  child:
                                                                                  FadeInImage.assetNetwork(
                                                                                      placeholder: 'assets/tem.jpg',
                                                                                      image:  storedocs[i]['img1'],width: 130,height: 70
                                                                                  ),
                                                                                  // Image.network(storedocs[i]['img1'],width: 130,height: 70)
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  color:   Colors.white,
                                                                                  child:
                                                                                  FadeInImage.assetNetwork(
                                                                                      placeholder: 'assets/tem.jpg',
                                                                                      image: storedocs[i]['img2'],width: 130,height: 70
                                                                                  ),
                                                                                  // Image.network(storedocs[i]['img2'],width: 130,height: 70)
                                                                                ),
                                                                              ),




                                                                            ]
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              child: Center(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child: storedocs[i]['Ami1']==''?  null: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child:  Container(

                                                                          color:   Colors.white,

                                                                          child: InkWell(
                                                                            onTap: (){
                                                                              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                            },
                                                                            child:ListTile(
                                                                              title:
                                                                              Text(storedocs[i]['Ami1'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                              leading: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                      minWidth: 50,
                                                                                      minHeight: 80,
                                                                                      maxWidth: 55,
                                                                                      maxHeight: 85
                                                                                  ),
                                                                                  child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: storedocs[i]['Ami2']==''?  null: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child:  Container(

                                                                          color:   Colors.white,

                                                                          child: InkWell(
                                                                            onTap: (){
                                                                              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                            },
                                                                            child:ListTile(
                                                                              title:
                                                                              Text(storedocs[i]['Ami2'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                              leading: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                      minWidth: 50,
                                                                                      minHeight: 80,
                                                                                      maxWidth: 55,
                                                                                      maxHeight: 85
                                                                                  ),
                                                                                  child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: storedocs[i]['Ami3']==''?  null: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child:  Container(

                                                                          color:   Colors.white,

                                                                          child: InkWell(
                                                                            onTap: (){
                                                                              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                            },
                                                                            child:ListTile(
                                                                              title:
                                                                              Text(storedocs[i]['Ami3'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                              leading: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                      minWidth: 50,
                                                                                      minHeight: 80,
                                                                                      maxWidth: 55,
                                                                                      maxHeight: 85
                                                                                  ),
                                                                                  child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: storedocs[i]['Ami4']==''?  null: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child:  Container(

                                                                          color:   Colors.white,

                                                                          child: InkWell(
                                                                            onTap: (){
                                                                              //   Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));
                                                                            },
                                                                            child:ListTile(
                                                                              title:
                                                                              Text(storedocs[i]['Ami4'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                                              leading: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                      minWidth: 50,
                                                                                      minHeight: 80,
                                                                                      maxWidth: 55,
                                                                                      maxHeight: 85
                                                                                  ),
                                                                                  child:  Icon(Icons.arrow_forward_outlined,color: Color.fromRGBO(246, 99, 9, 100))),

                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),


                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        // SingleChildScrollView(
                                                        //   scrollDirection: Axis.vertical,
                                                        //   child: Container(
                                                        //     child: Center(
                                                        //       child: Column(
                                                        //         children: [
                                                        //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                        //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                        //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                        //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                        //           Text('Display Tab 1', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                        //         ],
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ])
                                                  )
                                                ])
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            );
                          }
                      );

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(storedocs[i])));

                    },

                    child: Container(

                      height: 120,

    width: 195,

          decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(10),

                                        color: Colors.white

                                    ),

                      child: Column(

                        children: [

                          Row(

                            children: [


          Padding(

                                padding: const EdgeInsets.all(8.0),

                                child: snapshot.connectionState==ConnectionState.waiting ?    Container(
                                    // height: 100,
                                    width: 200,
                                    margin: const EdgeInsets.only(left: 12, right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        Text('Check internet connection or location')
                                      ],
                                    ),
                                  ),
                                  )
                                :
            Image.network(storedocs[i]['image'],width: 115,height: 70,),

                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text((Geolocator.distanceBetween( _currentPosition!.latitude,_currentPosition!.longitude,double.parse(storedocs[i]['lati']),double.parse(storedocs[i]['long']))/1000).toString().substring(0, 4)
                                    +'km',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black26),))

                            ],

                          ),

                          Padding(

                            padding: const EdgeInsets.only(left: 4,right:4),

                            child: Column(

                              children: [

                                Text(storedocs[i]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines:1 ,overflow:TextOverflow.ellipsis,),

                              ],

                            ),

                          )

                        ],

                      ),

                    ),

                  ),

                )



              ]



      ],



    ),

  ),
)
//                   for (var i=0; i<storedocs.length;i++)...[
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
// children: [
//   Text(storedocs[i]['title'])
// ],
//
//                           // Positioned(
//                           //     left: 0,
//                           //     bottom: 2,
//                           //     child: Padding(
//                           //       padding: const EdgeInsets.all(13.0),
//                           //       child:   Container(
//                           //         height: 120,
//                           //         width: 168,
//                           //         decoration: BoxDecoration(
//                           //
//                           //             borderRadius: BorderRadius.circular(10),
//                           //
//                           //             color: Colors.white
//                           //
//                           //         ),
//                           //
//                           //         child: Column(
//                           //           children: [
//                           //             Row(
//                           //               children: [
//                           //                 Padding(
//                           //                   padding: const EdgeInsets.all(8.0),
//                           //                   child: Image.network(storedocs[i]['image'],width: 130,height: 70,),
//                           //                 ),
//                           //               ],
//                           //             ),
//                           //             Text(storedocs[i]['title']),
//                           //           ],
//                           //         ),
//                           //
//                           //       ),
//                           //     )),
//
//                       ),
//                     ),
//                   ],
                ],
              ),
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () async {
              //     _getCurrentPosition();
              //
              //   },
              //   child: Icon(Icons.location_disabled_outlined),
              // ),
              // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ),
          );
        }
    );


  }
}
