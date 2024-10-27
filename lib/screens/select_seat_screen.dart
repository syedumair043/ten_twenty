import 'package:flutter/material.dart';
import 'package:book_my_seat/book_my_seat.dart';

class SeatSelectionScreen extends StatefulWidget {
  String name;
  String date;
  SeatSelectionScreen({
    super.key,
    required this.name,
    required this.date,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.square, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: widget.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '\n${widget.date}',
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Movie info section
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'March 5, 2021 | 12:30 Hall 1',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Seat selection area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Screen label
                  const Text(
                    'SCREEN',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Seats layout (example)
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10, // Number of seats in a row
                        childAspectRatio: 1.2, // Adjust this for seat size
                      ),
                      itemCount: 100, // Number of total seats
                      itemBuilder: (context, index) {
                        return Icon(
                          Icons.event_seat,
                          color: index % 10 == 0
                              ? Colors.grey // Not available
                              : index % 4 == 0
                                  ? Colors.blue // Regular seat
                                  : Colors.purple, // VIP seat
                          size: 30,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              )
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Seat Type Indicators
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.chair, color: Colors.yellow),
                        SizedBox(width: 8),
                        Text("Selected"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.chair, color: Colors.grey),
                        SizedBox(width: 8),
                        Text("Not available"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.chair, color: Colors.purple),
                        SizedBox(width: 8),
                        Text("VIP (150\$)"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.chair, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Regular (50\$)"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Price and Proceed Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 106, // Match the button width
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "\$50",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        // Proceed to payment action
                      },
                      child: const Text(
                        "Proceed to pay",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Match the container's border radius
                        ),
                        fixedSize: const Size(216, 50), // Set width and height
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
