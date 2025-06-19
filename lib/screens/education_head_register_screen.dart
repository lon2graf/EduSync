import 'package:edu_sync/models/using_request_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/services/institution_services.dart';
import 'package:edu_sync/models/institution_model.dart';
import 'package:edu_sync/models/education_head_model.dart';
import 'package:edu_sync/services/education_head_servives.dart';
import 'package:edu_sync/services/local_storage_preferences.dart';

class EducationHeadRegisterScreen extends StatefulWidget {
  const EducationHeadRegisterScreen({Key? key});

  @override
  _EducationHeadRegisterScreen createState() => _EducationHeadRegisterScreen();
}

class _EducationHeadRegisterScreen extends State<EducationHeadRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isRegistered = false;

  Future<void> _register(UsingRequestModel request) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final institution = InstitutionModel(
        name: request.institutionName,
        address: request.address,
      );

      final institutionId = await InstitutionService.createInstitutionAndGetId(
        institution,
      );

      if (institutionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при создании учреждения')),
        );
        setState(() => _isLoading = false);
        return;
      }

      final educationHead = EducationHeadModel(
        password: passwordController.text.trim(),
        institutionId: institutionId,
        email: request.email,
        surname: request.surname,
        name: request.name,
        patronymic: request.patronymic,
      );

      final success = await EducationHeadServives.registerEducationHead(
        educationHead,
      );

      if (success) {
        await LocalStorageService.setApplicationSent(false);
        await LocalStorageService.clearSendersEmail();

        setState(() {
          _isRegistered = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при регистрации руководителя')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Произошла ошибка: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = GoRouterState.of(context).extra as UsingRequestModel;

    final fullName = [
      request.surname,
      request.name,
      if (request.patronymic != null) request.patronymic,
    ].join(' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация руководителя ОО'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child:
                  _isRegistered
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Регистрация прошла успешно!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed:
                                () => context.go('/login_education_head'),
                            icon: const Icon(Icons.login),
                            label: const Text('Войти'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      )
                      : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Ваши данные из заявки',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ФИО
                            TextFormField(
                              initialValue: fullName,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'ФИО',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Email
                            TextFormField(
                              initialValue: request.email,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Учебное заведение
                            TextFormField(
                              initialValue: request.institutionName,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Учебное заведение',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Адрес
                            TextFormField(
                              initialValue: request.address,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Адрес',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              'Придумайте пароль',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Пароль
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Пароль',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Пароль должен содержать минимум 6 символов';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ElevatedButton.icon(
                                  onPressed: () => _register(request),
                                  icon: const Icon(Icons.app_registration),
                                  label: const Text('Зарегистрироваться'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                ),
                          ],
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
