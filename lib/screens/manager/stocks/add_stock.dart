import 'dart:math';

import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/manager/stocks/product_list.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/stock_service.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:e_healthcare/widgets/date_input.dart';
import 'package:e_healthcare/widgets/select_input.dart';
import 'package:e_healthcare/widgets/simple_row_data.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddStock extends StatefulWidget {

  final data;

  AddStock({
    @required this.data,
  });

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {

  var product;
  int quantity = 0;
  String expire = '';
  double price = 0.0;
  double discount = 10.0;
  String resp = '';
  bool errorResp = false;
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _adding,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: kScreenPadding,
          children: <Widget>[
            Text('Add New Stocks', style: kHeadTextStyle,),
            SizedBox(height: 10.0,),
            Text(resp, style: TextStyle(color: (errorResp)?Colors.redAccent:Colors.green, fontSize: 12.0), textAlign: TextAlign.center,),
            SizedBox(height: 10.0,),
            Text('Product Name', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            SelectInput(
              text: (product == null)?'':product['name'],
              onPressed: () async {
                var productData = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductLIst(data: widget.data, returnId: true,);
                }));

                setState(() {
                  product = productData;
                });
              },
            ),
            SizedBox(height: 20.0,),
            Text('quantity', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                quantity = int.parse(newValue);
              },
              displayLabel: false,
              keyboardType: TextInputType.number,
              update: true,
            ),
            SizedBox(height: 20.0,),
            Text('Expire Date', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            DateInput(
              onChange: (newVal) {
                expire = newVal;
              },
              update: true,
              label: false,
              displayHintText: false,
              highLastDate: true,
            ),
            SizedBox(height: 20.0,),
            Text('Price', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                setState(() {
                  price = double.parse(newValue);
                });
              },
              displayLabel: false,
              keyboardType: TextInputType.number,
              update: true,
            ),
            SizedBox(height: 20.0,),
            Text('Discount', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('$discount%', style: kLabelTextStyle.copyWith(fontSize: 14.0),),
                Expanded(
                  child: Slider(
                    value: discount,
                    min: 0.0,
                    max: 100.0,
                    divisions: 200,
                    activeColor: kPrimaryColor,
                    inactiveColor: kPrimaryLighter.withOpacity(0.5),
                    label: discount.toString(),
                    onChanged: (newVal){
                      setState(() {
                        discount = double.parse(newVal.toStringAsFixed(2));
                      });
                    }
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0,),
            SimpleRowData(title: 'Effective Price', value: '\u20B9${price - (discount*price)/100}', boldVal: false,),
            SizedBox(height: 15.0,),
            ElevatedButton(
              onPressed: () async {
                if(product == null || quantity == 0 || expire == '' || price == 0.0) {
                  setState(() {
                    resp = 'Please fill in all the details!';
                    errorResp = true;
                  });
                }
                setState(() {
                  _adding = true;
                });
                try {
                  StockService stockService = StockService();
                  var response = await stockService.addItemInStock(
                      product['id'],
                      quantity,
                      expire,
                      price,
                      discount
                  );

                  setState(() {
                    _adding = false;
                    resp = 'Item added successfully!';
                    errorResp = false;
                  });
                } catch(e) {
                  setState(() {
                    _adding = false;
                    resp = 'Error: could not add product in stocks';
                    errorResp = true;
                  });
                }
              },
              child: Text(
                  'Add Stock'
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
