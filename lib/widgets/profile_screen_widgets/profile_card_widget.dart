import 'package:flutter/material.dart';
import '../../models/user_settings.dart';

class ProfileCardWidget extends StatelessWidget {
  final UserSettings settings;
  final double caloriesConsumed;
  final bool isLoggedIn;
  final VoidCallback onLoginTap;
  final VoidCallback onBackupTap;
  final VoidCallback onRestoreTap;
  final VoidCallback onLogoutTap;

  const ProfileCardWidget({
    Key? key,
    required this.settings,
    required this.caloriesConsumed,
    required this.isLoggedIn,
    required this.onLoginTap,
    required this.onBackupTap,
    required this.onRestoreTap,
    required this.onLogoutTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = caloriesConsumed / settings.calorieGoal;
    progress = progress.clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 85,
                    height: 85,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA7E100)),
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/icon.png'),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Usuário',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (!isLoggedIn)
                          TextButton(
                            onPressed: onLoginTap,
                            child: Text('Entrar'),
                          )
                        else
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text('Fazer Backup'),
                                onTap: onBackupTap,
                              ),
                              PopupMenuItem(
                                child: Text('Restaurar Backup'),
                                onTap: onRestoreTap,
                              ),
                              PopupMenuItem(
                                child: Text('Sair'),
                                onTap: onLogoutTap,
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '🎂 ${settings.age} Anos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '🎯 ${settings.goal}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Kcal Restante',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                '🔥 ${(settings.calorieGoal - caloriesConsumed).toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}