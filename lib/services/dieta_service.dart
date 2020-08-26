import 'package:chefium/models/dieta.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class DietaService{
  final Dio cacheDio = DioClient.cacheDio;

  Future<List<Dieta>> obetenerDietas() async{
    try{
      String url = '/dietas';
      Response response = await cacheDio.get(url, options: buildCacheOptions(Duration(days: 7)),);

      List<Dieta> lista = Dieta.fromJsonList(response.data);
      return lista;
    }catch(e){
      print(e);
      throw(e);
    }
  }
}