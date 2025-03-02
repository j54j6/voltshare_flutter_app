import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'map_events.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapController mapController = MapController.withUserPosition(
    trackUserLocation: UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  MapBloc() : super(MapInitial()) {
    //on<MapLoadWallboxesRequested>(_onLoadWallboxes);
  }
}
  /*
  Future<void> _onLoadWallboxes(
    MapLoadWallboxesRequested event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    try {
      // Hole den sichtbaren Bereich
      BoundingBox bounds = await mapController.bounds;

      // Wallbox-Daten laden (API-Aufruf oder Mock-Daten)
      List<GeoPoint> wallboxes = await _fetchWallboxes(bounds);

      // Prüfe auf Clustering (vereinfacht)
      bool isClusteringNeeded = wallboxes.length > 50;

      if (isClusteringNeeded) {
        emit(MapLoadedWithClustering(clusters: _generateClusters(wallboxes)));
      } else {
        emit(MapLoaded(wallboxes: wallboxes));
      }
    } catch (e) {
      emit(MapError("Fehler beim Laden der Wallboxen: $e"));
    }
  }

  Future<List<GeoPoint>> _fetchWallboxes(BoundingBox bounds) async {
    // Mock-Daten, ersetze durch API-Aufruf
    return [
      GeoPoint(latitude: bounds.top - 0.001, longitude: bounds.left + 0.001),
      GeoPoint(
        latitude: bounds.bottom + 0.001,
        longitude: bounds.right - 0.001,
      ),
      GeoPoint(
        latitude: bounds.center.latitude,
        longitude: bounds.center.longitude,
      ),
    ];
  }

  Map<GeoPoint, int> _generateClusters(List<GeoPoint> wallboxes) {
    // Einfaches Clustering (Radius = 0.005)
    Map<GeoPoint, int> clusters = {};

    for (var wallbox in wallboxes) {
      GeoPoint? clusterCenter;
      for (var cluster in clusters.keys) {
        double distance = _calculateDistance(cluster, wallbox);
        if (distance < 0.005) {
          clusterCenter = cluster;
          break;
        }
      }

      if (clusterCenter != null) {
        clusters[clusterCenter] = clusters[clusterCenter]! + 1;
      } else {
        clusters[wallbox] = 1;
      }
    }
    return clusters;
  }

  double _calculateDistance(GeoPoint a, GeoPoint b) {
    return ((a.latitude - b.latitude).abs() +
        (a.longitude - b.longitude).abs());
  }
}
*/