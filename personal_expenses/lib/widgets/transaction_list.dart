import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) removeTransaction;

  TransactionList(this.transactions, this.removeTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.length == 0
        // Message and image of no transactions added
        ? Column(children: [
            Text(
              'No transactions added yet.',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            SizedBox(
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover,
              ),
              height: 200,
            )
          ])
        // List of transactions
        : Container(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) => Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${transactions[index].title}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(transactions[index].date)}',
                  ),
                  trailing: IconButton(
                    onPressed: (){
                      removeTransaction(transactions[index].id);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
