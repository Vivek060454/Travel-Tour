import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final storedocs;
  Details(this.storedocs, {Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int activeIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        children: [
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
                              image: NetworkImage(widget.storedocs['image'] ),fit: BoxFit.fill
                          )
                      ),

                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(widget.storedocs['img1'] ),fit: BoxFit.fill
                          )
                      ),

                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(widget.storedocs['img2'] ),fit: BoxFit.fill
                          )
                      ),

                    ),
                  ),
                ], options: CarouselOptions(
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,

                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    height: 240





                )),
              ),
            ),
          ),
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
                        padding: const  EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Container(
                            color:   Colors.white,
                            child:  FadeInImage.assetNetwork(
                              placeholder: 'assets/tem.jpg',
                              image:  widget.storedocs['image'],width: 130,height: 70,
                            ),
                           // Image.network(widget.storedocs['image'],width: 130,height: 70)
                        ),
                      ),
                      Padding(
                        padding: const  EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Container(
                            color:   Colors.white,
                            child:
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/tem.jpg',
                              image: widget.storedocs['img1'],width: 130,height: 70,
                            ),
                          //  Image.network(widget.storedocs['img1'],width: 130,height: 70)
                        ),
                      ),
                      Padding(
                        padding: const  EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Container(
                            color:   Colors.white,
                            child:
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/tem.jpg',
                              image:  widget.storedocs['img2'],width: 130,height: 70,
                            ),
                          //  Image.network(widget.storedocs['img2'],width: 130,height: 70)
                        ),
                      ),


                    ]
                ),

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color:   Colors.white,
              child: Row(
                children: [

                  Padding(
                    padding: const  EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: widget.storedocs['title']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):Text(widget.storedocs['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color.fromRGBO(246, 99, 9, 100)),),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const  EdgeInsets.fromLTRB(8, 2, 2, 4),
            child: Container(
              color:   Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [ widget.storedocs['spc']==''?  Text('-----',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)):
                    Text(widget.storedocs['spc'],style: TextStyle(fontSize: 16,),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
