import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class IngredienteService{
  final Dio cacheDio = DioClient.cacheDio;

  Future<List<Ingrediente>> obtenerIngredientes() async{
    try{
      String url = '/ingredientes';
      Response response = await cacheDio.get(url, options: buildCacheOptions(Duration(days: 7)),);

      List<Ingrediente> lista = Ingrediente.fromJsonList(response.data);
      return lista;
    } catch(e){
      print(e);
      throw(e);
    }
  }
}