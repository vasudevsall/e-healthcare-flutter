import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/room_service.dart';
import 'package:e_healthcare/widgets/custom_dropdown.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddRoom extends StatefulWidget {
  final data;
  AddRoom({
    @required this.data
  });
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {

  final List<DropdownMenuItem> roomType = [
    DropdownMenuItem(child: Center(child: Text('Ward')), value: 'W',),
    DropdownMenuItem(child: Center(child: Text('ICU')), value: 'I',),
    DropdownMenuItem(child: Center(child: Text('Operation Theatre')), value: 'O',)
  ];
  String room = 'W';
  int roomNumber;
  int floorNumber;
  int beds;
  double price;

  String displayMessage = '';
  bool displayError = false;

  bool _adding =false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _adding,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: kScreenPadding,
          children: [
            Text('Add New Room', style: kHeadTextStyle,),
            SizedBox(height: 20.0,),
            Text(
              displayMessage,
              style: GoogleFonts.notoSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: (displayError)?Colors.redAccent:Colors.green,
              ),
            ),
            Text('Room Number', style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
            SizedBox(height: 10.0,),
            CustomLabelTextField(
              validator: (val){},
              onChange: (newVal) {
                setState(() {
                  roomNumber = int.parse(newVal);
                });
              },
              hintText: 'Enter Room Number',
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              update: true,
              displayLabel: false,
            ),
            SizedBox(height: 20.0,),
            Text('Floor Number', style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
            SizedBox(height: 10.0,),
            CustomLabelTextField(
              validator: (val){},
              onChange: (newVal) {
                setState(() {
                  floorNumber = int.parse(newVal);
                });
              },
              hintText: 'Enter Floor Number',
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              update: true,
              displayLabel: false,
            ),
            SizedBox(height: 20.0,),
            Text('Beds', style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
            SizedBox(height: 10.0,),
            CustomLabelTextField(
              validator: (val){},
              onChange: (newVal) {
                setState(() {
                  beds = int.parse(newVal);
                });
              },
              hintText: 'Enter Number of Beds',
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
              update: true,
              displayLabel: false,
            ),
            SizedBox(height: 20.0,),
            Text('Room Type', style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
            SizedBox(height: 10.0,),
            CustomDropdownButton(
              displayLabel: false,
              radius: 5.0,
              items: roomType,
              onChange: (newVal) {
                setState(() {
                  room = newVal;
                });
              },
              value: room,
            ),
            SizedBox(height: 20.0,),
            Text('Price', style: kHeadTextStyle.copyWith(color: kDarkBackColor),),
            SizedBox(height: 10.0,),
            CustomLabelTextField(
              validator: (val){},
              onChange: (newVal) {
                setState(() {
                  price = double.parse(newVal);
                });
              },
              hintText: 'Enter Price per Bed',
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              update: true,
              displayLabel: false,
            ),
            SizedBox(height: 30.0,),
            ElevatedButton(
              onPressed: () async {
                print(roomNumber);
                print(floorNumber);
                print(beds);
                print(room);
                print(price);
                if(roomNumber == null) {
                  setState(() {
                    displayMessage = 'Room Number cannot be empty';
                    displayError = true;
                  });
                } else if(floorNumber == null) {
                  setState(() {
                    displayMessage = 'Floor Number cannot be empty';
                    displayError = true;
                  });
                } else if(beds == null) {
                  setState(() {
                    displayMessage = 'Beds cannot be empty';
                    displayError = true;
                  });
                } else if(price == null) {
                  setState(() {
                    displayMessage = 'Price cannot be empty';
                    displayError = true;
                  });
                } else {
                  setState(() {
                    _adding = true;
                  });
                  try {
                    RoomService roomService = RoomService();
                    await roomService.addRoom(
                        roomNumber, floorNumber, beds, room, price);

                    setState(() {
                      displayMessage = "Room Added";
                      displayError = false;
                      _adding =false;
                    });
                  } catch (e) {
                    setState(() {
                      _adding = false;
                      displayError = true;
                      displayMessage = e.response.data['message'];
                    });
                    print("Add Room = " + e.response.data);
                  }
                }
              },
              child: Text(
                'Add Room'
              ),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
