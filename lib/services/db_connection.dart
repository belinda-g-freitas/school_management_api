import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';

class DBConnection {
  DBConnection();

  Future<MySQLConnectionPool> connect() async {
    /* final settings = ConnectionSettings(
      // host: 'localhost',
      // port: 3306,
      useSSL: true,
      user: 'gloria',
      password: 'localGB@2020',
      db: 'school_management_master_v1',
    ); */
    // return MySqlConnection.connect(settings);
    final connect = await MySQLConnectionPool(
      host: 'localhost',
      port: 3306,
      userName: 'gloria',
      password: 'localGB@2020',
      databaseName: 'school_management_master_v1',
      maxConnections: 10
    );
    return connect;
  }
}
