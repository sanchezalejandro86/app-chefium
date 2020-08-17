import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/receta.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class RecetaService {
  final Dio authDio = DioClient.authDio;

  Future<Receta> obtenerReceta(int id) async {
    try {
      String url = "/recetas/$id";
      Response response = await authDio.get(url);

      Receta receta = Receta.fromJson(response.data);
      return receta;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Paginacion> obtenerBusqueda(Map<String, dynamic> query) async {
    try {
      String url = '/recetas';
      Response response = await authDio.get(url, queryParameters: query);

      Paginacion paginacion = Paginacion.fromJson(response.data, "recetas");
      return paginacion;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Receta> crearReceta(Map<String, dynamic> data) async {
    try {
      String url = '/recetas';
      Response response = await authDio.post(url, data: data);
      return Receta.fromJson(response.data);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Receta> editarReceta(int id, Map<String, dynamic> data) async {
    try {
      String url = '/recetas/$id';
      Response response = await authDio.put(url, data: data);
      return Receta.fromJson(response.data);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<bool> eliminarReceta(int id) async {
    try {
      String url = '/recetas/$id';
      Response response = await authDio.delete(url);
      return true;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
