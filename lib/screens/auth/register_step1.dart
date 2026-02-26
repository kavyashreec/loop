import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'register_step2.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final _formKey = GlobalKey<FormState>();

  final businessName = TextEditingController();
  final businessType = TextEditingController();
  final description = TextEditingController();
  final regId = TextEditingController();
  final year = TextEditingController();

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterStep2(
            businessName: businessName.text.trim(),
            businessType: businessType.text.trim(),
            description: description.text.trim(),
            regId: regId.text.trim(),
            year: year.text.trim(),
          ),
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
          child: ListView(
            children: [
              const Text("STEP 1 OF 4"),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 0.25,
                color: AppColors.primary,
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(height: 30),
              const Text(
                "Tell Us About Your Business",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              buildField("Business Name", businessName),
              buildField("Business Type", businessType),
              buildField("Business Description (Optional)", description,
                  required: false),
              buildField("Unique Registration ID", regId),
              buildField("Year of Establishment", year),
              const SizedBox(height: 40),
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
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (!required) return null;
          if (value == null || value.isEmpty) return "Required field";
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