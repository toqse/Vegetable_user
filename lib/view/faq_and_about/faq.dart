import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Map<String, String>> faqList = [
    {
      'question': 'How do I place an order on Easy Cooking?',
      'answer':
          'To place an order, simply download the Easy Cooking app, browse through our wide selection of products, add items to your cart, and proceed to checkout. Enter your delivery details, and confirm your order.'
    },
    {
      'question': 'What areas do you deliver to?',
      'answer':
          'We currently deliver to selected locations. If the ordered place delivery is not available,the product will not accepted.It will shown in "1: Processing Orders,2: Ready for Delivery,3: Delivered History" in Profile',
    },
    {
      'question': 'Are the products fresh and hygienically packed?',
      'answer':
          'Absolutely! We prioritize quality and hygiene. All products are carefully sourced, thoroughly checked, and packed under strict quality standards to ensure you receive fresh and safe ingredients.'
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We offer cash on delivery options for your convenience.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Toqsekart FAQ',
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item['question']!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item['answer']!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.6,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
