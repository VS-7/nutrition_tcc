import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/widget_order_provider.dart';

class WidgetOrderBottomSheet extends StatefulWidget {
  const WidgetOrderBottomSheet({Key? key}) : super(key: key);

  @override
  State<WidgetOrderBottomSheet> createState() => _WidgetOrderBottomSheetState();
}

class _WidgetOrderBottomSheetState extends State<WidgetOrderBottomSheet> {
  late List<String> _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = List.from(
      Provider.of<WidgetOrderProvider>(context, listen: false).widgetOrder
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<WidgetOrderProvider>(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(80)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Organizar Widgets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _currentOrder.map((widgetId) {
                        return ListTile(
                          key: ValueKey(widgetId),
                          title: Text(
                            orderProvider.getWidgetName(widgetId),
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.drag_handle,
                            color: Colors.white54,
                          ),
                          tileColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }).toList(),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = _currentOrder.removeAt(oldIndex);
                          _currentOrder.insert(newIndex, item);
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        orderProvider.updateOrder(_currentOrder);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
}