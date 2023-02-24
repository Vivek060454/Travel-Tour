import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maptest extends StatefulWidget {

  final lati;
  final long;
  Maptest(this.lati,this.long, {Key? key}) : super(key: key);
  @override
  State<Maptest> createState() => _MaptestState();
}

class _MaptestState extends State<Maptest> {

  Completer<GoogleMapController> _controller = Completer();


  static final CameraPosition _kgoogleplex=const CameraPosition(
      target: LatLng(19.1955645,72.9630627),
      zoom: 14

  );
  CustomInfoWindowController _customInfoWindowController=CustomInfoWindowController();



  @override
  Widget build(BuildContext context) {
    List<Marker> _marker=[
      Marker(
          markerId: MarkerId('1'),
          position:  LatLng(double.parse(widget.lati),double.parse(widget.long)),
          infoWindow: InfoWindow(
              title: 'hji'
          ),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));

          }


      ),

    ] ;


    return Scaffold(
      body:    GoogleMap(
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
            target: LatLng(double.parse(widget.lati),double.parse(widget.long)),
            zoom: 14

        ),
      ),
    );
  }
}
