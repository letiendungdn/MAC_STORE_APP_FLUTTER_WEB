import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/buyer.dart';
import 'package:http/http.dart' as http;

class BuyerController {
  Future<List<Buyer>> loadBuyers() async {
    try {
      //send an http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        //ok
        List<dynamic> data = jsonDecode(response.body);

        List<Buyer> buyers = data.map((buyer) => Buyer.fromMap(buyer)).toList();
        return buyers;
      } else {
        //throw an exception if the server responsed with an error status code
        throw Exception('Failed to load Banners');
      }
    } catch (e) {
      throw Exception('Error loading Banners ');
    }
  }
}
