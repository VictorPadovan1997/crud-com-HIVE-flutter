import 'package:estudo_crud_flutter_com_hive/model/usuario.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Usuario> getBoxUsuario() => Hive.box<Usuario>('usuarios');
}
