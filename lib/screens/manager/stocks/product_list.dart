import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/manager/stocks/item.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/stock_service.dart';
import 'package:e_healthcare/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductLIst extends StatefulWidget {

  final data;
  final bool returnId;
  ProductLIst({
    @required this.data,
    this.returnId = false,
  });

  @override
  _ProductLIstState createState() => _ProductLIstState();
}

class _ProductLIstState extends State<ProductLIst> {

  bool productDataAvailable = false;
  var productData;
  bool _searching = false;

  String productName;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _searching,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: Padding(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Search Products', style: kHeadTextStyle,),
              SizedBox(height: 20.0,),
              SearchBar(
                onPressed: () async {
                  setState(() {
                    _searching = true;
                  });
                  try {
                    StockService stockService = StockService();
                    var resp = await stockService.getStocks(name: (productName == '')?null:productName);
                    setState(() {
                      _searching = false;
                      productData = resp.data;
                      productDataAvailable = true;
                    });
                  } catch(e) {
                    setState(() {
                      _searching = false;
                    });
                    print("Product List: ");
                    print(e.response.data);
                  }
                },
                onChanged: (newVal) {
                  setState(() {
                    productName = newVal;
                  });
                },
                hintText: 'Enter Product Name',
              ),
              SizedBox(height: 20.0,),
              _displayProductColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayProductColumn() {
    if(!productDataAvailable || productData.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            'No products found',
            style: kHeadTextStyle.copyWith(color: kDarkBackColor)
          ),
        )
      );
    }
    return Expanded(
      child: ListView(
        children: _generateProductList(),
      ),
    );
  }

  List<Widget> _generateProductList() {
    List<Widget> productList = [];

    for(var i in productData) {
      productList.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Material(
            color: kPrimaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: InkWell(
              onTap: (widget.returnId)?(){
                Navigator.pop(context, i);
              }
                :() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Item(data: widget.data, itemData: i);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Center(
                        child: Text(
                          '${i['id']}.',
                          style: kDashBoxHeadTextStyle.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.0
                          ),
                        )
                    ),
                    SizedBox(width: 15.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(i['name'], style: kDashBoxHeadTextStyle,),
                          Flexible(
                            child: Text(
                              i['composition'],
                              style: kDashBoxHeadTextStyle.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 10.0
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(width: 5.0,),
                    Center(
                      child: Icon(
                        FontAwesomeIcons.arrowRight,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      );
    }

    return productList;
  }
}
