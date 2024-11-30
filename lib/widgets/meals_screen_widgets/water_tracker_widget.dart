import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_settings_provider.dart';
import '../../providers/water_consumption_provider.dart';
import '../../models/user_settings.dart';
import '../../models/water_consumption.dart';   
import '../../dialogs/water_goal_congratulations_dialog.dart';

class WaterTrackerWidget extends StatefulWidget {
  final DateTime selectedDate;

  const WaterTrackerWidget({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<WaterTrackerWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<WaterConsumptionProvider>(context, listen: false)
        .selectedDate = widget.selectedDate;
  }

  @override
  void didUpdateWidget(WaterTrackerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      Provider.of<WaterConsumptionProvider>(context, listen: false)
          .selectedDate = widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserSettingsProvider, WaterConsumptionProvider>(
      builder: (context, settingsProvider, waterProvider, child) {
        return FutureBuilder<UserSettings?>(
          future: settingsProvider.object,
          builder: (context, AsyncSnapshot<UserSettings?> settingsSnapshot) {
            if (!settingsSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return FutureBuilder<WaterConsumption?>(
              future: waterProvider.object,
              builder: (context, AsyncSnapshot<WaterConsumption?> waterSnapshot) {
                print('Water snapshot: ${waterSnapshot.data?.amount}');
                if (!waterSnapshot.hasData && !waterSnapshot.hasError) {
                  return const CircularProgressIndicator();
                }

                final waterGoal = settingsSnapshot.data!.waterGoal;
                final consumedWater = waterSnapshot.data?.amount ?? 0.0;
                final numberOfGlasses = (waterGoal / 0.25).ceil();

                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Água",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Meta: ${waterGoal.toStringAsFixed(2)}L",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "${consumedWater.toStringAsFixed(2)}L",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: List.generate(numberOfGlasses, (index) {
                                      final bool isFilled = index < (consumedWater / 0.25).floor();
                                      return Container(
                                        padding: const EdgeInsets.all(6),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: isFilled 
                                                        ? const Color(0xFFE3F2FD)
                                                        : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: isFilled 
                                                          ? const Color(0xFF2196F3)
                                                          : Colors.grey[300]!,
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      if (isFilled)
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 42,
                                                            decoration: BoxDecoration(
                                                              color: const Color(0xFF2196F3).withOpacity(0.2),
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                      Icon(
                                                        Icons.water_drop_outlined,
                                                        color: isFilled 
                                                            ? const Color(0xFF2196F3)
                                                            : Colors.grey[400],
                                                        size: 22,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${((index + 1) * 0.25).toStringAsFixed(1)}L',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isFilled 
                                                        ? const Color(0xFF2196F3)
                                                        : Colors.grey[500],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            // Botão de adicionar
                                            if (!isFilled && index == (consumedWater / 0.25).floor())
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      final currentWater = consumedWater;
                                                      await waterProvider.addWater(0.25);
                                                      
                                                      // Mostra o diálogo APENAS quando acabou de completar
                                                      if (currentWater < waterGoal && 
                                                          (currentWater + 0.25) >= waterGoal) {
                                                        WaterGoalCongratulationsDialog.show(context);
                                                      }
                                                    },
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0x29000000),
                                                            blurRadius: 3,
                                                            offset: Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.add_circle,
                                                        color: Colors.black87,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            // Botão de remover
                                            if (isFilled)
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await waterProvider.removeWater(0.25);
                                                    },
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0x29000000),
                                                            blurRadius: 3,
                                                            offset: Offset(0, 1),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.black87,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
