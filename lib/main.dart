import 'package:estudo_crud_flutter_com_hive/pages/usuario_page.dart';
import 'package:flutter/material.dart';

import 'config/hive/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await HiveConfig.resgisterAdapter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Hive Expense App';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: UsuarioPage(),
      );
}
