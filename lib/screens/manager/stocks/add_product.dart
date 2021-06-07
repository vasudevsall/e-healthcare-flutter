import 'package:e_healthcare/constants/constants.dart';
import 'package:e_healthcare/screens/manager/manager_drawer.dart';
import 'package:e_healthcare/screens/patient/user_scaffold.dart';
import 'package:e_healthcare/services/stock_service.dart';
import 'package:e_healthcare/widgets/custom_label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddProduct extends StatefulWidget {
  final data;

  AddProduct({
    @required this.data
  });

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  String resp = '';
  bool errorResp = false;

  String name = '';
  String composition = '';
  int use = 0;
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _adding,
      child: UserScaffold(
        drawer: ManagerDrawer(data: widget.data,),
        body: ListView(
          padding: kScreenPadding,
          children: [
            Text('Add New Product', style: kHeadTextStyle,),
            SizedBox(height: 10.0,),
            Text(resp, style: TextStyle(color: (errorResp)?Colors.redAccent:Colors.green, fontSize: 12.0), textAlign: TextAlign.center,),
            SizedBox(height: 10.0,),
            Text('Product Name', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                name = newValue;
              },
              displayLabel: false,
              update: true,
            ),
            SizedBox(height: 20.0,),
            Text('Composition', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newValue) {
                composition = newValue;
              },
              displayLabel: false,
              update: true,
              maxLines: 4,
            ),
            SizedBox(height: 20.0,),
            Text('Weekly Usage', style: kLabelTextStyle,),
            SizedBox(height: 7.5,),
            CustomLabelTextField(
              validator: (value){},
              onChange: (newVal) {
                use = int.parse(newVal);
              },
              update: true,
              displayLabel: false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () async {
                if(name == '' || composition == '' || use == 0) {
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
                  var response = await stockService.addNewItem(name, composition, use);

                  setState(() {
                    _adding = false;
                    resp = 'Item added successfully!';
                    errorResp = false;
                  });
                } catch(e) {
                  print(e);
                  setState(() {
                    _adding = false;
                    resp = 'Error: check details and try again';
                    errorResp = true;
                  });
                }
              },
              child: Text(
                  'Add Stock'
              ),
              style: ElevatedButton.styleFrom(primary: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
