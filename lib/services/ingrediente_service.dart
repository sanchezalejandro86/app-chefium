import 'package:chefium/models/ingrediente.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class IngredienteService{
  final Dio authDio = DioClient.authDio;

  Future<List<Ingrediente>> obtenerIngredientes() async{
    try{
      String url = '/ingredientes';
      Response response = await authDio.get(url);

      List<Ingrediente> lista = Ingrediente.fromJsonList(response.data);
      return lista;
    } catch(e){
      print(e);
      throw(e);
    }
  }
}