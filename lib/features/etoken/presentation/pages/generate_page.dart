import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/etoken_bloc.dart';
import '../bloc/etoken_event.dart';
import '../bloc/etoken_state.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  final _passwordController = TextEditingController();
  Timer? _timer;
  int _countdown = 30;

  @override
  void dispose() {
    _timer?.cancel();
    _passwordController.dispose();
    super.dispose();
  }

  void _startGenerator(String password) {
    _timer?.cancel();
    _generateCode(password); // initial call
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        _generateCode(password);
        setState(() {
          _countdown = 30;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _generateCode(String password) {
    context.read<ETokenBloc>().add(GenerateETokenEvent(password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate eToken Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter 6-digit eToken Password',
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
                  _countdown = 30;
                  _startGenerator(password);
                }
              },
              child: const Text('Start Generating'),
            ),
            const SizedBox(height: 32),
            BlocConsumer<ETokenBloc, ETokenState>(
              listener: (context, state) {
                if (state is ETokenError) {
                  _timer?.cancel();
                  setState(() {
                    _countdown = 30;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ETokenLoading) {
                  return const CircularProgressIndicator();
                } else if (state is ETokenGenerateSuccess) {
                  return Column(
                    children: [
                      Text(
                        state.tokenCode,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Refreshes in $_countdown seconds',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _countdown / 30,
                      )
                    ],
                  );
                } else if (state is ETokenError) {
                  return Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('Enter password to generate code');
              },
            ),
          ],
        ),
      ),
    );
  }
}
