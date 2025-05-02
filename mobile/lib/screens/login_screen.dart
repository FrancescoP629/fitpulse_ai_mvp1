// /home/ubuntu/fitpulse_ai/mobile/lib/screens/login_screen.dart

import 'package:flutter/material.dart';
// Import the API service (to be created)
// import '../services/api_service.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // API service instance (to be implemented)
  // final ApiService _apiService = ApiService();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // --- Mock Login Logic --- 
        // Simulate an API call
        await Future.delayed(const Duration(seconds: 1)); 
        final email = _emailController.text;
        final password = _passwordController.text;

        // Mock check (in a real app, call _apiService.login(email, password))
        if (email == "test@example.com" && password == "password") {
          // Navigate to home screen after successful login
          if (mounted) { // Check if the widget is still mounted
             Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          setState(() {
            _errorMessage = "Invalid credentials."; // Translated
          });
        }
        // --- End Mock Logic ---

        /* --- Real API Logic (uncomment after creating ApiService) ---
        final success = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (mounted) {
          setState(() {
            _errorMessage = _apiService.lastError ?? "Unknown login error."; // Translated
          });
        }
        */
      } catch (e) {
         if (mounted) {
            setState(() {
              _errorMessage = "An error occurred: ${e.toString()}"; // Translated
            });
         }
      } finally {
        if (mounted) {
            setState(() {
              _isLoading = false;
            });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitPulse AI - Login'), // Translated
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Log in to your account', // Translated
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email', // Translated
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address'; // Translated
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password', // Translated
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password'; // Translated
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: _login,
                        child: const Text('Login'), // Translated
                      ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Logic for registration (navigate to a signup screen)
                    // For now, just show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup functionality not yet implemented.')), // Translated
                    );
                  },
                  child: const Text('Don\'t have an account? Sign up'), // Translated
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

