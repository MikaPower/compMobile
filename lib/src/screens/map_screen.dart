import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapInsideOperationScreen extends StatefulWidget {
 final LatLng point;

  @override
  const MapInsideOperationScreen({Key key, this.point}) : super(key: key);

  @override
  MapInsideOperationScreenState createState() =>
     MapInsideOperationScreenState();
}

class MapInsideOperationScreenState extends State<MapInsideOperationScreen> {
  MapController mapController;
  List<LatLng> points = [
    LatLng(51.5, -0.08),
    LatLng(51.5, -0.06),
    LatLng(51.5, -0.05),
    LatLng(51.5, -0.04)
  ];

  @override
  void initState() {
    super.initState();
    mapController = new MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Stack(
              children: <Widget>[
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    onPositionChanged: (position, bool) {},
                    center: widget.point,
                    zoom: 1.0,
                    maxZoom: 16.0,
                    minZoom: 6.0,
                    onTap: (point) {
                      setState(() {});
                    },
                  ),
                  layers: [
                    new TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    new MarkerLayerOptions(
                      markers: [
                        new Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.point,
                          builder: (ctx) => new Container(
                            child: new FlutterLogo(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  calculateCenterPoint(List<LatLng> points) {
    double soma_lat = 0;
    double soma_lng = 0;
    double centroide_lat = 0;
    double centroide_lng = 0;
    for (int x = 0; x < points.length; x++) {
      soma_lat += points[x].latitude;
      soma_lng += points[x].longitude;
    }
    centroide_lat = soma_lat / points.length;
    centroide_lng = soma_lng / points.length;

    print(centroide_lat);
    print(centroide_lng);
    return new LatLng(centroide_lat, centroide_lng);
  }
}
