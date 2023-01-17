import 'package:testddd/domain/i_shopdata_repository.dart';

import 'package:testddd/infrastructure/shopdata/data_entity.dart';
import 'package:injectable/injectable.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

@LazySingleton(as: IshopDataRepository)
class ShopDataRepository implements IshopDataRepository {
  var baseUrl = "https://dummyjson.com/products";

  @override
  Future<List<Datum>> watchAllProducts() async {
    var response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Datum> shopdata = Welcome.fromJson(data).data;
      return shopdata;
    } else {
      throw Exception();
    }
  }
}
