import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/auth_service.dart';
import 'login_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const Color primaryGreen = Color(0xFF3BA66B);
  static const Color inputBg = Color(0xFFF9FAFB);

  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: inputBg,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // TITLE
                Center(
                  child: Text(
                    'Tạo tài khoản mới',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // EMAIL
                Text('Địa chỉ email', style: _labelStyle()),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('emailField'),
                  controller: _emailController,
                  decoration: _inputDecoration('Nhập email của bạn'),
                  validator: _validateEmail,
                ),

                const SizedBox(height: 20),

                // USERNAME
                Text('Tên người dùng', style: _labelStyle()),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Nhập tên người dùng'),
                ),

                const SizedBox(height: 20),

                // PASSWORD
                Text('Mật khẩu', style: _labelStyle()),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    'Nhập mật khẩu',
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 8) {
                      return 'Mật khẩu tối thiểu 8 ký tự';
                    }

                    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
                    final hasDigit = RegExp(r'\d').hasMatch(value);
                    if (!hasLetter || !hasDigit) {
                      return 'Mật khẩu phải có ít nhất 1 chữ cái và 1 chữ số';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // CONFIRM PASSWORD
                Text('Xác nhận mật khẩu', style: _labelStyle()),
                const SizedBox(height: 8),
                TextFormField(
                  key: const Key('confirmPasswordField'),
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: _inputDecoration(
                    'Nhập lại mật khẩu',
                    suffix: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 24),

                // DIVIDER
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'hoặc',
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // GOOGLE
                _socialButton(
                  icon: Icons.g_mobiledata,
                  text: 'Tiếp tục với Google',
                ),

                const SizedBox(height: 12),

                // FACEBOOK
                _socialButton(
                  icon: Icons.facebook,
                  iconColor: Colors.blue,
                  text: 'Tiếp tục với Facebook',
                ),

                const SizedBox(height: 24),

                // SIGN UP BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('signupButton'),
                    onPressed: _isLoading ? null : () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => _isLoading = true);

                      try {
                        await _authService.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      padding:
                      const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Đăng ký',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // LOGIN LINK
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Đã có tài khoản? ',
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Đăng nhập ngay',
                          style: GoogleFonts.inter(
                            color: primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // TERMS
                Center(
                  child: Text(
                    'Bằng việc đăng ký, bạn đồng ý với '
                        'Điều khoản Dịch vụ và Chính sách Bảo mật của chúng tôi.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập email';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) return 'Địa chỉ email không hợp lệ';
    return null;
  }

  // Password validator was inlined in the password field's `validator` closure.

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    if (value != _passwordController.text) return 'Mật khẩu không khớp';
    return null;
  }

  TextStyle _labelStyle() {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: iconColor ?? Colors.black),
        label: Text(
          text,
          style: GoogleFonts.inter(fontSize: 15),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
