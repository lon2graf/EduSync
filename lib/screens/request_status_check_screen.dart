import 'package:edu_sync/models/using_request_model.dart';
import 'package:edu_sync/services/education_head_servives.dart';
import 'package:flutter/material.dart';
import 'package:edu_sync/services/local_storage_preferences.dart';
import 'package:edu_sync/services/using_request_services.dart';
import 'package:go_router/go_router.dart';

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
  UsingRequestModel? _request;

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

    final request = await UsingRequestServices.getRequestByEmail(email);

    if (request == null) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❗ Заявка не найдена. Проверьте корректность email.';
      });
      return;
    }

    final accountExists = await EducationHeadServives.isAccountExistByEmail(
      email,
    );

    setState(() {
      _isLoading = false;
      _request = request;

      if (request.isAccepted == true) {
        _statusMessage =
            accountExists
                ? '✅ Ваша заявка одобрена.\nУчётная запись уже существует.\nВойдите в личный кабинет руководителя.'
                : '✅ Ваша заявка одобрена.\nВы можете зарегистрироваться как руководитель учебной части.';
      } else if (request.isAccepted == false) {
        _statusMessage = '⏳ Ваша заявка в обработке. Попробуйте позже.';
      } else {
        _statusMessage =
            '❗ Не удалось получить статус заявки.\nПроверьте корректность email.';
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
      appBar: AppBar(title: const Text("Статус заявки"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_done,
                          size: 80,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Проверка статуса заявки',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        if (_statusMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Text(
                              _statusMessage!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        if (_statusMessage ==
                            '✅ Ваша заявка одобрена.\nВы можете зарегистрироваться как руководитель учебной части.')
                          Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.go(
                                    '/register_education_head',
                                    extra: _request,
                                  );
                                },
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  'Перейти к регистрации',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        if (emailController.text.isEmpty)
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 320, // фиксированная ширина для читаемости
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Введите email',
                                        border: OutlineInputBorder(),
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
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
