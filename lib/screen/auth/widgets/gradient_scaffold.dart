import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final IconData logoIcon;
  final String title;
  final String subtitle;

  const GradientScaffold({super.key, required this.child, required this.logoIcon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // mulainya
            end: Alignment.bottomCenter, // akhirnya
            colors: [
              Colors.blue[700]!,
              Colors.blue[500]!,
              Colors.blue[300]!,
            ]
          )
        ),
        child: SafeArea( // safearea = supaya ga menumpuk
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // maina = mengikuti sumbu utama (atas - bawah)
                crossAxisAlignment: CrossAxisAlignment.stretch, // crossa = mengikuti sumbu silang (kanan - kiri)
                children: [
                  _buildLogo(),
                  SizedBox(height: 32),
                  _buildTitle(),
                  SizedBox(height: 8),
                  _buildSubtitle(),
                  SizedBox(height: 48),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2), // sumbu x horizontal, sumbu y vertikal
          )
        ]
      ),
      child: Icon(
        logoIcon,
        size: 60,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    );
  }
}