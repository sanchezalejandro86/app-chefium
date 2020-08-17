import 'dart:convert';

import 'package:chefium/models/usuario.dart';
import 'package:chefium/utils/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  final Dio dio = DioClient.initDio;

  Future<Usuario> loginFacebook(String token) async {
    try {
      String url = '/usuarios/login/facebook';
      Map map = {'token': token};

      Response response = await dio.post(url, data: map);
      Usuario usuario = Usuario.fromJson(response.data);
      usuario.soyYo = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', usuario.token);
      prefs.setInt('id', usuario.id);
      prefs.setString('usuario', json.encode(usuario.toJson()));

      return usuario;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Usuario> loginGoogle(String token) async {
    try {
      String url = '/usuarios/login/google';
      Map map = {'token': token};

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(url, data: map);
      Usuario usuario = Usuario.fromJson(response.data);
      usuario.soyYo = true;

      prefs.setString('token', usuario.token);
      prefs.setInt('id', usuario.id);
      prefs.setString('usuario', json.encode(usuario.toJson()));

      return usuario;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<bool> existeUsuario() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('usuario')) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('id');
      prefs.remove('usuario');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Usuario> obtenerUsuario(int id) async {
    try {
      String url = "/usuarios/${id == null ? 'yo' : id}";

      Response response = await dio.get(url);
      Usuario usuario = Usuario.fromJson(response.data);

      return usuario;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Usuario> obtenerUsuarioLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('usuario')) {
        final Map decoded = json.decode(prefs.getString('usuario'));
        return Usuario.fromJson(decoded);
      }

      return Future.value(null);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> editarFavoritos(int recetaId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int usuarioId = prefs.getInt('id');
      String url = "/usuarios/$usuarioId/favoritas/$recetaId";
      Response response = await dio.put(url);
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<dynamic> toggleSeguir(int usuarioId) async {
    try {
      String url = "/usuarios/$usuarioId/seguir";
      Response response = await dio.put(url);
      return response.data;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<Usuario> editarUsuario(Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int usuarioId = prefs.getInt('id');
      String url = "/usuarios/$usuarioId";

      Response response = await dio.put(url, data: data);
      Usuario usuario = Usuario.fromJson(response.data);
      usuario.soyYo = true;
      return usuario;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
