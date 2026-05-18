import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms & Privacy'), backgroundColor: AppTheme.error),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        campus: 'UR Huye Campus',
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.onPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text("Let's", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.onPrimary)),
                Text('Create Your\nAccount',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        )),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Name is required';
                        if (v.length < 3) return 'Name must be at least 3 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Retype Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppTheme.primary,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to the ',
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: const [
                                  TextSpan(
                                    text: 'Terms & Privacy',
                                    style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Have an account? '),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Sign In',
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
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
    );
  }
}