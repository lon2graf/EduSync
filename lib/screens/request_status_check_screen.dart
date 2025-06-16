import 'package:flutter/material.dart';
import 'package:edu_sync/services/local_storage_preferences.dart';
import 'package:edu_sync/services/using_request_services.dart';

class RequestStatusCheckScreen extends StatefulWidget {
  const RequestStatusCheckScreen({Key? key});

  @override
  _RequestStatusCheckScreen createState() => _RequestStatusCheckScreen();
}

class _RequestStatusCheckScreen extends State<RequestStatusCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  //для того, чтобы блокировать кнопку
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _checkSavedEmail();
  }

  //автоматическое получение email, если пользователь уже раннее отправлял заявку, на этом же устройстве
  Future<void> _checkSavedEmail() async {
    final savedEmail = await LocalStorageService.getSendersEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      emailController.text = savedEmail;
      _checkStatus(savedEmail);
    }
  }

  //метод для получения статуса заявки с использованием
  //static UsingRequestServices.getRequestStatusByEmail()
  Future<void> _checkStatus(String email) async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final isAccepted = await UsingRequestServices.getRequestStatusByEmail(
      email,
    );

    setState(() {
      _isLoading = false;

      if (isAccepted == true) {
        _statusMessage = '✅ Ваша заявка одобрена!';
      } else if (isAccepted == false) {
        _statusMessage = '⏳ Заявка ещё в обработке.';
      } else {
        _statusMessage = '❗ Не удалось получить статус заявки.';
      }
    });
  }

  void _submitManual() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      _checkStatus(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Статус заявки")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    if (_statusMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _statusMessage!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (emailController.text.isEmpty)
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Введите email',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email обязателен';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _submitManual,
                              child: const Text("Проверить статус"),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}
