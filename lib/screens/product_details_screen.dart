import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double? lat =
        product["lat"] != null ? (product["lat"] as num).toDouble() : null;
    final double? lng =
        product["lng"] != null ? (product["lng"] as num).toDouble() : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero image ────────────────────────────────────────────
                _HeroImage(product: product),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge + ID
                      Row(
                        children: [
                          _Badge(
                            label: product["category"] ?? "Industrial Logistics",
                            color: const Color(0xFF1C5F20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "ID: LOOP-${product.hashCode.abs().toString().substring(0, 6)}",
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF888888)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Title
                      Text(
                        product["title"] ?? "Listing",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.3),
                      ),

                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: Color(0xFF555555)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              product["location"] ??
                                  "Location not specified",
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF555555)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Specs grid ─────────────────────────────────────
                      Row(
                        children: [
                          _SpecBox(
                              label: "Condition",
                              value:
                                  product["condition"] ?? "Grade A"),
                          const SizedBox(width: 10),
                          _SpecBox(
                              label: "Year Made",
                              value: product["yearMade"] ?? "2024"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _SpecBox(
                              label: "Material",
                              value: product["material"] ??
                                  "Corten Steel"),
                          const SizedBox(width: 10),
                          _SpecBox(
                              label: "Category",
                              value: product["category"] ?? "—"),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Product Description ────────────────────────────
                      const _SectionTitle("Product Description"),
                      const SizedBox(height: 8),
                      Text(
                        product["description"] ??
                            "No description provided.",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF444444),
                            height: 1.6),
                      ),

                      const SizedBox(height: 24),

                      // ── Technical Specifications ───────────────────────
                      const _SectionTitle("Technical Specifications"),
                      const SizedBox(height: 10),
                      _specsTable(product),

                      const SizedBox(height: 24),

                      // ── Location map ───────────────────────────────────
                      const _SectionTitle("Location"),
                      const SizedBox(height: 10),
                      if (lat != null && lng != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            height: 180,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, lng),
                                  zoom: 14),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("loc"),
                                  position: LatLng(lat, lng),
                                  icon: BitmapDescriptor
                                      .defaultMarkerWithHue(
                                          BitmapDescriptor.hueGreen),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                            ),
                          ),
                        )
                      else
                        _MapPlaceholder(product: product),

                      const SizedBox(height: 6),
                      Text(
                        product["location"] ??
                            "Location not specified",
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF777777)),
                      ),

                      const SizedBox(height: 24),

                      // ── Price ──────────────────────────────────────────
                      const _SectionTitle("Price"),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹ ${product["price"] ?? "0"}",
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A)),
                          ),
                          const SizedBox(width: 6),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text("excl. VAT",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF888888))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text("Available for immediate delivery",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500)),

                      const SizedBox(height: 20),

                      // ── Action buttons ─────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1C5F20),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.shopping_cart_outlined,
                              size: 18, color: Colors.white),
                          label: const Text("Buy Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          onPressed: () {},
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFF1C5F20), width: 1.5),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF1C5F20)),
                          label: Text(
                            "Rent for ₹${_rentPrice(product["price"])}/mo",
                            style: const TextStyle(
                                color: Color(0xFF1C5F20),
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          onPressed: () {},
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFF0F0F0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline,
                              size: 16,
                              color: Color(0xFF1A1A1A)),
                          label: const Text("Inquire Now",
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontWeight: FontWeight.w600)),
                          onPressed: () {},
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Seller card ────────────────────────────────────
                      _SellerCard(product: product),

                      const SizedBox(height: 16),

                      // ── Purchase protection ────────────────────────────
                      _PurchaseProtection(),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          "© ${DateTime.now().year} LOOP Industrial Marketplace. All rights reserved.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFAAAAAA)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Transparent AppBar overlay ──────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleBtn(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context)),
                    Row(
                      children: [
                        _CircleBtn(icon: Icons.share_outlined),
                        const SizedBox(width: 8),
                        _CircleBtn(
                            icon: Icons.bookmark_outline),
                      ],
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

  Widget _specsTable(Map<String, dynamic> p) {
    final rows = [
      ["External Length", p["length"] ?? "12,192 mm"],
      ["Internal Height", p["height"] ?? "2,698 mm"],
      ["Tare Weight", p["tareWeight"] ?? "3,900 kg"],
      ["Max Payload", p["maxPayload"] ?? "28,600 kg"],
      ["Floor Type", p["floorType"] ?? "Marine Plywood"],
      ["Locking Rods", p["lockingRods"] ?? "4x Heavy Duty"],
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final i = e.key;
          final row = e.value;
          return Container(
            decoration: BoxDecoration(
              border: i < rows.length - 1
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)))
                  : null,
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(row[0],
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888888))),
                ),
                Expanded(
                  flex: 5,
                  child: Text(row[1],
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A))),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _rentPrice(dynamic price) {
    try {
      final p = double.parse(price.toString());
      return (p * 0.01).toStringAsFixed(0);
    } catch (_) {
      return "43";
    }
  }
}

// ─── Hero Image ─────────────────────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final Map<String, dynamic> product;
  const _HeroImage({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product["image"] as String? ?? "";
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageUrl.isNotEmpty && imageUrl.startsWith("http")
              ? Image.network(imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder(),
          // Dark gradient at top for appbar
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Colors.black38, Colors.transparent],
              ),
            ),
          ),
          // AVAILABLE badge
          const Positioned(
            top: 56,
            left: 16,
            child: _Badge(
              label: "AVAILABLE",
              color: Color(0xFF2E7D32),
              icon: Icons.check_circle_outline,
            ),
          ),
          // Photo count
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.photo_library_outlined,
                      size: 13, color: Colors.white),
                  SizedBox(width: 4),
                  Text("1/1 Photos",
                      style: TextStyle(
                          color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFB0BEC5),
        child: const Center(
          child: Icon(Icons.inventory_2_outlined,
              size: 60, color: Colors.white54),
        ),
      );
}

// ─── Badge ──────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const _Badge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3)),
        ],
      ),
    );
  }
}

// ─── Spec box ────────────────────────────────────────────────────────────────
class _SpecBox extends StatelessWidget {
  final String label;
  final String value;
  const _SpecBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF888888))),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A))),
          ],
        ),
      ),
    );
  }
}

// ─── Section title ───────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A)));
}

// ─── Circle button ───────────────────────────────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CircleBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1A1A1A)),
      ),
    );
  }
}

// ─── Map placeholder (when no lat/lng) ──────────────────────────────────────
class _MapPlaceholder extends StatelessWidget {
  final Map<String, dynamic> product;
  const _MapPlaceholder({required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 140,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF93C9A3), Color(0xFF3D8B5E)],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, 140),
              painter: _GridPainter(),
            ),
            const Center(
                child: Icon(Icons.location_pin,
                    color: Color(0xFF1C5F20), size: 40)),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Seller card ─────────────────────────────────────────────────────────────
class _SellerCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const _SellerCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF1C5F20),
                child: Text(
                  (product["sellerName"] ?? "E")[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["sellerName"] ?? "EuroTrade Logistics",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < 4
                              ? Icons.star_rounded
                              : Icons.star_half_rounded,
                          size: 14,
                          color: const Color(0xFFFFC107),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text("4.8 · 314 reviews",
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF888888))),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),
          _verifiedRow(Icons.verified_outlined, "Verified Business Centre"),
          const SizedBox(height: 8),
          _verifiedRow(Icons.shield_outlined, "Trusted Seller — 5 years"),
        ],
      ),
    );
  }

  Widget _verifiedRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1C5F20)),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF444444))),
      ],
    );
  }
}

// ─── Purchase protection ──────────────────────────────────────────────────────
class _PurchaseProtection extends StatelessWidget {
  const _PurchaseProtection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB8D8B8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF1C5F20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.security,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("LOOP PURCHASE PROTECTION",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1C5F20),
                        letterSpacing: 0.4)),
                SizedBox(height: 4),
                Text(
                  "Funds are held in escrow until delivery is confirmed and inspection is complete.",
                  style: TextStyle(
                      fontSize: 12, color: Color(0xFF444444)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}