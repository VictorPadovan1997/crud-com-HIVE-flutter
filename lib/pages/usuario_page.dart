import 'package:estudo_crud_flutter_com_hive/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../config/hive/boxes.dart';
import 'components/user_dialog.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Hive Expense Tracker'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Usuario>>(
          valueListenable: Boxes.getBoxUsuario().listenable(),
          builder: (context, box, _) {
            final usuarios = box.values.toList().cast<Usuario>();

            return buildContent(usuarios);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => UserDialog(
              onClickedDone: addTransaction,
            ),
          ),
        ),
      );

  Widget buildContent(List<Usuario> usuario) {
    if (usuario.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      final netExpense = usuario.fold<double>(
        0,
        (previousValue, usuario) => usuario.isExpense
            ? previousValue - usuario.amount
            : previousValue + usuario.amount,
      );
      final newExpenseString = '\$${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Net Expense: $newExpenseString',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: usuario.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = usuario[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    Usuario usuario,
  ) {
    final color = usuario.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(usuario.createdDate);
    final amount = '\$' + usuario.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          usuario.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, usuario),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Usuario usuario) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDialog(
                    usuario: usuario,
                    onClickedDone: (name, amount, isExpense) => editTransaction(
                      usuario,
                      name,
                      amount,
                      isExpense,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteTransaction(usuario),
            ),
          )
        ],
      );

  Future addTransaction(String name, double amount, bool isExpense) async {
    Usuario userSaveInBox = Usuario(
      name: name,
      createdDate: DateTime.now(),
      isExpense: isExpense,
      amount: amount,
    );

    final box = Boxes.getBoxUsuario();
    box.add(userSaveInBox);
  }

  void editTransaction(
      Usuario usuario, String name, double amount, bool isExpense) {
    usuario.name = name;
    usuario.amount = amount;
    usuario.isExpense = isExpense;
    usuario.save();

    //Para funcionar o method save();
    //precisar ir ao model e dar um extends HiveObject
  }

  void deleteTransaction(Usuario usuario) {
    usuario.delete();
    //Para funcionar o method delete();
    //precisar ir ao model e dar um extends HiveObject
  }
}
