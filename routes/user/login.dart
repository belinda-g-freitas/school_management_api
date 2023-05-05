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

  // PUT requests
  if (method == 'POST') {
    if (headers.keys.contains('content-type')) {
      switch (headers['Content-Type']) {
        case 'application/json':
          var data = body.isNotEmpty ? jsonDecode(body) : {};
          assert(data.containsKey('email') || params.containsKey('email') && params.containsKey('password') || data.containsKey('password'));

          var connect = await DBConnection().connect();

          var result = await connect.execute('SELECT * FROM person WHERE email = :email AND password = :password', {
            'email': data?['email'] ?? params['email'],
            'password': data?['password'] ?? params['password'],
          }).then((value) {
            connect.close();
            return value.rows.length == 1
                ? value.rows.single.assoc()['deactivated'] == '1'
                    ? Response(body: 'message: Error, reason: Ce compte à été désactivé')
                    : Response(body: 'message: Success')
                : Response.json(body: {'message': 'Success', 'reason': 'No user with these credentials'});
          });

          return result;

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
