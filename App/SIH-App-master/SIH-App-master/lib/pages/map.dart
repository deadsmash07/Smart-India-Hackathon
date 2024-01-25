import 'dart:async';
import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sih_app/database/maps_api.dart';
import 'package:sih_app/map_provider.dart';
import 'package:sih_app/utils/socket_methods.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';
  MapController mapController = MapController();
  List listofpoints = [];
  List<LatLng> points = [];
  bool loading = true;
  List<dynamic> instructions = [];
  double time = 0;
  late Timer timer;
  double distance = 0;
  SocketMethods socketMethods = SocketMethods();
  int idx = 0;
  List<int> list_idx = [0];
  int pre_index = 0;
  double distance_travelled = 0;
  double time_taken = 0;

  Future<bool> getCoordniates() async {
    var res = await http.get(getRouteUrl("77.1728,28.5257", "77.1828,28.5257"));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      var seg = data['features'][0]['properties']['segments'][0];
      print(res.body);
      setState(() {
        time = seg['duration'];
        distance = seg['distance'];
        instructions = seg['steps'];
        listofpoints = data['features'][0]['geometry']['coordinates'];
        points = listofpoints.map((e) => LatLng(e[1], e[0])).toList();
        loading = false;

        for (var i = 0; i < instructions.length - 1; i++) {
          var a = instructions[i]['way_points'][1];
          list_idx.add(a);
        }
        print(res.body);
      });
    }
    return true;
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  int findinsertIndex(int target) {
    int low = 0;
    int high = list_idx.length;
    while (low < high) {
      int mid = (low + high) ~/ 2;
      if (list_idx[mid] < target) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low;
  }

  final flutterTts = FlutterTts();
  Future<void> systemSpeak(String content) async {
    double volume = Provider.of<MapProvider>(context,listen: false).volume;
    await flutterTts.setVolume(volume);
    await flutterTts.speak(content);
  }

  @override
  void initState() {
    getCoordniates().then((value) => {
          timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
            
            idx++;
            if (idx > points.length - 1) {
              timer.cancel();
              return;
            }
            print(idx);
            Provider.of<MapProvider>(context, listen: false)
                .changeIndex(idx, points.length - 1);
            var i = findinsertIndex(idx);

            if (pre_index != i && i <= instructions.length - 1) {
              distance -= instructions[pre_index]['distance'];
              time -= instructions[pre_index]['duration'];
              pre_index = i;
              Provider.of<MapProvider>(context, listen: false).setInstruction(
                  instructions[pre_index]["instruction"], time, distance);
              systemSpeak(instructions[pre_index]["instruction"]);
            }
            if(idx== points.length - 1){
              socketMethods.sendData(
                points[idx].longitude, points[idx].latitude, "njbjbjka",true,distance,time);
            }else{

            socketMethods.sendData(
                points[idx].longitude, points[idx].latitude, "njbjbjka",false,distance,time);
            }
            setState(() {});
            Provider.of<MapProvider>(context, listen: false).setLoading();
          })
        });
    super.initState();
  }

  // points==[]?LatLng(0, 0):points[(points.length/2).round()],
  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: 400,
            width: MediaQuery.of(context).size.width - 40,
            child: const Center(child: CircularProgressIndicator()))
        : Container(
            height: 400,
            width: MediaQuery.of(context).size.width - 40,
            child: FlutterMap(
              options: MapOptions(
                  initialCenter: loading
                      ? LatLng(0, 0)
                      : points[(points.length / 2).round()],
                  initialZoom: 15.0,
                  interactiveFlags: ~InteractiveFlag.rotate,
                  keepAlive: true // Initial zoom level
                  ),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.insien',
                  tileUpdateTransformer: _animatedMoveTileUpdateTransformer,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: const LatLng(28.5457,
                          77.1928), // Example landmark coordinates (San Francisco)
                      child: Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.yellow,
                          size: 45.0,
                        ),
                      ),
                    ),
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: const LatLng(28.5357,
                          77.1928), // Example landmark coordinates (San Francisco)
                      child: Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.yellow,
                          size: 45.0,
                        ),
                      ),
                    ),
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: const LatLng(28.5257,
                          77.1828), // Example landmark coordinates (San Francisco)
                      child: Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.yellow,
                          size: 45.0,
                        ),
                      ),
                    ),
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: const LatLng(28.5257,
                          77.1728), // Example landmark coordinates (San Francisco)
                      child: Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 45.0,
                        ),
                      ),
                    ),
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: loading
                          ? const LatLng(0, 0)
                          : points[
                              idx], // Example landmark coordinates (San Francisco)
                      child: Container(
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 45.0,
                        ),
                      ),
                    ),
                    // Add more markers for other landmarks here...
                  ],
                ),
                PolylineLayer(polylines: [
                  Polyline(points: points, color: Colors.blue, strokeWidth: 5)
                ])
              ],
            ),
          );
  }
}

final _animatedMoveTileUpdateTransformer =
    TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(_MapScreenState._startedId) == true) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    // When animated movement starts load tiles at the target location and do
    // not prune. Disabling pruning means existing tiles will remain visible
    // whilst animating.
    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == _MapScreenState._inProgressId) {
    // Do not prune or load whilst animating so that any existing tiles remain
    // visible. A smarter implementation may start pruning once we are close to
    // the target zoom/location.
  } else if (id == _MapScreenState._finishedId) {
    // We already prefetched the tiles when animation started so just prune.
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
