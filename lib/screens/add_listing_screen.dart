import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../core/colors.dart';
import 'product_details_screen.dart';
import 'home_screen.dart';
import 'marketplace_screen.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  // ─── Controllers ────────────────────────────────────────────────────────
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  // ─── State ──────────────────────────────────────────────────────────────
  String _category = "Waste";
  String _condition = "Excellent";
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  LatLng _pin = const LatLng(12.9716, 77.5946);
  GoogleMapController? _mapCtrl;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  // ─── Location ───────────────────────────────────────────────────────────
  Future<void> _fetchLocation() async {
    setState(() => _locating = true);
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        setState(() => _locating = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final latlng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _pin = latlng;
        _locating = false;
      });
      _mapCtrl?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: latlng, zoom: 15)));
    } catch (_) {
      setState(() => _locating = false);
    }
  }

  // ─── Image picker ────────────────────────────────────────────────────────
  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4)),
            ),
            ListTile(
              leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary)),
              title: const Text("Take a Photo",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text("Open camera"),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.photo_library_rounded,
                      color: AppColors.primary)),
              title: const Text("Choose from Gallery",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text("Pick existing photo"),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource src) async {
    try {
      final img = await _picker.pickImage(
          source: src, imageQuality: 80, maxWidth: 1200);
      if (img != null && _images.length < 10) {
        setState(() => _images.add(img));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _removeImage(int i) => setState(() => _images.removeAt(i));

  // ─── Publish ─────────────────────────────────────────────────────────────
  Future<void> _publish() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter an item name")));
      return;
    }
    final data = <String, dynamic>{
      "title": _nameCtrl.text.trim(),
      "description": _descCtrl.text.trim(),
      "price": _priceCtrl.text.trim(),
      "category": _category,
      "condition": _condition,
      "location": _locationCtrl.text.trim(),
      "lat": _pin.latitude,
      "lng": _pin.longitude,
      "image": _images.isNotEmpty ? _images.first.path : "",
      "createdAt": Timestamp.now(),
    };
    await FirebaseFirestore.instance.collection("products").add(data);
    if (!mounted) return;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: data)));
  }

  // ─── Widgets ─────────────────────────────────────────────────────────────
  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1A1A1A))),
      );

  InputDecoration _dec(String hint, {Widget? prefix, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5)),
      );

  Widget _catChip(String label) {
    final sel = _category == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _category = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          decoration: BoxDecoration(
            color: sel ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: sel ? AppColors.primary : Colors.grey.shade300,
                width: 1.2),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: sel ? Colors.white : const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
          ),
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: const Icon(Icons.close, color: Color(0xFF1A1A1A), size: 22),
          ),
        ),
        centerTitle: true,
        title: const Text("Create Listing",
            style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontWeight: FontWeight.w700,
                fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Save Draft",
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),

      // ── Bottom Nav ──────────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomNav(context),

      body: Column(
        children: [
          // ── Step dots ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: i == 0
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),

          // ── Scrollable body ───────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              children: [

                // ── Upload Photos ────────────────────────────────────────
                _label("Upload Photos"),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Add button
                      if (_images.length < 10)
                        GestureDetector(
                          onTap: _showPickerSheet,
                          child: Container(
                            width: 90, height: 90,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                  style: BorderStyle.solid),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt_outlined,
                                      color: AppColors.primary, size: 22),
                                ),
                                const SizedBox(height: 6),
                                const Text("Add Photo",
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),

                      // Thumbnails
                      ..._images.asMap().entries.map((e) {
                        final i = e.key;
                        final img = e.value;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 90, height: 90,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(File(img.path)),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6, offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                            // Remove × button
                            Positioned(
                              top: -6, right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(i),
                                child: Container(
                                  width: 22, height: 22,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF1A1A1A),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close,
                                      size: 13, color: Colors.white),
                                ),
                              ),
                            ),
                            // Cover badge
                            if (i == 0)
                              Positioned(
                                bottom: 6, left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text("Cover",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text("Up to 10 photos. First one is your cover image.",
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12)),

                const SizedBox(height: 22),

                // ── Item Name ────────────────────────────────────────────
                _label("Item Name"),
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(fontSize: 15),
                  decoration:
                      _dec("e.g. Reclaimed Timber Planks"),
                ),

                const SizedBox(height: 20),

                // ── Category ─────────────────────────────────────────────
                _label("Category"),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    _catChip("Waste"),
                    const SizedBox(width: 4),
                    _catChip("Asset"),
                    const SizedBox(width: 4),
                    _catChip("Surplus"),
                  ]),
                ),

                const SizedBox(height: 20),

                // ── Description ──────────────────────────────────────────
                _label("Description"),
                TextField(
                  controller: _descCtrl,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 15),
                  decoration: _dec(
                    "Describe the material's origin, dimensions, and potential uses...",
                  ),
                ),

                const SizedBox(height: 20),

                // ── Condition + Price ─────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Condition
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Condition"),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade200),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _condition,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more,
                                    size: 20,
                                    color: Color(0xFF555555)),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF1A1A1A)),
                                items: ["Excellent","Good","Fair","Poor"]
                                    .map((c) => DropdownMenuItem(
                                        value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _condition = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Price / Rate"),
                          TextField(
                            controller: _priceCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.fromLTRB(
                                    14, 0, 4, 0),
                                child: Text("₹ ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1A1A)),
                                    textAlign: TextAlign.center),
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 0),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade200)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade200)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Pickup Location ───────────────────────────────────────
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Pickup Location",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1A1A1A))),
                    GestureDetector(
                      onTap: _locating ? null : _fetchLocation,
                      child: Row(
                        children: [
                          if (_locating)
                            const SizedBox(
                              width: 12, height: 12,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary),
                            )
                          else
                            const Icon(Icons.my_location,
                                size: 14,
                                color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            _locating
                                ? "Locating..."
                                : "Use my location",
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _locationCtrl,
                  style: const TextStyle(fontSize: 15),
                  decoration: _dec(
                    "Enter address or city",
                    prefix: const Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Google Map ────────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _pin, zoom: 15),
                          onMapCreated: (c) {
                            _mapCtrl = c;
                            c.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: _pin, zoom: 15)));
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId("pin"),
                              position: _pin,
                              icon:
                                  BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueGreen),
                            ),
                          },
                          onTap: (ll) =>
                              setState(() => _pin = ll),
                          zoomControlsEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                        ),
                      ),
                      if (_locating)
                        const Positioned.fill(
                          child: ColoredBox(
                            color: Colors.black12,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text("Tap the map to set exact pickup point.",
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12)),
                ),

                const SizedBox(height: 28),

                // ── Publish button ────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _publish,
                    child: const Text("Publish Listing",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2)),
                  ),
                ),

                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "By listing, you agree to the LOOP Marketplace Terms of Service\nregarding circular economy standards.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(ctx, Icons.home_outlined, "Home", false,
                  () => Navigator.pushReplacement(ctx,
                      MaterialPageRoute(
                          builder: (_) => const HomeScreen()))),
              _navItem(ctx, Icons.storefront_outlined, "Marketplace",
                  false,
                  () => Navigator.pushReplacement(ctx,
                      MaterialPageRoute(
                          builder: (_) =>
                              const MarketplaceScreen()))),
              _navItemAdd(ctx),
              _navItem(
                  ctx, Icons.swap_horiz, "Transactions", false, () {}),
              _navItem(ctx, Icons.person_outline, "Profile", false,
                  () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext ctx, IconData icon, String label,
      bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 24,
              color: active
                  ? AppColors.primary
                  : Colors.grey.shade500),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: active
                      ? AppColors.primary
                      : Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _navItemAdd(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40, height: 40,
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 2),
        const Text("Add",
            style: TextStyle(
                fontSize: 10, color: AppColors.primary,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}