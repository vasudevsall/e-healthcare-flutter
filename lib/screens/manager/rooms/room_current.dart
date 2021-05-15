import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/constants/days_constant.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/manager/rooms/admit_information.dart';
import 'package:e_healthcare/screens/manager/users/search_user.dart';
import 'package:e_healthcare/screens/patient/account/account_information.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/room_service.dart';
import 'package:e_healthcare/widgets/dash_card.dart';
import 'package:e_healthcare/widgets/select_input.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RoomCurrentStatus extends StatefulWidget {
  final data;
  RoomCurrentStatus({
    @required this.data,
  });
  @override
  _RoomCurrentStatusState createState() => _RoomCurrentStatusState();
}

class _RoomCurrentStatusState extends State<RoomCurrentStatus> {

  var data;
  bool dataAvailable = false;
  String doctor;
  String username;
  int startDays = 30;
  int endDays;
  bool _searching = false;
  List<String> dischargeList = ['Discharged', 'Admitted'];

  void _getData() async {
    setState(() {
      _searching = true;
    });
    try {
      RoomService roomService = RoomService();
      var resp = await roomService.getBookingDetails(username, doctor, startDays, endDays);

      setState(() {
        data = resp.data;
        dataAvailable = true;
        _searching = false;
      });
    } catch(e) {
      setState(() {
        _searching = false;
      });
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _searching,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: _generateBody(),
      ),
    );
  }

  Widget _generateBody() {
    if(!dataAvailable) {
      return SizedBox();
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      children: _getListData(),
    );
  }

  List<Widget> _getListData() {
    List<Widget> returnList = [];

    returnList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Patients Admitted', style: kHeadTextStyle,),
          Material(
            color: Colors.white,
            child: Center(
              child: Ink(
                decoration: const ShapeDecoration(
                  color: kBackColor,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.filter),
                  color: kPrimaryColor,
                  onPressed: () async {
                    bool value = await _openBottomDrawer();

                    if(!value) {
                      setState(() {
                        startDays = 30;
                        username = null;
                        endDays = null;
                      });
                    }
                    _getData();
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
    returnList.add(
      SizedBox(height: 15.0,)
    );

    if(data.length == 0) {
      returnList.add(
        Center(
          child: Text(
            'Search Patients',
            style: kHeadTextStyle.copyWith(color: kDarkBackColor),
          ),
        )
      );
    }else {
      for(var i in data) {
        returnList.add(
          DashCard(
            margin: true,
            head: Text(
              'Room Number: ${i['room']['id']}', style: kHeadTextStyle, textAlign: TextAlign.center,
            ),
            children: [
              SimpleRowData(
                title: 'Patient',
                value: '${i['user']['firstName']} ${i['user']['lastName']}',
                valueOnPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AccountInformation(
                      data: widget.data,
                      userData: i['user'],
                      displayEdit: false,
                    );
                  }));
                },
              ),
              SimpleRowData(title: 'Patient Phone', value: '+91-${i['user']['phoneNumber']}'),
              SimpleRowData(title: 'Doctor', value: 'Dr. ${i['doctor']['userId']['firstName']} ${i['doctor']['userId']['lastName']}'),
              SimpleRowData(title: 'Admitted On', value: i['admit']),
              SimpleRowData(title: 'Discharged On', value: (i['discharge'] == null)?'Admitted':i['discharge']),
              SimpleRowData(title: 'Bill', value: '${'\u20B9'} ${i['cost']}/-'),
            ],
            actions: [
              ElevatedButton.icon(
                onPressed: (i['discharge'] == null)?() async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdmitInformation(data: widget.data, admitData: i, discharge: true,);
                  }));
                  _getData();
                }:null,
                icon: Icon(FontAwesomeIcons.signOutAlt),
                label: Text('Discharge'),
                style: ElevatedButton.styleFrom(primary: kPrimaryColor),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdmitInformation(data: widget.data, admitData: i,);
                  }));
                  _getData();
                },
                icon: Icon(FontAwesomeIcons.infoCircle),
                label: Text('More Details'),
                style: ElevatedButton.styleFrom(primary: kDarkBackColor),
              )
            ],
          )
        );
      }
    }

    return returnList;
  }

  Future<bool> _openBottomDrawer() {
    return showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                    color: Color(0xff757575),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: ListView(
                        padding: EdgeInsets.all(20.0),
                        children: [
                          Text('Filters', style: kHeadTextStyle,),
                          Divider(color: kPrimaryColor,),
                          SizedBox(height: 15.0,),
                          Text('Select User', style: kLabelTextStyle,),
                          SelectInput(
                            text: (username==null)?'':username,
                            onPressed: () async {
                              String user = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return SearchUser(data: widget.data);
                              }));
                              print(user);
                              setState(() {
                                username = (user==null)?'':user;
                              });
                            },
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Number of Days', style: kLabelTextStyle,),
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
                                  items: daysList,
                                  style: GoogleFonts.notoSans(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: kDarkBackColor
                                  ),
                                  value: startDays,
                                  onChanged: (value) {
                                    setState(() {
                                      startDays = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          GroupButton(
                            buttons: dischargeList,
                            onSelected: (index, isSelected){
                              if(index == 0) {
                                endDays = 0;
                              } else {
                                endDays = null;
                              }
                            },
                            isRadio: true,
                            spacing: 10.0,
                            borderRadius: BorderRadius.circular(5.0),
                            unselectedColor: Colors.transparent,
                            unselectedBorderColor: kPrimaryColor,
                            unselectedTextStyle: GoogleFonts.notoSans(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor
                            ),
                            selectedColor: kPrimaryColor,
                            selectedBorderColor: Colors.white,
                            selectedTextStyle: GoogleFonts.notoSans(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Apply Filters',
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: kPrimaryColor
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              'Clear Filters',
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: kDarkBackColor
                            ),
                          ),
                        ],
                      ),
                    )
                );
              }
          );
        }
    );
  }
}
