import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
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
                  Text('Feedback', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFDAA520))),
                  SizedBox(height: 24),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Color(0xFFDAA520)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFFDAA520)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: 5,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Your Feedback',
                      labelStyle: TextStyle(color: Color(0xFFDAA520)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFFDAA520).withOpacity(0.3)),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDAA520),
                        foregroundColor: Color(0xFF1a1a2e),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text('Send', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
