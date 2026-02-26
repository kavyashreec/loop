import 'package:flutter/material.dart';
import '../core/colors.dart';

class HomeScreen extends StatelessWidget {

  Widget infoCard({
    required String title,
    required Widget child,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
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
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.business,
              color: primary ? Colors.white : AppColors.primary),
          SizedBox(width: 16),
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
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: primary
                        ? Colors.white70
                        : Colors.grey,
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
        leading: Icon(Icons.menu, color: Colors.black),
        centerTitle: true,
        title: Text(
          "LOOP",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              Icon(Icons.notifications_none,
                  color: Colors.black),
              Positioned(
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 16),
        ],
      ),

      /// BODY
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [

            /// WELCOME
            Text(
              "Welcome back, Alex",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "Industrial Operations Manager • Plant A",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 24),

            /// TWO CARDS
            Row(
              children: [

                infoCard(
                  title: "Circular Score",
                  child: Column(
                    children: [
                      SizedBox(height: 10),
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
                          Text(
                            "85\n/100",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "+5.2% this month",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                SizedBox(width: 16),

                infoCard(
                  title: "CO2 Saved",
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1.2 Tons",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Equivalent to 48 trees",
                        style:
                            TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "+0.1T today",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            /// QUICK ACTIONS
            Text(
              "Quick Actions",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

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

            SizedBox(height: 20),

            /// RECENT ACTIVITY
            Text(
              "Recent Activity",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping,
                      color: AppColors.primary),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Waste Collection Scheduled",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold),
                        ),
                        Text(
                          "Order #8821 • Aluminum Scrap",
                          style: TextStyle(
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text("2h ago",
                      style:
                          TextStyle(color: Colors.grey))
                ],
              ),
            ),
          ],
        ),
      ),

      /// FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      /// BOTTOM NAV
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
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
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.storefront),
                  onPressed: () {}),
              SizedBox(width: 40),
              IconButton(
                  icon: Icon(Icons.receipt_long),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}