import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/stock_service.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Item extends StatefulWidget {

  final data;
  final itemData;

  Item({
    @required this.data,
    @required this.itemData,
  });

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {

  List<Widget> itemList;
  bool itemDataAvailable = false;
  int total;
  double minP;
  double maxP;

  void _getItemInStock() async {
    try {
      StockService stockService = StockService();
      var resp = await stockService.findItemInStock(widget.itemData['id']);

      List<Widget> buildList = [];
      int totalQuantity = 0;
      double minPrice = 100000;
      double maxPrice = 0;
      int index = 0;
      for(var i in resp.data) {
        if(i['price'] < minPrice) minPrice = i['price'];
        if(i['price'] > maxPrice) maxPrice = i['price'];
        totalQuantity += i['quantity'];
        DateTime date = DateTime(int.parse(i['expire'].substring(0,4)), int.parse(i['expire'].substring(5,7)),
            int.parse(i['expire'].substring(8))
        );
        Duration expireDate = date.difference(DateTime.now());
        print(date);
        print(expireDate.inDays);
        buildList.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(15.0),
            decoration: kDashBoxDecoration.copyWith(color: kPrimaryColor.withOpacity(0.7)),
            child: Column(
              children: [
                Text('${expireDate.inDays} days to expire', style: kDashBoxHeadTextStyle,),
                Divider(color: Colors.white,),
                SimpleRowData(
                  title: 'Batch No:',
                  value: "${i['product']['name'].substring(0,2).toUpperCase()}X0$index$index",
                  fontColor: Colors.white,
                ),
                SimpleRowData(title: 'Expire Date:', value: i['expire'], fontColor: Colors.white,),
                SimpleRowData(title: 'Quantity:', value: i['quantity'].toString(), fontColor: Colors.white,),
                SimpleRowData(title: 'Price', value: '\u20B9${i['price']}', fontColor: Colors.white,),
                SimpleRowData(title: 'Discount:', value: '${i['discount'].toString()}%', fontColor: Colors.white,),
              ],
            ),
          ),
        );
        index++;
      }

      setState(() {
        itemList = List.from(buildList.reversed);
        total = totalQuantity;
        minP = minPrice;
        maxP = maxPrice;
        itemDataAvailable = true;
      });
    } catch(e) {
      print("Item: " + e.response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getItemInStock();
  }

  @override
  Widget build(BuildContext context) {
    return UserScaffold(
      drawer: ManagerDrawer(data: widget.data,),
      body: _generateScaffoldBody(),
    );
  }

  Widget _generateScaffoldBody() {
    if(!itemDataAvailable) {
      return Center(child: kDashBoxAlternateSpinner,);
    }
    return ListView(
      padding: kScreenPadding,
      children: [
        Text('Stock Details', style: kHeadTextStyle,),
        SizedBox(height: 20.0,),
        SimpleRowData(title: 'Name:', value: widget.itemData['name'], boldVal: false,),
        Text(
          'Composition:',
          style: GoogleFonts.notoSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(height: 5.0,),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.itemData['composition'],
                style: GoogleFonts.notoSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400
                ),
              )
            ),
          ],
        ),
        SizedBox(height: 5.0,),
        SimpleRowData(title: 'Total Quantity:', value: total.toString(), boldVal: false,),
        SimpleRowData(title: 'Price Range:', value: '\u20B9${(minP == 100000)?0.0:minP} - \u20B9$maxP', boldVal: false,),
        SimpleRowData(
          title: 'Average Usage (weekly):',
          value: widget.itemData['use'].toString(),
          boldVal: false,
        ),
        SizedBox(height: 30.0,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _displayColumnChildren(),
        ),
      ],
    );
  }

  List<Widget> _displayColumnChildren() {
    if(itemList.isEmpty) {
      itemList.add(
          Text('Item Out of Stock!', style: kDashBoxHeadTextStyle.copyWith(color: kDarkBackColor),)
      );
    }
    return itemList;
  }
}
