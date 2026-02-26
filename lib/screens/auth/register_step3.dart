import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'register_step4.dart';

class RegisterStep3 extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const RegisterStep3({super.key, required this.previousData});

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final _formKey = GlobalKey<FormState>();

  final contactName = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        ...widget.previousData,
        "contactName": contactName.text.trim(),
        "email": email.text.trim(),
        "mobile": mobile.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterStep4(data: updatedData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("LOOP"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("STEP 3 OF 4"),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 0.75,
                color: AppColors.primary,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 30),
              buildField("Contact Person Name", contactName),
              buildField("Official Business Email", email, isEmail: true),
              buildField("Mobile Number", mobile),
              const Spacer(),
              ElevatedButton(
                onPressed: nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text(
                  "Next Step",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller,
      {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) return "Required field";
          if (isEmail && !value.contains("@"))
            return "Enter valid email";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}