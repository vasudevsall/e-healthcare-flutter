import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import './call.dart';

class VideoCall extends StatefulWidget {
  final bool disabled;
  final String channel;
  VideoCall({
    this.disabled = false,
    @required this.channel
  });
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<VideoCall> {

  ClientRole _role = ClientRole.Broadcaster;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.disabled)?null:onJoin,
      child: Text('Join Video Call'),
      style: ElevatedButton.styleFrom(
        primary: kDarkBackColor,
        textStyle: GoogleFonts.notoSans(
          fontSize: 14.0,
          fontWeight: FontWeight.w700
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: widget.channel,
          role: _role,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}