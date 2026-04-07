import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/vendor.dart';
import 'package:http/http.dart' as http;

class VendorController {
  Future<List<Vendor>> loadVendors() async {
    try {
      //send an http get request to fetch vendors
      http.Response response = await http.get(
        Uri.parse('$uri/api/vendors'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        //ok
        List<dynamic> data = jsonDecode(response.body);
        List<Vendor> vendors = data
            .map((vendor) => Vendor.fromMap(vendor as Map<String, dynamic>))
            .toList();
        return vendors;
      } else {
        //throw an exception if the server responsed with an error status code
        throw Exception('Failed to load Vendors');
      }
    } catch (e) {
      throw Exception('Error loading Vendors: $e');
    }
  }
}
