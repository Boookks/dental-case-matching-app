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
  const CreatePostScreen({
    super.key,
    this.initialAssessment,
    this.initialCaseType,
  });

  final bool? initialAssessment;
  final String? initialCaseType;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const List<String> _assessedCaseTypes = <String>[
    'Cavity Case',
    'Root Canal Case',
    'Gum Disease Case',
    'Extraction Case',
    'Prosthesis Case',
    'Braces Case',
  ];

  static const List<String> _notAssessedCaseTypes = <String>[
    'Possible Cavity Case',
    'Possible Root Canal Case',
    'Possible Gum Disease Case',
    'Possible Extraction Case',
    'Possible Prosthesis Case',
    'Possible Braces Case',
  ];

  late final TextEditingController _detailsController;
  bool? _isAlreadyAssessed;
  String? _selectedCaseType;

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
    _detailsController.addListener(_onFormChanged);
    _isAlreadyAssessed = widget.initialAssessment;
    _selectedCaseType = widget.initialCaseType;
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

  List<String> get _availableCaseTypes {
    return _isAlreadyAssessed == true
        ? _assessedCaseTypes
        : _notAssessedCaseTypes;
  }

  bool get _shouldShowForm => _isAlreadyAssessed != null;

  bool get _canSubmit {
    return _shouldShowForm &&
        (AppSession.patientPhoneNumber?.trim().isNotEmpty ?? false) &&
        _selectedCaseType != null &&
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

  void _setAssessment(bool isAlreadyAssessed) {
    setState(() {
      _isAlreadyAssessed = isAlreadyAssessed;
      _selectedCaseType = null;
      _detailsController.clear();
    });
  }

  void _submitPost() {
    if (!_canSubmit) {
      if ((AppSession.patientPhoneNumber?.trim().isEmpty ?? true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add your contact number in your profile first.'),
          ),
        );
      }
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
        isAlreadyAssessed: _isAlreadyAssessed ?? false,
        contactInfo: contactInfo,
        createdAt: DateTime.now(),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.myPosts,
      ModalRoute.withName(AppRoutes.patientHome),
    );
  }

  void _goHomeAndClearStack() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.patientHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goHomeAndClearStack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: PatientBottomNav(
          selectedIndex: -1,
          onHomeTap: _goHomeAndClearStack,
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
                'Choose whether this case has already been assessed, then add the details.',
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
                      'Case Assessment',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select one option below.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Material(
                      color: Colors.transparent,
                      child: RadioGroup<bool>(
                        groupValue: _isAlreadyAssessed,
                        onChanged: (value) {
                          if (value != null) {
                            _setAssessment(value);
                          }
                        },
                        child: Column(
                          children: [
                            RadioListTile<bool>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Already Assessed'),
                              subtitle: const Text(
                                'A student already reviewed it.',
                              ),
                              value: true,
                            ),
                            RadioListTile<bool>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Not Yet Assessed'),
                              subtitle: const Text(
                                'No student has reviewed it yet.',
                              ),
                              value: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_shouldShowForm) ...[
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
                        'Case Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isAlreadyAssessed == true
                            ? 'Pick the case type and describe the issue briefly.'
                            : 'Pick the closest case type and describe the issue briefly.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (AppSession.patientPhoneNumber?.trim().isEmpty ?? true) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.softBlue,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'Add your contact number in your profile before posting.',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCaseType,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Case Type',
                          hintText: 'Select a case type',
                        ),
                        items: _availableCaseTypes
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
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Additional Information',
                        hintText: 'Describe the issue briefly',
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
            ],
          ),
        ),
      ),
    );
  }
}
