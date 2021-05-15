import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/room_service.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RoomStatus extends StatefulWidget {
  final data;
  final bool allowBooking;
  RoomStatus({
    @required this.data,
    this.allowBooking = true
  });
  @override
  _RoomStatusState createState() => _RoomStatusState();
}

class _RoomStatusState extends State<RoomStatus> {

  var roomData;
  bool roomDataAvailable = false;
  String roomType = 'W';
  List<DropdownMenuItem> roomTypeList = [
    DropdownMenuItem(child: Center(child: Text('Ward'),), value: 'W',),
    DropdownMenuItem(child: Center(child: Text('ICU'),), value: 'I',),
    DropdownMenuItem(child: Center(child: Text('OT'),), value: 'O',),
  ];
  bool _searching = false;

  void _getRoomData() async {
    setState(() {
      _searching = true;
    });
    try {
      RoomService roomService = RoomService();
      var resp = await roomService.getRoomDetails(roomType);

      setState(() {
        roomData = resp.data;
        roomDataAvailable = true;
        _searching = false;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getRoomData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _searching,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: _generateBody()
      ),
    );
  }

  Widget _generateBody() {
    if(!roomDataAvailable) {
      return SizedBox();
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
      children: _getRoomList(),
    );
  }

  List<Widget> _getRoomList() {
    List<Widget> widgetList = [];

    // Add top heading
    widgetList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Room',
            style: kHeadTextStyle,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: kPrimaryColor, width: 1.0)
            ),
            child: DropdownButton(
              isDense: true,
              underline: SizedBox(),
              items: roomTypeList,
              style: GoogleFonts.notoSans(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: kDarkBackColor
              ),
              value: roomType,
              onChanged: (value) {
                setState(() {
                  roomType = value;
                });
                _getRoomData();
              },
            ),
          ),
        ],
      ),
    );

    for(var i in roomData) {
      widgetList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          padding: EdgeInsets.all(10.0),
          decoration: kDashBoxDecoration,
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: kDashBoxDecoration.copyWith(
              color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Room Number : ${i['id']}', textAlign: TextAlign.center, style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
                Divider(color: kPrimaryOther,),
                SimpleRowData(title: 'Floor Number', value: i['floor'].toString()),
                SimpleRowData(title: 'Total Beds', value: i['total'].toString()),
                SimpleRowData(title: 'Beds Available', value: i['beds'].toString()),
                SimpleRowData(title: 'Prime', value: '${'\u20B9'} ${i['price']}/-'),
                SizedBox(height: 5.0,),
                (widget.allowBooking)?ElevatedButton(
                  onPressed: (i['beds'] == 0)?null:() {
                    Navigator.pop(context, i['id']);
                  },
                  child: Text('Select'),
                  style: ElevatedButton.styleFrom(primary: kPrimaryOther),
                ):SizedBox()
                ,
              ],
            ),
          ),
        )
      );
    }

    return widgetList;
  }
}
