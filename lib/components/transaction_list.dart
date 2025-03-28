import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactions, this.onRemove, {super.key});

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Não há transações cadastradas.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(252, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final tr = transactions[index];
                return Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FittedBox(
                            child: Text(
                              'R\$${tr.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white, // Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        tr.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('d MMM y').format(tr.date),
                      ),
                      trailing: MediaQuery.of(context).size.width > 480
                          ? TextButton.icon(
                              onPressed: () => onRemove(tr.id),
                              label: Text(
                                'Excluir',
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            )
                          : IconButton(
                              onPressed: () => onRemove(tr.id),
                              icon: Icon(Icons.delete),
                              color: Theme.of(context).colorScheme.error,
                              splashRadius: 25,
                              splashColor: Color.fromARGB(255, 243, 176, 182),
                            )),
                );
              },
            ),
          );
  }
}
