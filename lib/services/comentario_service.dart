import 'package:chefium/models/paginacion.dart';
import 'package:chefium/models/comentario.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';

class ComentarioService {
  final Dio authDio = DioClient.authDio;

  Future<Comentario> obtenerComentario(int id) async {
    try {
      String url = "/comentarios/$id";
      Response response = await authDio.get(url);

      Comentario comentario = Comentario.fromJson(response.data);
      return comentario;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Paginacion> obtenerBusqueda(Map<String, dynamic> query) async {
    try {
      String url = '/comentarios';
      Response response = await authDio.get(url, queryParameters: query);

      Paginacion paginacion = Paginacion.fromJson(response.data, "comentarios");
      return paginacion;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Comentario> crearComentario(Map<String, dynamic> data) async {
    try {
      String url = '/comentarios';
      Response response = await authDio.post(url, data: data);
      return Comentario.fromJson(response.data);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Comentario> editarComentario(int id, Map<String, dynamic> data) async {
    try {
      String url = '/comentarios/$id';
      Response response = await authDio.put(url, data: data);
      return Comentario.fromJson(response.data);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<bool> eliminarComentario(int id) async {
    try {
      String url = '/comentarios/$id';
      Response response = await authDio.delete(url);
      return true;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
