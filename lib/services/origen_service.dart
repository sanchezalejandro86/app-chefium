import 'package:chefium/models/origen.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class OrigenService{
  final Dio cacheDio = DioClient.cacheDio;

  Future<List<Origen>> obtenerOrigenes() async{
    try{
      String url = '/origenes';
      Response response = await cacheDio.get(url, options: buildCacheOptions(Duration(days: 7)),);

      List<Origen> lista = Origen.fromJsonList(response.data);
      return lista;
    }catch(e){
      print(e);
      throw(e);
    }
  }
}