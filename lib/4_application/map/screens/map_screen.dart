import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:voltshare/4_application/map/bloc/map_bloc.dart';
import 'package:voltshare/4_application/map/bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key}) : _mapController = MapBloc().mapController;

  final MapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        debugPrint("Derzeitiger Map State: $state");
      },
      builder: (context, state) {
        return Stack(
          children: [
            OSMFlutter(
              controller: _mapController,
              osmOption: OSMOption(
                userTrackingOption: UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                zoomOption: ZoomOption(
                  initZoom: 19,
                  minZoomLevel: 8,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.blue,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: MarkerIcon(
                    icon: Icon(
                      Icons.circle,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  try {
                    // Hole die aktuelle Position des Benutzers
                    GeoPoint? userLocation = await _mapController.myLocation();

                    // Bewege die Karte zur Benutzerposition
                    await _mapController.moveTo(userLocation);
                    await _mapController.setZoom(zoomLevel: 19);

                    // Reaktiviere die Benutzerverfolgung nach der manuellen Bewegung
                    await _mapController.enableTracking();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Fehler: ${e.toString()}")),
                    );
                  }
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        );
      },
    ));
  }
}
