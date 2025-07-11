import 'package:flutter/material.dart';
import 'package:edu_sync/models/education_head_model.dart';
import 'package:edu_sync/models/institution_model.dart';
import 'package:edu_sync/services/education_head_cache.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final cachedHead = EducationHeadCache.cachedHead;
    final cachedInstitution = EducationHeadCache.cachedInstitution;

    if (cachedHead != null && cachedInstitution != null) {
      setState(() {
        _educationHead = cachedHead;
        _institution = cachedInstitution;
        _isLoading = false;
      });
    } else {
      print('❗ Не удалось прогрузить кэш профиля');
    }
  }

  Widget _buildInfoTile(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon ?? Icons.info_outline, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? '—',
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> content) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль руководителя'),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _educationHead == null
              ? const Center(child: Text('Не удалось загрузить данные профиля'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildSectionCard('Личные данные', [
                      _buildInfoTile(
                        'Фамилия',
                        _educationHead!.surname,
                        icon: Icons.person,
                      ),
                      _buildInfoTile(
                        'Имя',
                        _educationHead!.name,
                        icon: Icons.badge,
                      ),
                      _buildInfoTile(
                        'Отчество',
                        _educationHead!.patronymic,
                        icon: Icons.badge_outlined,
                      ),
                      _buildInfoTile(
                        'Email',
                        _educationHead!.email,
                        icon: Icons.email,
                      ),
                    ]),
                    _buildSectionCard('Учебное заведение', [
                      _buildInfoTile(
                        'Название',
                        _institution!.name,
                        icon: Icons.school,
                      ),
                      _buildInfoTile(
                        'Адрес',
                        _institution!.address,
                        icon: Icons.location_on,
                      ),
                    ]),
                  ],
                ),
              ),
    );
  }
}
