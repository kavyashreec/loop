import 'package:flutter/material.dart';
import '../core/colors.dart';
import 'marketplace_screen.dart';
import 'add_listing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget infoCard({required Widget child}) {
    return Expanded(
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(18),
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
        child: child,
      ),
    );
  }

  Widget quickAction({
    required String title,
    required String subtitle,
    required bool primary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.business,
              color: primary ? Colors.white : AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primary ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: primary ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16,
              color: primary ? Colors.white : Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        centerTitle: true,
        title: Text(
          "LOOP",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none,
                color: Colors.black),
          )
        ],
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Welcome back, Alex",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Industrial Operations Manager • Plant A",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            /// INFO CARDS
            Row(
              children: [
                infoCard(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: CircularProgressIndicator(
                              value: 0.85,
                              strokeWidth: 8,
                              color: AppColors.primary,
                              backgroundColor:
                                  Colors.grey.shade300,
                            ),
                          ),
                          const Text(
                            "85\n/100",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "+5.2% this month",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                infoCard(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "1.2 Tons",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Equivalent to 48 trees",
                        style: TextStyle(
                            color: Colors.grey),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "+0.1T today",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight:
                                FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            quickAction(
              title: "Sell Waste",
              subtitle:
                  "Convert industrial by-products to revenue",
              primary: true,
            ),
            quickAction(
              title: "Rent Assets",
              subtitle:
                  "Lease machinery during downtime",
              primary: false,
            ),
            quickAction(
              title: "Sell Surplus",
              subtitle:
                  "List excess inventory & materials",
              primary: false,
            ),
          ],
        ),
      ),

      /// FAB (WHITE PLUS)
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddListingScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home,
                    color: AppColors.primary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.storefront,
                    color: Colors.grey),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MarketplaceScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.history,
                    color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person,
                    color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}