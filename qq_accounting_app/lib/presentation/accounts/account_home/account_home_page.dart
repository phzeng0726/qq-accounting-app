import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq_accounting_app/application/accounts/account_watcher/account_watcher_cubit.dart';
import 'package:qq_accounting_app/domain/accounts/account.dart';
import 'package:qq_accounting_app/presentation/accounts/account_home/widgets/account_list_view.dart';

class AccountHomePage extends StatelessWidget {
  const AccountHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '帳戶列表',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<AccountWatcherCubit, AccountWatcherState>(
                  builder: (context, state) => state.status.when(
                      initial: () => state.accountList.isEmpty
                          ? const Text('empty')
                          : AccountListView(
                              accounts: state.accountList,
                            ),
                      loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black45,
                            ),
                          ),
                      success: () => state.accountList.isEmpty
                          ? const Text('empty')
                          : AccountListView(
                              accounts: state.accountList,
                            ),
                      failure: () => const Text('failure')))),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              child: Text('+'),
              onPressed: () {
              },
            ),
          )
        ],
      ),
    );
  }
}
