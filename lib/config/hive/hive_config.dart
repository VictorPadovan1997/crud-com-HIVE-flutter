import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/usuario.dart';

class HiveConfig {
  static start() async {
    //Acessa o diretorio onde os arq. estao iniciializado
    Directory dir = await getApplicationDocumentsDirectory();
    print("iniciliazando hive em :" + dir.path);
    await Hive.initFlutter(dir.path);
  }

  static resgisterAdapter() async {
    // cria um box para armazenar os dados do usuario assim por cada model
    Hive.registerAdapter(UsuarioAdapter());
    await Hive.openBox<Usuario>('usuarios');
  }
}
