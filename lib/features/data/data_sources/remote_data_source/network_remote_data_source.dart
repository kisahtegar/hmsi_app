import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../domain/entities/informasi/informasi_entity.dart';
import '../../models/informasi/informasi_model.dart';

abstract class NetworkRemoteDataSource {
  Future<List<InformasiEntity>> fetchInformasi(InformasiEntity informasiEntity);
}

class NetworkRemoteDataSourceImpl implements NetworkRemoteDataSource {
  final http.Client client;

  final baseUrl =
      "https://hmsi-app-default-rtdb.asia-southeast1.firebasedatabase.app/";

  NetworkRemoteDataSourceImpl({required this.client});

  @override
  Future<List<InformasiEntity>> fetchInformasi(
      InformasiEntity informasiEntity) async {
    try {
      final response = await client.get(Uri.parse("$baseUrl/informasi.json"));
      List<dynamic> responses = jsonDecode(response.body) as List;
      debugPrint(response.body);
      if (response.statusCode == 200) {
        return responses.map((e) => InformasiModel.fromJson(e)).toList();
      } else {
        throw ("Some error occured");
      }
    } catch (e) {
      debugPrint("fetchTodos: $e");
      return [];
    }
  }
}
