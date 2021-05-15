import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/manage_user_service.dart';
import 'package:e_healthcare/widgets/profile.dart';
import 'package:e_healthcare/widgets/welcome_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchUser extends StatefulWidget {
  final data;
  final bool selectPatient;
  SearchUser({
    @required this.data,
    this.selectPatient = true
  });
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {

  List patients = [];
  String phone;
  bool _searching = false;
  String respStr = 'No Patient data';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _searching,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Search Patient', style: kHeadTextStyle,),
              SizedBox(height: 20.0,),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.notoSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700
                      ),
                      decoration: kUpdateDetailsInputDecoration.copyWith(
                        hintText: 'Enter Phone Number',
                      ),
                      onChanged: (newVal) {
                        phone = newVal;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _searching = true;
                      });
                      try {
                        ManageUserService userService = ManageUserService();

                        var resp = await userService.getUserDetails('phone', phone);
                        setState(() {
                          patients = resp.data;
                          _searching = false;
                        });
                      } catch(e) {
                        setState(() {
                          _searching = false;
                          respStr = e.response.data['message'];
                        });
                        print(e.response.data);
                      }
                    },
                    child: Icon(
                      FontAwesomeIcons.search
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 7.5),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              _generatePatientList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _generatePatientList() {
    if(patients.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            respStr,
            style: kHeadTextStyle.copyWith(color: kDarkBackColor),
          ),
        ),
      );
    }
    return Expanded(
      child: GridView.count(
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: _generateUserList(),
      )
    );
  }

  List<Widget> _generateUserList() {

    List<Widget> returnList = [];

    for(var i in patients) {
      returnList.add(
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [BoxShadow(offset: Offset(1.0, 1.0), color: Colors.black.withOpacity(0.2), blurRadius: 5.0)]
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: kDarkBackColor.withOpacity(0.5),
                  backgroundImage: getImageUrl(i['profile'], i['gender']),
                ),
                SizedBox(height: 15.0,),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    '${i['firstName']} ${i['lastName']}',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                ElevatedButton(
                  onPressed: (){
                      Navigator.pop(context, i['username']);
                  },
                  child: Center(
                      child: Text(
                        'Select',
                        style: GoogleFonts.roboto(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      )
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kDarkBackColor.withOpacity(0.5))
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return returnList;
  }

  ImageProvider getImageUrl(String url, String gender) {
    if(url == null || url == '') {
      if(gender == 'M') {
        return AssetImage('images/male.png');
      } else {
        return AssetImage('images/female.png');
      }
    } else {
      return NetworkImage(url);
    }
  }
}
