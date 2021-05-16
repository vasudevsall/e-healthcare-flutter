import 'package:flutter/material.dart';

const List<DropdownMenuItem> bloodGroupList = [
  DropdownMenuItem(child: Center(child: Text('A+')), value: 'A+',),
  DropdownMenuItem(child: Center(child: Text('A-')), value: 'A-',),
  DropdownMenuItem(child: Center(child: Text('B+')), value: 'B+',),
  DropdownMenuItem(child: Center(child: Text('B-')), value: 'B-',),
  DropdownMenuItem(child: Center(child: Text('AB+')), value: 'AB+',),
  DropdownMenuItem(child: Center(child: Text('AB-')), value: 'AB-',),
  DropdownMenuItem(child: Center(child: Text('O+')), value: 'O+',),
  DropdownMenuItem(child: Center(child: Text('O-')), value: 'O-',),
];

const List<DropdownMenuItem> genderList = [
  DropdownMenuItem(child: Center(child: Text('Male')), value: 'M',),
  DropdownMenuItem(child: Center(child: Text('Female')), value: 'F',),
  DropdownMenuItem(child: Center(child: Text('Other')), value: 'O',),
];