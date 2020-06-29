import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:testy/models/models.dart';
import 'package:testy/repositories/repositories.dart';

class SunPage extends StatefulWidget {
  final SunDataRepository sunRepo;
  final LocationRepository locationRepo;

  SunPage({
    Key key,
    this.sunRepo,
    this.locationRepo,
  }) : assert(
    sunRepo != null
    && locationRepo != null
  ),
    super(key: key);

  @override
  _SunPageState createState() => _SunPageState();
}

class _SunPageState extends State<SunPage> {

  Future<SunData> _sunData;

  Future<SunData> _getSunData() async {
    LocationData location = await widget.locationRepo.getLocation();
    SunData sunData = await widget.sunRepo.byLocation(
        location.latitude,
        location.longitude,
    );
    return sunData;
  }

  @override
  void initState() {
    super.initState();
    _sunData = _getSunData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sun')),
      body: FutureBuilder(
        future: _sunData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final SunData sunData = snapshot.data;
            return Column(
              children: <Widget>[
                Text('Sunset: ${sunData.sunset.toLocal()}',
                  key: Key('sunsetData'),
                ),
                Text('Sunset'),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error getting Sun data');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
