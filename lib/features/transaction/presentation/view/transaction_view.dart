import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_background_service/core/config/environment_config.dart';
import 'package:test_background_service/core/helper/helper.dart';
import 'package:test_background_service/features/transaction/domain/entities/transaction_entities.dart';
import 'package:test_background_service/features/transaction/domain/enum/transaction_enum.dart';
import 'package:test_background_service/features/transaction/presentation/bloc/transaction_bloc.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionEntities(
      id: Helper.next(),
      amount: _amountController.text,
      status: TransactionStatus.success,
    );

    context.read<TransactionBloc>().add(
      SendTransactionEvent(
        fcmToken: EnvironmentConfig.fcmToken,
        transaction: transaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        builder: (context, state) {
          final isLoading = state is TransactionLoading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _onSubmit(context),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is TransactionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Transaction Success ${state.transaction.amount}',
                ),
              ),
            );
          }
          if (state is TransactionFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure)));
          }
        },
      ),
    );
  }
}
