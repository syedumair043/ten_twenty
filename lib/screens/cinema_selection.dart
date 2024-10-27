import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CinemaSelection extends StatefulWidget {
  String name;
  String date;
  CinemaSelection({
    super.key,
    required this.name,
    required this.date,
  });

  @override
  State<CinemaSelection> createState() => _CinemaSelectionState();
}

class _CinemaSelectionState extends State<CinemaSelection> {
  List<String> dateList = [];
  int selectedChipIndex = -1;
  int? selectedIndex;
  final List<Map<String, dynamic>> events = [
    {
      'date': '12:30',
      'hallNo': 'Hall A',
      'startingPrice': 150,
      'bonus': 'Free Drinks',
      'image':
          'https://cog-home.ams3.digitaloceanspaces.com/app/uploads/2015/04/Cinema-1-Seating-Plan.jpg',
    },
    {
      'date': '13:30',
      'hallNo': 'Hall B',
      'startingPrice': 200,
      'bonus': 'Discounted Meals',
      'image':
          'https://cog-home.ams3.digitaloceanspaces.com/app/uploads/2015/04/Cinema-1-Seating-Plan.jpg',
    },
    {
      'date': '14:30',
      'hallNo': 'Hall C',
      'startingPrice': 250,
      'bonus': 'VIP Access',
      'image':
          'https://cog-home.ams3.digitaloceanspaces.com/app/uploads/2015/04/Cinema-1-Seating-Plan.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _generateDateList();
  }

  void _generateDateList() {
    DateTime today = DateTime.now();
    for (int i = 0; i <= 30; i++) {
      DateTime date = today.add(Duration(days: i));
      dateList.add(DateFormat('d MMM').format(date)); // Format date
    }
  }

  void _onChipSelected(int index) {
    setState(() {
      selectedChipIndex = index;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List<Widget>.generate(dateList.length, (int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            showCheckmark: false,
                            label: Text(dateList[index]),
                            selected: selectedChipIndex == index,
                            selectedColor: const Color(0xFF61C3F2),
                            backgroundColor: Colors.grey[300],
                            side: BorderSide.none,

                            labelStyle: TextStyle(
                              color: selectedChipIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            elevation: selectedChipIndex == index
                                ? 4.0
                                : 0.0, // Add shadow for selected chip
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              side: BorderSide.none, // Remove border
                            ),
                            onSelected: (bool selected) {
                              _onChipSelected(selected ? index : -1);
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 250,
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${event['date']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Cintech + ${event['hallNo']}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                // Second Row: Image
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedIndex == index
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Image.network(
                                      event['image'],
                                      height: 150,
                                      width: 250,
                                    ),
                                  ),
                                ),
                                // Third Row: Price and Bonus
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('From ${event['startingPrice']}'),
                                      SizedBox(width: 10),
                                      Text('or ${event['bonus']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/selectSeatScreen', extra: {
                      'name': widget.name,
                      'date': widget.date,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF61C3F2),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Get Tickets',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,

                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
