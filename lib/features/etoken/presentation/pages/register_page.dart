import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/etoken_bloc.dart';
import '../bloc/etoken_event.dart';
import '../bloc/etoken_state.dart';
import 'generate_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _passwordController = TextEditingController();

  Future<void> _submitRegistration(String password) async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown Device';
    String deviceId = 'unknown_id';
    String deviceType = Platform.operatingSystem;

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_id';
      }
    } catch (e) {
      debugPrint('Lỗi lấy device info: $e');
    }

    if (!mounted) return;

    context.read<ETokenBloc>().add(
          RegisterETokenEvent(
            password: password,
            deviceName: deviceName,
            deviceId: deviceId,
            deviceType: deviceType,
            accountName: 'John Doe', // Thường lấy từ token user đăng nhập
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register eToken')),
      body: BlocConsumer<ETokenBloc, ETokenState>(
        listener: (context, state) {
          if (state is ETokenRegisterSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GeneratePage(),
              ),
            );
          } else if (state is ETokenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ETokenLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '6-digit eToken Password',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final password = _passwordController.text;
                    if (password.length == 6) {
                      _submitRegistration(password);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password must be 6 digits')),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
