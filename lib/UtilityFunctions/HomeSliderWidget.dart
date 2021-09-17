import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delivoo/JsonFiles/Banner/Banner.dart' as Banners;
import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/cupertino.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'HomeSliderLoaderWidget.dart';

class HomeSliderWidget extends StatefulWidget {
  final List<Banners.Data> slides;

  @override
  _HomeSliderWidgetState createState() => _HomeSliderWidgetState();

  HomeSliderWidget({Key key, this.slides}) : super(key: key);
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return widget.slides == null || widget.slides.isEmpty
        ? HomeSliderLoaderWidget()
        : Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  height: 165,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      print("currentInd >> $_current");
                    });
                  },
                ),
                items: widget.slides.map((Banners.Data slide) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          if(slide.meta.type=="company_url"||slide.meta.type=="normal_url"){
                            slide.meta.callBack.launchUrl();
                          }else if(slide.meta.type=="item"){
                            print("goestroid");
                          }
                       /*   if (-(slide.meta.callBack)) {
                            slide.meta.callBack.launchUrl();
                          } else {
                            print("its a not url");
                          }*/
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 20, top: 10),
                          height: 160,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(1, 2)),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: slide.mediaurls.images[0].def,

                                  placeholder: (context, url) => Image.asset(
                                    'images/loading.gif',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 160,
                                  ),
                                  errorWidget: (context, url, error) =>Container(decoration: BoxDecoration(color: Color(0xfff2f2f2), borderRadius: BorderRadius.circular(6)),child: Image.asset("images/img_not.jpeg",fit: BoxFit.fitHeight, height: 120,)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                margin: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.slides.map((Banners.Data slide) {
                    print(
                        "here Catch > ${widget.slides.indexOf(slide)} >> $_current");
                    return Container(
                      width: 7,
                      height: 7,
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: _current + 1 == slide.sortOrder
                              ? kMainColor
                              : kMainColor.withOpacity(0.3)),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
  }
}

extension checkUrl on String{
  bool operator -(){
    return Uri.tryParse(this)?.isAbsolute ?? false;
  }
  void launchUrl(){
    launch(this);
  }
}
enum type {
  item,
  company_url,
  normal_url,
  none,
}
