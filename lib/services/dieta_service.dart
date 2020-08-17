import 'package:chefium/models/dieta.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class DietaService{
  final Dio authDio = DioClient.authDio;

  Future<List<Dieta>> obetenerDietas() async{
    try{
      String url = '/dietas';
      Response response = await authDio.get(url);

      List<Dieta> lista = Dieta.fromJsonList(response.data);
      return lista;
    }catch(e){
      print(e);
      throw(e);
    }
  }
}