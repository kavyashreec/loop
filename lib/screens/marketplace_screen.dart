import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/colors.dart';
import 'home_screen.dart';
import 'add_listing_screen.dart';
import 'product_details_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() =>
      _MarketplaceScreenState();
}

class _MarketplaceScreenState
    extends State<MarketplaceScreen> {
  String selectedCategory = "All";

  /// CATEGORY CHIP
  Widget categoryChip(String label) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        margin:
            const EdgeInsets.only(right: 12),
        padding:
            const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.grey.shade200,
          borderRadius:
              BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// FIRESTORE ITEM CARD
  Widget itemCardFromFirestore(
      Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["title"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item["description"] ?? "",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${item["price"]}",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: item["category"] == "Waste"
                          ? Colors.green
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item["category"].toString().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBackground,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(
            Icons.menu,
            color: Colors.black),
        centerTitle: true,
        title: Text(
          "LOOP",
          style: TextStyle(
              color:
                  AppColors.primary,
              fontWeight:
                  FontWeight.bold),
        ),
      ),

      /// BODY
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            /// CATEGORY CHIPS
            Row(
              children: [
                categoryChip("All"),
                categoryChip("Waste"),
                categoryChip("Assets"),
              ],
            ),

            const SizedBox(height: 20),

            /// FIRESTORE LIST
            Expanded(
              child: StreamBuilder<
                  QuerySnapshot>(
                stream:
                    FirebaseFirestore
                        .instance
                        .collection(
                            "products")
                        .snapshots(),
                builder:
                    (context,
                        snapshot) {
                  if (!snapshot
                      .hasData) {
                    return const Center(
                        child:
                            CircularProgressIndicator());
                  }

                  var docs = snapshot
                      .data!.docs;

                  /// FILTER CATEGORY
                  if (selectedCategory !=
                      "All") {
                    docs = docs
                        .where((doc) =>
                            doc["category"] ==
                            selectedCategory)
                        .toList();
                  }

                  if (docs.isEmpty) {
                    return const Center(
                        child: Text(
                            "No products found"));
                  }

                  return ListView(
                    children: docs
                        .map((doc) =>
                            itemCardFromFirestore(
                                doc.data()
                                    as Map<
                                        String,
                                        dynamic>))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// FAB
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddListingScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerDocked,

      /// FOOTER
      bottomNavigationBar:
          BottomAppBar(
        shape:
            const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding:
              const EdgeInsets
                  .symmetric(
                      horizontal: 20),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                    Icons.home,
                    color:
                        Colors.grey),
                onPressed: () {
                  Navigator
                      .pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const HomeScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.storefront,
                    color:
                        AppColors.primary),
                onPressed: () {},
              ),
              const SizedBox(
                  width: 40),
              IconButton(
                icon: const Icon(
                    Icons.history,
                    color:
                        Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                    Icons.person,
                    color:
                        Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}