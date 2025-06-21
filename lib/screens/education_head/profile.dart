import 'dart:io';

import 'package:edu_sync/services/institution_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:edu_sync/models/education_head_model.dart';
import 'package:edu_sync/services/education_head_servives.dart';
import 'package:edu_sync/models/institution_model.dart';

class EducationHeadProfileScreen extends StatefulWidget {
  const EducationHeadProfileScreen({Key? key}) : super(key: key);

  @override
  State<EducationHeadProfileScreen> createState() =>
      _EducationHeadProfileScreenState();
}

class _EducationHeadProfileScreenState
    extends State<EducationHeadProfileScreen> {
  EducationHeadModel? _educationHead;
  InstitutionModel? _institution;
  bool _isLoading = true;

  //кэш переменные
  static EducationHeadModel? _cachedHead;
  static InstitutionModel? _cachedInstitution;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_cachedHead != null && _cachedInstitution != null) {
      setState(() {
        _educationHead = _cachedHead;
        _institution = _cachedInstitution;
        _isLoading = false;
      });
      return;
    }

    if (_isLoading) {
      final state = GoRouterState.of(context);
      final email = state.extra as String;

      _loadProfile(email);
    }
  }

  Future<void> _loadProfile(String email) async {
    print('Загрузка профиля для: $email');

    final head = await EducationHeadServives.getByEmail(email);
    if (!mounted) return;

    if (head == null) {
      print('❗ Руководитель не найден по email: $email');
      setState(() => _isLoading = false);
      return;
    }

    final institution = await InstitutionService.getInstitutionById(
      head.institutionId,
    );
    if (!mounted) return;

    if (institution == null) {
      print('❗ Учреждение не найдено по id: ${head.institutionId}');
      setState(() => _isLoading = false);
      return;
    }

    _cachedHead = head;
    _cachedInstitution = institution;

    setState(() {
      _educationHead = head;
      _institution = institution;
      _isLoading = false;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value ?? '—'),
      leading: const Icon(Icons.info_outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль'), centerTitle: true),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _educationHead == null
              ? const Center(
                child: Text('Не удалось загрузить данные профиля.'),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'EduSync',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent.shade700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Личные данные'),
                    _buildInfoTile('Фамилия', _educationHead!.surname),
                    _buildInfoTile('Имя', _educationHead!.name),
                    _buildInfoTile('Отчество', _educationHead!.patronymic),
                    _buildInfoTile('Email', _educationHead!.email),

                    const SizedBox(height: 24),

                    _buildSectionTitle('Учебное заведение'),
                    _buildInfoTile('Название', _institution!.name),
                    _buildInfoTile('Адрес', _institution!.address),
                  ],
                ),
              ),
    );
  }
}
