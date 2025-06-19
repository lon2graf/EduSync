import 'package:flutter/material.dart';
import 'package:edu_sync/models/using_request_model.dart';
import 'package:edu_sync/services/using_request_services.dart';
import 'package:edu_sync/services/local_storage_preferences.dart';

class UsingRequestScreen extends StatefulWidget {
  const UsingRequestScreen({Key? key});

  @override
  _UsingRequestScreenState createState() => _UsingRequestScreenState();
}

class _UsingRequestScreenState extends State<UsingRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  //для того, чтобы блокировать кнопку отправки -> предотвращение спама
  bool _isLoading = false;

  //для того, чтобы фиксировать отправлена ли заявка или нет,
  //чтобы потом скрывать форму для отправки заявки
  bool _submitted = false;

  final TextEditingController institutionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController patronymicController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = UsingRequestModel(
      institutionName: institutionController.text.trim(),
      address: addressController.text.trim(),
      surname: surnameController.text.trim(),
      name: nameController.text.trim(),
      patronymic:
          patronymicController.text.trim().isEmpty
              ? null
              : patronymicController.text.trim(),
      email: emailController.text.trim(),
      isAccepted: false,
      submittedAt: DateTime.now(),
    );

    final success = await UsingRequestServices.submitRequest(request);

    if (success) {
      setState(() {
        _submitted = true; // скрываем форму
      });
      await LocalStorageService.setApplicationSent(true);
      await LocalStorageService.setSendersEmail(emailController.text.trim());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при отправке заявки')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подключение к системе'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: _submitted ? _buildSubmittedMessage() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Заявка на подключение к системе',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(institutionController, 'Название учреждения'),
                  const SizedBox(height: 16),
                  _buildTextField(addressController, 'Адрес'),
                  const SizedBox(height: 16),
                  _buildTextField(surnameController, 'Фамилия'),
                  const SizedBox(height: 16),
                  _buildTextField(nameController, 'Имя'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    patronymicController,
                    'Отчество (необязательно)',
                    isRequired: false,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    emailController,
                    'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleSubmit,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Отправить заявку',
                              style: TextStyle(fontSize: 16),
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

  Widget _buildSubmittedMessage() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              const SizedBox(height: 32),
              Text(
                'Ваша заявка успешно отправлена\nи находится в обработке.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool isRequired = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'Пожалуйста, заполните это поле';
        }
        return null;
      },
    );
  }
}
