import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart'; // For date formatting

class DatePickerWidget extends StatefulWidget {
  final RxString selectedDate; // RxString to bind to the selected date
  final String? label;
  final Color firstControlColor;
  final Color secondControlColor;
  final Color textColor;

  // Constructor to accept the RxString selectedDate and theme colors
  DatePickerWidget({
    required this.selectedDate,
    required this.firstControlColor,
    required this.secondControlColor,
    required this.textColor,
    this.label = 'កាលបរិច្ឆេទ',
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize with current date
    _controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Format date as 'yyyy-MM-dd'
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextField to display selected date
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: AbsorbPointer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: TextEditingController(
                    text: _controller.text, // Text field initialized with formatted date
                  ),
                  decoration: InputDecoration(
                    labelText: widget.label,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        height: 60,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16)),
                          gradient: LinearGradient(
                            colors: [
                              widget.firstControlColor,
                              widget.secondControlColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.secondControlColor
                                  .withOpacity(0.3) ??
                                  Colors.white.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: widget.textColor,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show the Cupertino Date Picker
  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.black54,
        itemHeight: 80,
        titleHeight: 60,
        pickerHeight: 250,
        itemTextStyle: TextStyle(
          color: widget.textColor,
          fontFamily: 'MyBaseEnFont',
          fontWeight: FontWeight.bold,
        ),
        cancel: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'បោះបង់',
            style: TextStyle(
              color: widget.textColor,
              fontSize: 18,
              fontFamily: 'MyBaseFont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        selectionOverlay: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.secondControlColor.withOpacity(0.1),
          ),
        ),
        confirm: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'រួចរាល់',
            style: TextStyle(
              color: widget.textColor,
              fontSize: 18,
              fontFamily: 'MyBaseFont',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      context,
      initialDateTime: _selectedDate, // Start with the current date
      minDateTime: DateTime(2020, 1, 1),
      maxDateTime: DateTime(2030, 12, 31),
      dateFormat: 'yyyy-MM-dd', // Format of the displayed date
      onConfirm: (dateTime, selectedIndex) {
        setState(() {
          _selectedDate = dateTime;
          // Update the text controller with the formatted date
          _controller.text = DateFormat('yyyy-MM-dd').format(dateTime);
          // Update the RxString (reactive variable in the controller) with the formatted date
          widget.selectedDate.value = DateFormat('yyyy-MM-dd').format(dateTime);
        });
      },
    );
  }

}
