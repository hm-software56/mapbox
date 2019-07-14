import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mapbox/menu/menu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'setting/setapi.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SetAip setapi = SetAip();
  Menu menu=Menu();

  /*========= Open with redirect to google maps ===========*/
  void openGoogleMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  /*================= Get current location  ===============*/
  Location location = Location();
  var latitude = 17.974855;
  var longitude = 102.609986;
  var currentLocation;
  void getCurrentLocation() {
    location.onLocationChanged().listen((value) {
      currentLocation = value;
      setState(() {
        latitude = currentLocation['latitude'];
        longitude = currentLocation['longitude'];
      });
    });
  }

  /*======== Marker show posistion ==========*/
  Marker marker(latitude, longitude) {
    return Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(latitude, longitude),
        builder: (context) => Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: Colors.red,
                iconSize: 45.0,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (Builder) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      'Title',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => {
                                            launch("tel://21213123123"),
                                          },
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.call,
                                                color: Colors.red,
                                              ),
                                              Text("CALL")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => {
                                            launch("http://gooogle.com"),
                                          },
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.important_devices,
                                                color: Colors.red,
                                              ),
                                              Text("WEBSITE")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: FlatButton(
                                          onPressed: () => {
                                            openGoogleMap(latitude, longitude)
                                          },
                                          color: Colors.white,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            // Replace with a Row for horizontal icon + text
                                            children: <Widget>[
                                              Icon(
                                                Icons.directions,
                                                color: Colors.red,
                                              ),
                                              Text("GO")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
        ),
        drawer:menu.drawer,
        body: FlutterMap(
            options:
                MapOptions(center: LatLng(latitude, longitude), minZoom: 1.0),
            layers: [
              TileLayerOptions(urlTemplate: setapi.apiMap, additionalOptions: {
                'accessToken': setapi.apiMap_key,
                'id': setapi.mapVersion,
              }),
              MarkerLayerOptions(markers: [
                marker(latitude, longitude),
              ]),
            ]));
  }
}
