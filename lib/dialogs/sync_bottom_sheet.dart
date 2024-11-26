// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/services/firebase_auth_provider.dart';
import '../providers/services/sync_provider.dart';
import '../providers/services/user_json_data_provider.dart';
import '../models/user_settings.dart';

class SyncDialog extends StatefulWidget {
  final bool isSaving;
  const SyncDialog(this.isSaving, {super.key});

  @override
  State<SyncDialog> createState() => _SyncDialogState();
}

class _SyncDialogState extends State<SyncDialog> {
  bool _isLoading = false;
  String? errorMsg;

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  void _chooseLocal(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    
    final String? userFirebaseId = context.read<FirebaseAuthProvider>().uid;
    if (userFirebaseId == null) return;

    final String? anyError = await context.read<SyncProvider>().upload(userFirebaseId);
    
    setState(() {
      _isLoading = false;
    });

    if (anyError != null) {
      setState(() {
        errorMsg = anyError;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  void _chooseRemote(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    
    final String? userFirebaseId = context.read<FirebaseAuthProvider>().uid;
    if (userFirebaseId == null) return;

    final String? anyError = await context.read<SyncProvider>().download(userFirebaseId);
    
    setState(() {
      _isLoading = false;
    });

    if (anyError != null) {
      setState(() {
        errorMsg = anyError;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isSaving
            ? "Deseja fazer backup dos seus dados?"
            : "Deseja carregar seus dados do backup?",
      ),
      content: FutureBuilder<Map<String, dynamic>>(
        future: Future.wait([
          context.read<UserJsonDataProvider>().readData(),
          context.read<SyncProvider>().getLastSync(
            context.read<FirebaseAuthProvider>().uid ?? '',
          ),
        ]).then((results) {
          final localSettings = results[0] as UserSettings?;
          final lastSync = results[1] as DateTime?;
          return {
            'localSettings': localSettings,
            'lastSync': lastSync,
          };
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Text("Erro: ${snapshot.error}");
          }
          
          if (!snapshot.hasData) {
            return const Text("Sem dados disponíveis");
          }

          final localSettings = snapshot.data!['localSettings'] as UserSettings?;
          final lastSync = snapshot.data!['lastSync'] as DateTime?;

          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (lastSync == null)
                      const Text("Não possui nenhum backup salvo.")
                    else
                      Text(
                        widget.isSaving
                            ? "Tem certeza? Os dados do seu último backup serão substituídos. Essa ação não pode ser desfeita."
                            : "Tem certeza? Os dados do seu dispositivo serão substituídos pelo backup. Essa ação não pode ser desfeita.",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text("Dados Locais"),
                          Text("Meta Calórica: ${localSettings?.calorieGoal ?? 0} kcal"),
                          Text("Carboidratos: ${localSettings?.carbGoal ?? 0}g"),
                          Text("Proteínas: ${localSettings?.proteinGoal ?? 0}g"),
                          Text("Gorduras: ${localSettings?.fatGoal ?? 0}g"),
                          if (lastSync != null) ...[
                            const SizedBox(height: 8),
                            Text("Último backup em:"),
                            Text(_formatDate(lastSync)),
                          ],
                        ],
                      ),
                    ),
                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorMsg!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
        },
      ),
      actions: (!_isLoading)
          ? [
              TextButton(
                onPressed: () => _cancel(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (widget.isSaving) {
                    _chooseLocal(context);
                  } else {
                    _chooseRemote(context);
                  }
                },
                child: Text(widget.isSaving ? "Fazer Backup" : "Carregar Backup"),
              ),
            ]
          : [],
    );
  }
}
