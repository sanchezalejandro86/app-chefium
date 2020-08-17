import 'package:chefium/models/categoria.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class CategoriaService{
  final Dio authDio = DioClient.authDio;

  Future<List<Categoria>> obtenerCategorias() async{
    try{
      String url = '/categorias';
      Response response = await authDio.get(url);

      List<Categoria> lista = Categoria.fromJsonList(response.data);
      return lista;
    } catch (e){
      print(e);
      throw(e);
    }
  }
}