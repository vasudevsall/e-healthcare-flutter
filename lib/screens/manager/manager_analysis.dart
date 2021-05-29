import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/count_service.dart';
import 'package:e_healthcare/widgets/dash_card.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ManagerAnalysis extends StatefulWidget {
  final data;
  ManagerAnalysis({
    @required this.data
  }):assert(data!=null);

  @override
  _ManagerAnalysisState createState() => _ManagerAnalysisState();
}

class _ManagerAnalysisState extends State<ManagerAnalysis> {

  var appointmentCount;
  int maximum = 0;
  var userCount;
  var roomCount;
  bool appointmentCountAvailable = false;
  bool userCountAvailable = false;
  bool roomCountAvailable = false;
  List<double> graphData = [];


  void _getAppointmentCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getAppointmentCount();

      setState(() {
        appointmentCount = resp.data;
        appointmentCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  void _getUserCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getUserCount();

      setState(() {
        userCount = resp.data;
        userCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  void _getRoomCount() async {
    try {
      CountService countService = CountService();
      var resp = await countService.getRoomCount();

      setState(() {
        roomCount = resp.data;
        roomCountAvailable = true;
      });
    } catch(e) {
      print(e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserCount();
    _getRoomCount();
    _getAppointmentCount();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: ManagerDrawer(data: widget.data,),
      body: Container(
        child: _generateAppointmentReport(),
      ),
    );
  }

  Widget _generateAppointmentReport() {
    if(!appointmentCountAvailable || !userCountAvailable || !roomCountAvailable) {
      return Center(
        child: kDashBoxAlternateSpinner,
      );
    }
    return ListView(
      padding: kScreenPadding,
      children: [
        Text(
          'Recent',
          style: kHeadTextStyle,
        ),
        SizedBox(height: 20.0,),
        DashCard(
          head: Text(
            'Appointment History',
            style: kHeadTextStyle.copyWith(
                fontSize: 16.0
            ),
          ),
          children: [
            LineGraph(
              features: _getFeatures(),
              size: Size(200, 200),
              labelX: _dayLabels(),
              labelY: [
                '0', (maximum/4).toStringAsFixed(0),
                (maximum/2).toStringAsFixed(0), (3 * maximum/4).toStringAsFixed(0),
                (maximum).toString()
              ],
              graphColor: kPrimaryColor,
            )
          ]
        ),
        SizedBox(height: 20.0,),
        _roomCard('W', 'Ward'),
        SizedBox(height: 20.0,),
        _roomCard('I', 'ICU'),
        SizedBox(height: 20.0,),
        _roomCard('O', "Operation Theatre"),
        SizedBox(height: 20.0,),
        DashCard(
          head: Text('Users', style: kHeadTextStyle.copyWith(fontSize: 16.0),),
          children: [
            SimpleRowData(title: 'Patients', value: userCount[kUser].toString()),
            SimpleRowData(title: 'Doctors', value: userCount[kDoctor].toString()),
            SimpleRowData(title: 'Managers', value: userCount[kManager].toString()),
            PieChart(
              dataMap: _generateUserMap(),
              colorList: colorList,
              initialAngleInDegree: 90.0,
              chartRadius: 160.0,
              chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true
              ),
            )
          ]
        ),
      ],
    );
  }

  DashCard _roomCard(roomType, roomName) {
    return DashCard(
      head: Text(
        roomName,
        style: kHeadTextStyle.copyWith(
            fontSize: 16.0
        ),
      ),
      children: [
        SimpleRowData(title: 'Total Beds', value: roomCount[roomType]['total'].toString()),
        SimpleRowData(title: 'Available Beds', value: roomCount[roomType]['available'].toString()),
        SimpleRowData(
            title: 'Occupancy Percentage',
            value: ((roomCount[roomType]['total'] - roomCount[roomType]['available'])/roomCount[roomType]['total'] * 100.0).toStringAsFixed(1) + '%'
        ),
        PieChart(
          dataMap: _generateWardDataMap(roomType),
          colorList: colorList,
          chartRadius: 160.0,
          chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true
          ),
        ),
      ],
      );
  }

  Map<String, double> _generateWardDataMap(roomType) {
    return {
      'Occupied': (roomCount[roomType]['total'] - roomCount[roomType]['available']).toDouble(),
      'Empty': roomCount[roomType]['available'].toDouble()
    };
  }

  Map<String, double> _generateUserMap() {
    return {
      'Patients': userCount[kUser].toDouble(),
      'Doctors': userCount[kDoctor].toDouble(),
      'Managers': userCount[kManager].toDouble()
    };
  }

  List<String> _dayLabels() {
    List<String> returnList = [];
    DateTime today = DateTime.now();
    List<double> valList  = [];
    for(int i=0; i<10; i++) {
      String date = today.subtract(Duration(days: i)).toString().substring(0, 10);
      returnList.add(date.substring(8));

      int count = (appointmentCount[date] == null)?0:appointmentCount[date];
      print(date + " -> " +  count.toString());

      valList.add(count.toDouble());

      if(count > maximum) {
        setState(() {
          maximum = appointmentCount[date];
        });
      }
    }

    valList.map((e) => e/maximum);

    setState(() {
      graphData = List.from(valList.reversed);
    });

    return List.from(returnList.reversed);
  }

  List<Feature> _getFeatures() {
    return [
      Feature(
        color: kPrimaryColor,
        data: graphData
      )
    ];
  }
}
