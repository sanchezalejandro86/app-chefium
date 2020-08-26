import 'package:chefium/models/categoria.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class CategoriaService{
  final Dio cacheDio = DioClient.cacheDio;

  Future<List<Categoria>> obtenerCategorias() async{
    try{
      String url = '/categorias';
      Response response = await cacheDio.get(url, options: buildCacheOptions(Duration(days: 7)),);

      List<Categoria> lista = Categoria.fromJsonList(response.data);
      return lista;
    } catch (e){
      print(e);
      throw(e);
    }
  }
}