import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/models/post_model.dart';
import 'package:dental_case_matching_app/services/post_store.dart';
import 'package:dental_case_matching_app/utils/app_session.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/custom_textfield.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const List<String> _caseTypes = <String>[
    'Possible Cavity Case',
    'Possible Gum Disease Case',
    'Possible Root Canal Case',
    'Possible Wisdom Tooth Case',
    'Possible Sensitivity Case',
  ];

  late final TextEditingController _detailsController;
  String? _selectedCaseType;

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
    _detailsController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _detailsController.removeListener(_onFormChanged);
    _detailsController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canSubmit {
    return _selectedCaseType != null &&
        _selectedCaseType!.isNotEmpty &&
        _detailsController.text.trim().isNotEmpty;
  }

  String _buildPostTitle(String details) {
    final words = details.trim().split(RegExp(r'\s+')).where((word) {
      return word.isNotEmpty;
    }).toList();

    if (words.isEmpty) {
      return 'Patient Case';
    }

    final preview = words.take(4).join(' ');
    return words.length > 4 ? '$preview...' : preview;
  }

  void _submitPost() {
    if (!_canSubmit) {
      return;
    }

    final caseType = _selectedCaseType!;
    final details = _detailsController.text.trim();
    final contactInfo = AppSession.patientPhoneNumber ?? '';

    PostStore.addPost(
      PostModel(
        postId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'demo-patient',
        title: _buildPostTitle(details),
        description: details,
        symptoms: const [],
        suggestedCaseType: caseType,
        contactInfo: contactInfo,
        createdAt: DateTime.now(),
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.myPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      bottomNavigationBar: PatientBottomNav(
        selectedIndex: 0,
        onHomeTap: () {
          Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
        },
        onCreateTap: () {},
        onProfileTap: () {
          Navigator.pushNamed(context, AppRoutes.patientProfile);
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          children: [
            Text(
              'Create a New Case',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the closest case type and describe the issue clearly so students can review it faster.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Post',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the closest case type and write a short description of the issue.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCaseType,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Case Type',
                      hintText: 'Select a case type',
                    ),
                    items: _caseTypes
                        .map(
                          (caseType) => DropdownMenuItem<String>(
                            value: caseType,
                            child: Text(caseType),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCaseType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the closest student-friendly case type.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Additional Information',
                    hintText: 'Describe the issue in a few details',
                    controller: _detailsController,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Both fields are required before posting.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Post Case',
              icon: Icons.send_rounded,
              onPressed: _canSubmit ? _submitPost : null,
            ),
          ],
        ),
      ),
    );
  }
}
