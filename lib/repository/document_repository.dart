import 'dart:convert';

import 'package:flutter_google_docs_clone/constant.dart';
import 'package:flutter_google_docs_clone/models/document_model.dart';
import 'package:flutter_google_docs_clone/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  Future<ErrorModel?> createDocument(String token) async {
    ErrorModel errorModel = ErrorModel(error: "Error", data: null);
    try {
      var res = await _client.post(Uri.parse('$host/doc/create'),
          body:
              jsonEncode({'createdAt': DateTime.now().millisecondsSinceEpoch}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          });
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }

  Future<ErrorModel?> getDocumentByMe(String token) async {
    ErrorModel errorModel = ErrorModel(error: 'Error', data: null);

    try {
      var res = await _client.get(Uri.parse('$host/document/me'), headers: {
        'x-auth-token': token,
        'Content-Type': 'application/json; charset=UTF-8'
      });

      switch (res.statusCode) {
        case 200:
          List<DocumentModel?> documents = [];

          if (jsonDecode(res.body).isNotEmpty) {
            for (var i = 0; i < jsonDecode(res.body).length; i++) {
              documents.add(
                  DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
            }
          }

          errorModel = ErrorModel(error: null, data: documents);

          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }

  void updateDocumentTitle(String token, String id, String title) async {
    await _client.post(Uri.parse('$host/document/title'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({'id': id, 'title': title}));
  }

  Future<ErrorModel?> getDocumentById(String token, String id) async {
    ErrorModel errorModel = ErrorModel(error: 'Error', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/document/$id'),
        headers: {
          'x-auth-token': token,
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      errorModel = ErrorModel(error: e.toString(), data: null);
    }

    return errorModel;
  }
}
