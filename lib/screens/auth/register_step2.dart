import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'register_step3.dart';

class RegisterStep2 extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String description;
  final String regId;
  final String year;

  const RegisterStep2({
    super.key,
    required this.businessName,
    required this.businessType,
    required this.description,
    required this.regId,
    required this.year,
  });

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _formKey = GlobalKey<FormState>();

  final address = TextEditingController();
  final city = TextEditingController();
  final zip = TextEditingController();
  final state = TextEditingController();

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "businessName": widget.businessName,
        "businessType": widget.businessType,
        "description": widget.description,
        "regId": widget.regId,
        "year": widget.year,
        "address": address.text.trim(),
        "city": city.text.trim(),
        "zip": zip.text.trim(),
        "state": state.text.trim(),
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterStep3(previousData: data),
        ),
      );
    }
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Registration Step 2"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// MAP PREVIEW (Static for now)
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3FA7A3),
                          Color(0xFF1F6E6B),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// PROGRESS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("STEP 2 OF 4"),
                      Text(
                        "50% Complete",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  LinearProgressIndicator(
                    value: 0.5,
                    color: AppColors.primary,
                    backgroundColor: Colors.grey.shade300,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Where Is Your Business Located?",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Review the address fetched from the map or enter manually.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  buildField("Business Address", address),
                  buildField("City", city),
                  buildField("ZIP Code", zip),
                  buildField("State / Region", state),

                  const SizedBox(height: 30),

                  /// BUTTON ROW
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: goBack,
                          style: OutlinedButton.styleFrom(
                            minimumSize:
                                const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Back"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize:
                                const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Next Step",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        validator: (v) =>
            v == null || v.isEmpty ? "Required field" : null,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: const Color(0xFFF5F7FA),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}