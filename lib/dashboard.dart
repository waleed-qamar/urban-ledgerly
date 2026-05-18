import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/logos/logo1.jpeg',
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 5,
                              clipBehavior: Clip.antiAlias,
                              color: Colors.black,
                              child: Image.asset(
                                'assets/logos/logo2.png',
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Card(
                              elevation: 5,
                              clipBehavior: Clip.antiAlias,
                              color: Colors.black,
                              child: Image.asset(
                                'assets/logos/logo3.png',
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
