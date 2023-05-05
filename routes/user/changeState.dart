import 'dart:io';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:school_management_frog/services/db_connection.dart';

/// used to activate & deactivat user
/// If user is deactivated, they can't do anything.
/// So it's like delete them temporary

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
  if (method == 'PUT') {
    if (headers.keys.contains('content-type')) {
      switch (headers['Content-Type']) {
        case 'application/json':
          var data = body.isNotEmpty ? jsonDecode(body) : {};
          assert(data.containsKey('id') || params.containsKey('id') && params.containsKey('state') || data.containsKey('state'));

          var connect = await DBConnection().connect();

          var value = (data?['state'] ?? params['state']);

          IResultSet res = await connect.execute('UPDATE person SET deactivated = :state, updated_at = :date WHERE id = :id', {
            'state': value == true || value == 'true' ? 1 : 0,
            'date': '${DateTime.now()}',
            'id': params['id'] ?? data?['id'],
          }).whenComplete(() => connect.close());
          return Response(body: 'message: Success, data: $res');

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
