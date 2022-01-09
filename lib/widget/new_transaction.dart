import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaksi;

  NewTransaction(this.addTransaksi);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountCOntroller = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountCOntroller.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate== null){
      return;
    }

    widget.addTransaksi(
      enteredTitle,
      enteredAmount,
      _selectedDate
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountCOntroller,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen'
                              : 'Picked Date : ${DateFormat.yMd().format(_selectedDate!)}',
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _presentDatePicker,
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _submitData,
                  child: Text('Add Transactions'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button!.color,
                ),
              ],
            ),
          )),
    );
  }
}
