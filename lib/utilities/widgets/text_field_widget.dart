import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_bloc.dart';
import 'package:oktava/services/auth/bloc/auth_event.dart';
import 'package:oktava/utilities/constants/color_constants.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChange;
  final String userId;
  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.text,
    required this.onChange,
    required this.userId,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: mainColor),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: secondaryColor,
            filled: true,
          ),
          style: const TextStyle(color: mainColor),
          onChanged: (name) {
            context
                .read<AuthBloc>()
                .add(AuthEventUpdateUser(name, null, widget.userId));
          },
        ),

      ],
    );
  }
}
