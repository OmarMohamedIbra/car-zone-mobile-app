import 'package:flutter/material.dart';
import '../data/api.dart';
import 'home.dart';



class CarZoneAuth extends StatelessWidget {
  const CarZoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarZone Auth',
      theme: ThemeData(primarySwatch: Colors.amber, fontFamily: 'Roboto'),
      home: AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String currentScreen = 'login';
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool agreeToTerms = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedState = '';

  final List<String> egyptianStates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Aswan',
    'Asyut',
    'Beni Suef',
    'Port Said',
    'Damietta',
    'Sharqia',
    'Gharbia',
    'Luxor',
    'Marsa Matrouh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Qalyubia',
    'Qena',
    'South Sinai',
    'Sohag',
    'Suez',
    'Fayyum',
    'Kafr el-Sheikh',
    'Ismailia',
    'North Coast',
  ];

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CarZoneHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case 'register':
        return RegisterScreen();
      case 'forgot':
        return ForgotPasswordScreen();
      default:
        return LoginScreen();
    }
  }

  Widget LoginScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111827), Color(0xFF000000), Color(0xFF1F2937)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Header
                  CarZoneLogo(size: 'large'),
                  SizedBox(height: 16),
                  Text(
                    'Sign in to explore premium cars',
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                  SizedBox(height: 32),
              
                  // Form Container
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
              
                        // Email Field
                        CustomInputField(
                          controller: emailController,
                          icon: Icons.mail_outline,
                          placeholder: 'Email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
              
                        // Password Field
                        CustomInputField(
                          controller: passwordController,
                          icon: Icons.lock_outline,
                          placeholder: 'Password',
                          isPassword: true,
                          showPassword: showPassword,
                          onTogglePassword: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
              
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                currentScreen = 'forgot';
                              });
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.amber[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
              
                        SizedBox(height: 8),
              
                        // Sign In Button
                        CustomButton(
                          text: 'Sign In',
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text;
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please enter email and password.',
                                  ),
                                ),
                              );
                              return;
                            }
                            try {
                              final success = await Api.login(
                                email,
                                password,
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login successful!')),
                                );
                                _navigateToHome();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Invalid credentials.')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Network error. Please try again.',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
              
                        SizedBox(height: 24),
              
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentScreen = 'register';
                                });
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.amber[400],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget RegisterScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111827), Color(0xFF000000), Color(0xFF1F2937)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Logo and Header
                SizedBox(height: 16),
                CarZoneLogo(),
                SizedBox(height: 8),
                Text(
                  'Join the premium car community',
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
                SizedBox(height: 24),

                // Form Container
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[800]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header with back button
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    currentScreen = 'login';
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),

                          // Name Fields
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  controller: firstNameController,
                                  icon: Icons.person_outline,
                                  placeholder: 'First Name',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: CustomInputField(
                                  controller: lastNameController,
                                  icon: Icons.person_outline,
                                  placeholder: 'Last Name',
                                ),
                              ),
                            ],
                          ),

                          // Email Field
                          CustomInputField(
                            controller: emailController,
                            icon: Icons.mail_outline,
                            placeholder: 'Email address',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          // Phone Field
                          CustomInputField(
                            controller: phoneController,
                            icon: Icons.phone_outlined,
                            placeholder: 'Phone number',
                            keyboardType: TextInputType.phone,
                          ),

                          // Address Section
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Address Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Street Address
                          CustomInputField(
                            controller: addressController,
                            icon: Icons.home_outlined,
                            placeholder: 'Street address',
                          ),

                          // State Dropdown
                          CustomDropdownField(
                            value: selectedState,
                            items: egyptianStates,
                            placeholder: 'Select your state',
                            icon: Icons.location_on_outlined,
                            onChanged: (value) {
                              setState(() {
                                selectedState = value ?? '';
                              });
                            },
                          ),

                          // Password Fields
                          CustomInputField(
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            placeholder: 'Password',
                            isPassword: true,
                            showPassword: showPassword,
                            onTogglePassword: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),

                          CustomInputField(
                            controller: confirmPasswordController,
                            icon: Icons.lock_outline,
                            placeholder: 'Confirm Password',
                            isPassword: true,
                            showPassword: showConfirmPassword,
                            onTogglePassword: () {
                              setState(() {
                                showConfirmPassword = !showConfirmPassword;
                              });
                            },
                          ),

                          // Terms Checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    agreeToTerms = value ?? false;
                                  });
                                },
                                activeColor: Colors.amber[400],
                                checkColor: Colors.black,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: TextStyle(
                                            color: Colors.amber[400],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: Colors.amber[400],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Create Account Button
                          CustomButton(
                            text: 'Create Account',
                            onPressed:
                                agreeToTerms
                                    ? () async {
                                      final email = emailController.text.trim();
                                      final password = passwordController.text;
                                      final confirmPassword =
                                          confirmPasswordController.text;
                                      final firstName =
                                          firstNameController.text.trim();
                                      final lastName =
                                          lastNameController.text.trim();
                                      final phone = phoneController.text.trim();
                                      final address =
                                          addressController.text.trim();
                                      final state = selectedState;
                                      if ([
                                        email,
                                        password,
                                        confirmPassword,
                                        firstName,
                                        lastName,
                                        phone,
                                        address,
                                        state,
                                      ].any((v) => v.isEmpty)) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please fill all fields.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      if (password != confirmPassword) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Passwords do not match.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      final success = await Api.register(
                                        email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phoneNumber: phone,
                                        address: '$address, $state',
                                      );
                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Registration successful! Please log in.',
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          currentScreen = 'login';
                                        });
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Registration failed. Please try again.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    : null,
                          ),

                          SizedBox(height: 24),

                          // Sign In Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentScreen = 'login';
                                  });
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.amber[400],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ForgotPasswordScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111827), Color(0xFF000000), Color(0xFF1F2937)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Header
                  CarZoneLogo(),
                  SizedBox(height: 16),
                  Text(
                    'Reset your password securely',
                    style: TextStyle(color: Colors.grey[300], fontSize: 16),
                  ),
                  SizedBox(height: 32),
              
                  // Form Container
                  Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(66, 66, 66, 0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: Column(
                      children: [
                        // Header with back button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  currentScreen = 'login';
                                });
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
              
                        // Mail Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.amber[500]!, Colors.amber[400]!],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.mail_outline,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 16),
              
                        Text(
                          'Enter your email address and we\'ll send you a secure link to reset your password.',
                          style: TextStyle(color: Colors.grey[300], fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
              
                        // Email Field
                        CustomInputField(
                          controller: emailController,
                          icon: Icons.mail_outline,
                          placeholder: 'Enter your email address',
                          keyboardType: TextInputType.emailAddress,
                        ),
              
                        // Send Reset Link Button
                        CustomButton(
                          text: 'Send Reset Link',
                          onPressed: () {
                            // Handle password reset
                          },
                        ),
              
                        SizedBox(height: 24),
              
                        // Back to Sign In Link
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Text(
                              'Remember your password? ',
                              style: TextStyle(color: Colors.grey[300], fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentScreen = 'login';
                                });
                              },
                              child: Text(
                                'Back to Sign In',
                                style: TextStyle(
                                  color: Colors.amber[400],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: 24),
              
                  // Security Note
                  Text(
                    '🔐 Your security is our priority. The reset link will expire in 15 minutes.',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    textAlign: TextAlign.center,
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

class CarZoneLogo extends StatelessWidget {
  final String size;

  const CarZoneLogo({Key? key, this.size = 'normal'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double logoSize = size == 'large' ? 80 : 60;
    double textSize = size == 'large' ? 28 : 24;

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize * 0.6,
          child: CustomPaint(painter: CarLogoPainter()),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'CAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'ZONE',
                style: TextStyle(
                  color: Colors.amber[400],
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.amber[500]!,
              Colors.amber[300]!,
              Colors.amber[500]!,
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.3,
      size.height * 0.5,
    );
    path.lineTo(size.width * 0.7, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.5,
      size.width * 0.85,
      size.height * 0.7,
    );
    path.lineTo(size.width * 0.85, size.height * 0.8);
    path.lineTo(size.width * 0.15, size.height * 0.8);
    path.close();

    canvas.drawPath(path, paint);

    // Draw car roof
    final roofPath = Path();
    roofPath.moveTo(size.width * 0.1, size.height * 0.6);
    roofPath.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.3,
      size.width * 0.25,
      size.height * 0.3,
    );
    roofPath.lineTo(size.width * 0.75, size.height * 0.3);
    roofPath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.3,
      size.width * 0.9,
      size.height * 0.6,
    );

    canvas.drawPath(
      roofPath,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String placeholder;
  final bool isPassword;
  final bool showPassword;
  final VoidCallback? onTogglePassword;
  final TextInputType keyboardType;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.placeholder,
    this.isPassword = false,
    this.showPassword = false,
    this.onTogglePassword,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !showPassword,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          suffixIcon:
              isPassword
                  ? IconButton(
                    onPressed: onTogglePassword,
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[400],
                    ),
                  )
                  : null,
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[400]!, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final String placeholder;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.placeholder,
    required this.icon,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        items:
            items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.amber[400]!, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: Colors.grey[800],
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomButton({Key? key, required this.text, this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  onPressed != null
                      ? [Colors.amber[500]!, Colors.amber[400]!]
                      : [Colors.grey[600]!, Colors.grey[500]!],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
