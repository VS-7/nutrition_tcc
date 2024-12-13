import 'package:flutter/material.dart';
import '../../models/user_settings.dart';
import '../../dialogs/edit_name_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../providers/services/sync_provider.dart';

enum MenuAction {
  backup,
  restore,
  logout,
}

class ProfileCardWidget extends StatelessWidget {
  final UserSettings settings;
  final double caloriesConsumed;
  final bool isLoggedIn;
  final VoidCallback onLoginTap;
  final VoidCallback onBackupTap;
  final VoidCallback onRestoreTap;
  final VoidCallback onLogoutTap;
  final String? userId;
  final Function(String imageUrl)? onProfilePictureUpdated;

  const ProfileCardWidget({
    Key? key,
    required this.settings,
    required this.caloriesConsumed,
    required this.isLoggedIn,
    required this.onLoginTap,
    required this.onBackupTap,
    required this.onRestoreTap,
    required this.onLogoutTap,
    this.userId,
    this.onProfilePictureUpdated,
  }) : super(key: key);

  void _showEditNameDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditNameBottomSheet(settings: settings),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    if (userId == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null && context.mounted) {
      final syncProvider = Provider.of<SyncProvider>(context, listen: false);
      final String? imageUrl = await syncProvider.uploadProfilePicture(userId!, image);
      
      if (imageUrl != null && onProfilePictureUpdated != null) {
        onProfilePictureUpdated!(imageUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = caloriesConsumed / settings.calorieGoal;
    progress = progress.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFA7E100),
                      const Color(0xFFA7E100).withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[100],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA7E100)),
                        ),
                      ),
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        backgroundImage: settings.profilePictureUrl.isNotEmpty
                            ? CachedNetworkImageProvider(settings.profilePictureUrl)
                            : const AssetImage('assets/images/logo.png') as ImageProvider,
                        child: isLoggedIn
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () => _pickAndUploadImage(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFA7E100),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 0),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  settings.name.isEmpty ? 'Usuário' : settings.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () => _showEditNameDialog(context),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                constraints: const BoxConstraints(),
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                        if (!isLoggedIn)
                          TextButton(
                            onPressed: onLoginTap,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFA7E100),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Entrar'),
                          )
                        else
                          PopupMenuButton<MenuAction>(
                            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: MenuAction.backup,
                                child: Row(
                                  children: [
                                    Icon(Icons.backup_outlined, size: 20),
                                    SizedBox(width: 12),
                                    Text('Fazer Backup'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: MenuAction.restore,
                                child: Row(
                                  children: [
                                    Icon(Icons.restore_outlined, size: 20),
                                    SizedBox(width: 12),
                                    Text('Restaurar Backup'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: MenuAction.logout,
                                child: Row(
                                  children: [
                                    Icon(Icons.logout_outlined, size: 20),
                                    SizedBox(width: 12),
                                    Text('Sair'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (MenuAction value) {
                              switch (value) {
                                case MenuAction.backup:
                                  onBackupTap();
                                  break;
                                case MenuAction.restore:
                                  onRestoreTap();
                                  break;
                                case MenuAction.logout:
                                  onLogoutTap();
                                  break;
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildInfoChip('🎂 ${settings.age} Anos'),
                          const SizedBox(width: 8),
                          _buildInfoChip('🎯 ${settings.goal}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Kcal Restante',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 ${(settings.calorieGoal - caloriesConsumed).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}