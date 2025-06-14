import 'package:flutter/material.dart';

class AboutCarZonePage extends StatelessWidget {
  final List<Map<String, String>> branches = [
    {
      'name': 'CarZone - Sheraton',
      'phone': '01024635006',
      'address': 'Sheraton Al Matar, El Nozha, Cairo Governorate 4472111',
      'google': 'https://maps.google.com/?q=Sheraton+Al+Matar,+El+Nozha,+Cairo+Governorate+4472111',
    },
    {
      'name': 'CarZone - Marghany',
      'phone': '01017660007',
      'address': 'in front of On The Run, 57 الميرغني، Al Golf, Nasr City, Cairo Governorate 11757',
      'google': 'https://maps.google.com/?q=57+%D8%A7%D9%84%D9%85%D9%8A%D8%B1%D8%BA%D9%86%D9%8A%D8%8C+Al+Golf,+Nasr+City,+Cairo+Governorate+11757',
    },
    {
      'name': 'CarZone - Elhegaz',
      'phone': '01201317095',
      'address': 'Nehro, El-Bostan, Heliopolis, Cairo Governorate 4460132',
      'google': 'https://maps.google.com/?q=Nehro,+El-Bostan,+Heliopolis,+Cairo+Governorate+4460132',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About CarZone'),
        backgroundColor: const Color(0xFF1a1a2e),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFDAA520).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Our Branches', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFDAA520))),
                  SizedBox(height: 24),
                  ...branches.map((branch) => Card(
                    color: Colors.white.withOpacity(0.07),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(branch['name']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFDAA520))),
                          SizedBox(height: 8),
                          Text('Address: ${branch['address']}', style: TextStyle(color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Phone: ${branch['phone']}', style: TextStyle(color: Colors.white)),
                          SizedBox(height: 4),
                          InkWell(
                            onTap: () {
                              // You can use url_launcher to open the link
                            },
                            child: Text(
                              'Google Maps',
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
