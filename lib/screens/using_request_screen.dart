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
      // Очистка формы
      institutionController.clear();
      addressController.clear();
      surnameController.clear();
      nameController.clear();
      patronymicController.clear();
      emailController.clear();

      setState(() {
        _submitted = true; // скрываем форму
      });
      await LocalStorageService.setApplicationSent(true);
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
      appBar: AppBar(title: const Text('Подключение к системе')),
      body: SafeArea(
        child: _submitted ? _buildSubmittedMessage() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Заявка на подключение к системе',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildTextField(institutionController, 'Название учреждения'),
            _buildTextField(addressController, 'Адрес'),
            _buildTextField(surnameController, 'Фамилия'),
            _buildTextField(nameController, 'Имя'),
            _buildTextField(
              patronymicController,
              'Отчество (необязательно)',
              isRequired: false,
            ),
            _buildTextField(
              emailController,
              'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Отправить заявку'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 100),
            SizedBox(height: 24),
            Text(
              'Ваша заявка успешно отправлена\nи находится в обработке.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'Пожалуйста, заполните это поле';
          }
          return null;
        },
      ),
    );
  }
}
