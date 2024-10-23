import 'package:flutter/material.dart';

class WeeklyProgressBar extends StatelessWidget {
  final List<double> weeklyData;
  final double goal;
  final String title;
  final Color progressColor;

  const WeeklyProgressBar({
    Key? key,
    required this.weeklyData,
    required this.goal,
    required this.title,
    this.progressColor = const Color(0xFFA7E100),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxValue = weeklyData.reduce((curr, next) => curr > next ? curr : next);
    maxValue = maxValue > goal ? maxValue : goal;

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: List.generate(
              7,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: double.infinity,
                              height: (weeklyData[index] / maxValue) * 150,
                              decoration: BoxDecoration(
                                color: progressColor,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                              ),
                            ),
                            Positioned(
                              top: 150 - (goal / maxValue * 150),
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _getDayLabel(index),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        weeklyData[index].toStringAsFixed(0),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(progressColor, 'Consumido'),
              _buildLegendItem(Colors.black, 'Meta: ${goal.toStringAsFixed(0)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _getDayLabel(int index) {
    switch (index) {
      case 0:
        return 'Seg';
      case 1:
        return 'Ter';
      case 2:
        return 'Qua';
      case 3:
        return 'Qui';
      case 4:
        return 'Sex';
      case 5:
        return 'Sáb';
      case 6:
        return 'Dom';
      default:
        return '';
    }
  }
}
