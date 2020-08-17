import 'package:chefium/models/origen.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class OrigenService{
  final Dio authDio = DioClient.authDio;

  Future<List<Origen>> obtenerOrigenes() async{
    try{
      String url = '/origenes';
      Response response = await authDio.get(url);

      List<Origen> lista = Origen.fromJsonList(response.data);
      return lista;
    }catch(e){
      print(e);
      throw(e);
    }
  }
}