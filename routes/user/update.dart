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

          connect.execute('SELECT * FROM person WHERE email = :email', {'email': data?['email'] ?? params['email']}).then((value) async {
            String access = value.rows.single.colAt(14)?.toLowerCase() == 'admin' ? 'access = :access,' : '';
            await connect.execute(
                'UPDATE person SET firstname = :fname, lastname = :lname, gender = :gender, email = :email, password = :pwd, address = :address, degree = :degree, date_of_birth = :bday, profession = :job, $access civility = :civility, deactivated = :state WHERE email = :email',
                {
                  'lname': params['lastname'] ?? data?['lastname'] ?? value.rows.single.assoc()['lastname'],
                  'fname': params['firstname'] ?? data?['firstname'] ?? value.rows.single.assoc()['firstname'],
                  'gender': params['gender'] ?? data?['gender'] ?? value.rows.single.assoc()['gender'],
                  'email': params['email'] ?? data?['email'] ?? value.rows.single.assoc()['email'],
                  'pwd': params['password'] ?? data?['password'] ?? value.rows.single.assoc()['password'],
                  'address': params['address'] ?? data?['address'] ?? value.rows.single.assoc()['address'],
                  'degree': params['degree'] ?? data?['degree'] ?? value.rows.single.assoc()['degree'],
                  'bday': params['bday'] ?? data?['bday'] ?? value.rows.single.assoc()['bday'],
                  'job': params['profession'] ?? data?['profession'] ?? value.rows.single.assoc()['profession'],
                  'access': params['access'] ?? data?['access'] ?? value.rows.single.assoc()['access'],
                  'civility': params['civility'] ?? data?['civility'] ?? value.rows.single.assoc()['civility'],
                  'deactivated': params['deactivated'] ?? data?['deactivated'] ?? value.rows.single.assoc()['deactivated'],
                }).whenComplete(() => connect.close());
          });
          return Response(body: 'message: Success');

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
