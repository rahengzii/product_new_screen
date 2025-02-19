import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapsreen extends StatefulWidget {
  const mapsreen({super.key});

  @override
  State<mapsreen> createState() => _mapsreenState();
}

class _mapsreenState extends State<mapsreen> {
  var address = 'Loading ...';
  Timer? _timer;
  int _start = 2;
  var cameraPosition = const CameraPosition(
    target: LatLng(11.570608417784399, 104.89798574222964),
    zoom: 20,
  );

  void getLocationAddress(LatLng location) {
    placemarkFromCoordinates(location.latitude, location.longitude)
        .then((value) {
      var temAddress = '';
      var mark = value.first;

      temAddress += '${mark.thoroughfare ?? ''}, ';

      temAddress += '${mark.subLocality ?? ''}, ';
      temAddress += mark.locality ?? '';
      setState(() {
        address = temAddress;
      });
    });
  }

  void delayTwoSecondToGetAddress(LatLng location) {
    _timer?.cancel();
    _start = 2;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          getLocationAddress(location);
        } else {
          _start--;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: cameraPosition,
                onCameraMove: (position) {
                  setState(() {
                    address = 'Loading ...';
                  });
                  delayTwoSecondToGetAddress(position.target);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ColoredBox(
                color: Colors.grey,
                child: Container(
                  padding: const EdgeInsets.only(top: 16, left: 10),
                  child: SafeArea(
                    top: false,
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            located(),
            button(),
          ],
        ),
      ),
    );
  }

  Widget located() {
    return Center(
      child: SvgPicture.asset(
        'assets/svg/location.svg',
        width: 50,
        height: 50,
      ),
    );
  }

  Widget button() {
    return Positioned(
      top: 600,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, address);
        },
        child: const Text(
          'Select location',
        ),
      ),
    );
  }
}




// body: Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     GoogleMap(
      //       mapType: MapType.normal,
      //       initialCameraPosition: kGooglePlex,
      //       onMapCreated: (GoogleMapController controller) {},
      //     ),
      //     located(),
      //   ],
      // ),
