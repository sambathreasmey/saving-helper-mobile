import 'package:flutter/material.dart';

class EditableBoxField extends StatefulWidget {
  final String label;
  final String initialValue;
  final List<Color> colors;
  final Color labelColor;
  final double height;
  final String fontFamily;
  final String labelFontFamily;
  final void Function(String newValue)? onSave;

  const EditableBoxField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.colors,
    required this.labelColor,
    this.height = 65,
    this.fontFamily = 'MyBaseFont',
    this.labelFontFamily = 'MyBaseFont',
    this.onSave,
  });

  @override
  State<EditableBoxField> createState() => _EditableBoxFieldState();
}

class _EditableBoxFieldState extends State<EditableBoxField> {
  late TextEditingController _controller;
  late String _displayValue;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.initialValue;
    _controller = TextEditingController(text: _displayValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height + (_isEditing ? 20 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: widget.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.colors.last.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.labelColor,
                    fontSize: 15,
                    fontFamily: widget.labelFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: _isEditing
                    ? TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: widget.labelColor,
                    fontFamily: widget.fontFamily,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                  cursorColor: widget.labelColor,
                )
                    : Text(
                  _displayValue,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.labelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: widget.fontFamily,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (_isEditing) ...[
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      _displayValue = _controller.text.trim();
                      _isEditing = false;
                    });
                    widget.onSave?.call(_displayValue); // ✅ optional call
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white70,
                  onPressed: () {
                    setState(() {
                      _controller.text = _displayValue;
                      _isEditing = false;
                    });
                  },
                ),
              ] else if (widget.onSave != null)
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: widget.labelColor,
                  onPressed: () {
                    setState(() => _isEditing = true);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}