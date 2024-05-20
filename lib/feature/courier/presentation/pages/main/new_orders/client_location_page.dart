/*
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../data/models/app_lat_long.dart';
import '../../../../data/service/app_location_service.dart';

class ClientLocationPage extends StatefulWidget {
  const ClientLocationPage({super.key});

  @override
  State<ClientLocationPage> createState() => _ClientLocationPageState();
}

class _ClientLocationPageState extends State<ClientLocationPage> {
  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  void initState() {
    _initPermission().ignore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Текущее местоположение'),
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Icon(
              Icons.location_on,
              size: 30,
              color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchCurrentLocation();
        },
        child: const Icon(
          Icons.navigation_outlined,
          size: 40,
          color: Colors.blue,
        ),
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }
}
*/



import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../widgets/control_button.dart';
import '../../../widgets/map_page.dart';


class DrivingPage extends MapPage {
  const DrivingPage({Key? key}) : super('Driving example', key: key);

  @override
  Widget build(BuildContext context) {
    return _DrivingExample();
  }
}

class _DrivingExample extends StatefulWidget {
  @override
  _DrivingExampleState createState() => _DrivingExampleState();
}

class _DrivingExampleState extends State<_DrivingExample> {
  late final List<MapObject> mapObjects = [
    startPlacemark,
    stopByPlacemark,
    endPlacemark
  ];
  final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('start_placemark'),
    point: const Point(latitude: 55.7558, longitude: 37.6173),
    icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('lib/assets/route_start.png'),
            scale: 0.3
        )
    ),
  );
  final PlacemarkMapObject stopByPlacemark = PlacemarkMapObject(
    mapId: const MapObjectId('stop_by_placemark'),
    point: const Point(latitude: 45.0360, longitude: 38.9746),
    icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('lib/assets/route_stop_by.png'),
            scale: 0.3
        )
    ),
  );
  final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('end_placemark'),
      point: const Point(latitude: 48.4814, longitude: 135.0721),
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('lib/assets/route_end.png'),
              scale: 0.3
          )
      )
  );

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: YandexMap(
                  mapObjects: mapObjects
              )
          ),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      children: [
                        ControlButton(
                          onPressed: _requestRoutes,
                          title: 'Build route',
                        ),
                      ]
                  )
              )
          )
        ]
    );
  }

  Future<void> _requestRoutes() async {
    print('Points: ${startPlacemark.point},${stopByPlacemark.point},${endPlacemark.point}');

    var resultWithSession = await YandexDriving.requestRoutes(
        points: [
          RequestPoint(point: startPlacemark.point, requestPointType: RequestPointType.wayPoint),
          RequestPoint(point: stopByPlacemark.point, requestPointType: RequestPointType.viaPoint),
          RequestPoint(point: endPlacemark.point, requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0,
            routesCount: 5,
            avoidTolls: true
        )
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => _SessionPage(
                startPlacemark,
                endPlacemark,
                resultWithSession.$1,
                resultWithSession.$2
            )
        )
    );
  }
}


class _SessionPage extends StatefulWidget {
  final Future<DrivingSessionResult> result;
  final DrivingSession session;
  final PlacemarkMapObject startPlacemark;
  final PlacemarkMapObject endPlacemark;

  const _SessionPage(this.startPlacemark, this.endPlacemark, this.session, this.result);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<_SessionPage> {
  late final List<MapObject> mapObjects = [
    widget.startPlacemark,
    widget.endPlacemark
  ];

  final List<DrivingSessionResult> results = [];
  bool _progress = true;

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    super.dispose();

    _close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Driving ${widget.session.id}')),
        body: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        YandexMap(
                            mapObjects: mapObjects
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              children: <Widget>[
                                SizedBox(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        !_progress ? Container() : TextButton.icon(
                                            icon: const CircularProgressIndicator(),
                                            label: const Text('Cancel'),
                                            onPressed: _cancel
                                        )
                                      ],
                                    )
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: _getList(),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                          )
                      )
                  )
                ]
            )
        )
    );
  }

  List<Widget> _getList() {
    final list = <Widget>[];

    if (results.isEmpty) {
      list.add((const Text('Nothing found')));
    }

    for (var r in results) {
      list.add(Container(height: 20));

      r.routes!.asMap().forEach((i, route) {
        list.add(Text('Route $i: ${route.metadata.weight.timeWithTraffic.text}'));
      });

      list.add(Container(height: 20));
    }

    return list;
  }

  Future<void> _cancel() async {
    await widget.session.cancel();

    setState(() { _progress = false; });
  }

  Future<void> _close() async {
    await widget.session.close();
  }

  Future<void> _init() async {
    await _handleResult(await widget.result);
  }

  Future<void> _handleResult(DrivingSessionResult result) async {
    setState(() { _progress = false; });

    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() { results.add(result); });
    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(PolylineMapObject(
          mapId: MapObjectId('route_${i}_polyline'),
          polyline: route.geometry,
          strokeColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          strokeWidth: 3,
        ));
      });
    });
  }
}
