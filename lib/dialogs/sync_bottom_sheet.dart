// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/services/firebase_auth_provider.dart';
import '../providers/services/sync_provider.dart';
import '../providers/services/user_json_data_provider.dart';
import '../providers/user_settings_provider.dart';
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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<void> _handleSync(BuildContext context, bool isUpload) async {
    setState(() => _isLoading = true);
    
    final String? userFirebaseId = Provider.of<FirebaseAuthProvider>(context, listen: false).uid;
    if (userFirebaseId == null) return;

    final userSettings = await Provider.of<UserSettingsProvider>(context, listen: false).object;
    if (userSettings == null) return;

    final String? anyError = isUpload 
        ? await Provider.of<SyncProvider>(context, listen: false).upload(userFirebaseId, userSettings)
        : await Provider.of<SyncProvider>(context, listen: false).download(userFirebaseId, context);
    
    setState(() {
      _isLoading = false;
      errorMsg = anyError;
    });

    if (anyError == null && mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }

  Widget _buildDataContainer(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              const SizedBox(height: 12),
              Text(
                widget.isSaving ? 'Backup de Dados' : 'Restaurar Dados',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FutureBuilder<Map<String, dynamic>>(
                future: Future.wait<dynamic>([
                  Provider.of<UserJsonDataProvider>(context, listen: false).readData(),
                  Provider.of<SyncProvider>(context, listen: false).getLastSync(
                    Provider.of<FirebaseAuthProvider>(context, listen: false).uid ?? '',
                  ),
                ]).then((results) => {
                  'localSettings': results[0] as UserSettings?,
                  'lastSync': results[1] as DateTime?,
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return Text(
                      "Erro: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  
                  if (!snapshot.hasData) {
                    return const Text(
                      "Sem dados disponíveis",
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  final localSettings = snapshot.data!['localSettings'] as UserSettings?;
                  final lastSync = snapshot.data!['lastSync'] as DateTime?;

                  return _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDataContainer(
                              'Dados Locais',
                              [
                                Text(
                                  'Meta Calórica: ${localSettings?.calorieGoal ?? 0} kcal',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                Text(
                                  'Carboidratos: ${localSettings?.carbGoal ?? 0}g',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                Text(
                                  'Proteínas: ${localSettings?.proteinGoal ?? 0}g',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                Text(
                                  'Gorduras: ${localSettings?.fatGoal ?? 0}g',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                if (lastSync != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Último backup: ${_formatDate(lastSync)}',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ],
                            ),
                            if (errorMsg != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  errorMsg!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _handleSync(context, widget.isSaving),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[900],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(widget.isSaving ? 'Fazer Backup' : 'Restaurar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
