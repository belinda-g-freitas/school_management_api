import 'dart:io';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:school_management_frog/services/db_connection.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method.value;
  final headers = request.headers;
  final params = request.uri.queryParameters;
  final body = await request.body();

  if (headers['Accept'] != 'application/json') {
    return Response(statusCode: HttpStatus.expectationFailed, body: 'Error: Need "Accept" of type "application/json"');
  }

  // POST requests
  if (method == 'POST') {
    if (headers.keys.contains('content-type')) {
      switch (headers['Content-Type']) {
        case 'application/json':
          var data = jsonDecode(body);
          assert(data.containsKey('address'));
          //
          var connect = await DBConnection().connect();
          var address = await connect.prepare('INSERT INTO address (id, name) values (?, ?)');
          await address.execute([null, data['address']['name']]).then((res) async {
            // insert into person
            var user = await connect.prepare('INSERT INTO institution (id, name, logo, email, address) values (?, ?, ?, ?, ?)');
            user.execute([
              null,
              data['name'] ?? params['name'],
              data['logo'] ?? params['logo'],
              data['email'] ?? params['email'],
              res.lastInsertID,
            ]).then((value) {
              connect.close();
              return Response.json(body: {'message': 'Success', 'user_id': value});
            });
          });
          return Response(statusCode: HttpStatus.notImplemented);
        case 'multipart/form-data':
          // to upload photos
          final formData = await request.formData();
          final photo = formData.files['photo'];
          if (photo == null || photo.contentType.mimeType != ContentType('multipart/form-data', 'image').mimeType) {
            return Response(statusCode: HttpStatus.badRequest);
          } else if (!formData.files.containsKey('photo')) {
            return Response(statusCode: HttpStatus.expectationFailed, body: 'Field "photo" is required');
          }

          return Response.json(body: {'message': 'Success'});
        default:
          return Response(
            statusCode: HttpStatus.expectationFailed,
            body: 'Error: Need a "Content-Type" of type "application/json" or "multipart/form-data"',
          );
      }
    }

    // other requests
    if (headers['Content-Type'] == 'multipart/form-data') {}
  } else {
    return Response.json(statusCode: HttpStatus.methodNotAllowed, body: {'message': '$method method not allowed for this route'});
  }

  return Response(statusCode: HttpStatus.notImplemented);
}
