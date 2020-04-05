import 'package:ssc_401/shared/mylib.dart';


List<BinLocation> binLocationList = [BinLocation(1.2985607385635376,103.77487182617188,'NUS: Block EA Level 2'),
  BinLocation(1.4064586162567139, 103.90187072753906,'Waterway Point : East Wing Level 1')];

class BinLocation{
  double latitude;
  double longitude;
  String locationInfo;
  BinLocation(this.latitude,this.longitude,this.locationInfo);
}

class LocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationPageState();
  }
}

class _LocationPageState extends State<LocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  static final CameraPosition _singapore = CameraPosition(
    target: LatLng(1.340863, 103.8303918),
    zoom: 12
  );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Locate Nearest BinPoint'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  }))),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _singapore,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToNearestBin(),
        label: Text('Find BinPoint!'),
        icon: Icon(Icons.search),
      ),
    );
  }

  Future<void> _goToNearestBin() async {
    var geoLocator = Geolocator();
    await geoLocator.isLocationServiceEnabled().then((status)async {
      if (status == true) {
        // Permission granted and location enabled
        final GoogleMapController controller = await _controller.future;
        final Position myPosition = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        double distanceInMeters;
        double shortestDistance = 999999999999;
        BinLocation nearestBin = BinLocation(0, 0, '');

        for (var bin in binLocationList) {
          distanceInMeters = await Geolocator().distanceBetween(
              myPosition.latitude, myPosition.longitude, bin.latitude,
              bin.longitude);
          if (distanceInMeters < shortestDistance) {
            nearestBin.latitude = bin.latitude;
            nearestBin.longitude =  bin.longitude;
            nearestBin.locationInfo = bin.locationInfo;
            shortestDistance = distanceInMeters;
          }
        }

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('Nearest Bin'),
              position: LatLng(nearestBin.latitude, nearestBin.longitude),
              infoWindow: InfoWindow(
                  title: nearestBin.locationInfo),
            ),
          );
          controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(nearestBin.latitude, nearestBin.longitude),
                  zoom: 15)));
        });
        controller.showMarkerInfoWindow(MarkerId('Nearest Bin'));
      }
      else {
        setState(() {
          Fluttertoast.showToast(
            msg: "Please enable location ",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        });
      }
    });
  }
}
