import 'package:dental_case_matching_app/constants/app_colors.dart';
import 'package:dental_case_matching_app/constants/app_routes.dart';
import 'package:dental_case_matching_app/screens/patient/create_post_screen.dart';
import 'package:dental_case_matching_app/widgets/custom_button.dart';
import 'package:dental_case_matching_app/widgets/patient_bottom_nav.dart';
import 'package:flutter/material.dart';

class SmartSuggestionScreen extends StatefulWidget {
  const SmartSuggestionScreen({super.key});

  @override
  State<SmartSuggestionScreen> createState() => _SmartSuggestionScreenState();
}

class _SmartSuggestionScreenState extends State<SmartSuggestionScreen> {
  static const List<_SuggestionQuestion> _questions = <_SuggestionQuestion>[
    _SuggestionQuestion(
      question: 'Do you feel pain when drinking cold water?',
    ),
    _SuggestionQuestion(
      question: 'Is the pain mostly around one tooth?',
    ),
    _SuggestionQuestion(
      question: 'Do your gums bleed when brushing?',
    ),
  ];

  static const List<String> _suggestedCaseTypes = <String>[
    'Possible Cavity Case',
    'Possible Gum Disease Case',
    'Possible Root Canal Case',
    'Possible Wisdom Tooth Case',
    'Possible Sensitivity Case',
  ];
  static const String _noClearSuggestion = 'No Clear Suggestion';

  final List<bool?> _answers = List<bool?>.filled(_questions.length, null);
  int _currentQuestionIndex = 0;
  String? _suggestedCaseType;

  double get _progressValue {
    if (_suggestedCaseType != null) {
      return 1;
    }
    return _answeredQuestionsCount / _questions.length;
  }

  int get _answeredQuestionsCount =>
      _answers.where((answer) => answer != null).length;

  int get _yesAnswersCount =>
      _answers.where((answer) => answer == true).length;

  bool get _showResult => _suggestedCaseType != null;

  void _answerCurrentQuestion(bool answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      if (_currentQuestionIndex == _questions.length - 1) {
        _suggestedCaseType = _buildSuggestion();
      } else {
        _currentQuestionIndex += 1;
      }
    });
  }

  void _goToPreviousQuestion() {
    if (_showResult) {
      setState(() {
        _suggestedCaseType = null;
        _currentQuestionIndex = _questions.length - 1;
      });
      return;
    }

    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex -= 1;
      });
    }
  }

  String _buildSuggestion() {
    if (_yesAnswersCount == 0) {
      return _noClearSuggestion;
    }

    final index = _yesAnswersCount % _suggestedCaseTypes.length;
    return _suggestedCaseTypes[index];
  }

  void _openCreatePostFromSuggestion() {
    final suggestion = _suggestedCaseType;
    if (suggestion == null) {
      return;
    }

    final preselectedCaseType =
        suggestion == _noClearSuggestion ? null : suggestion;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(
          initialAssessment: false,
          initialCaseType: preselectedCaseType,
        ),
      ),
    );
  }

  void _exitToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.patientHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _exitToHome();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Case Suggestion'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: _exitToHome,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back',
          ),
        ),
        bottomNavigationBar: PatientBottomNav(
          selectedIndex: 0,
          onHomeTap: () {
            Navigator.pushReplacementNamed(context, AppRoutes.patientHome);
          },
          onCreateTap: () {
            Navigator.pushNamed(context, AppRoutes.createPost);
          },
          onProfileTap: () {
            Navigator.pushNamed(context, AppRoutes.patientProfile);
          },
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            children: [
              Text(
                'Answer three quick questions to get a suggested case type.',
                style: Theme.of(context).textTheme.bodyMedium,
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.softBlue,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.psychology_alt_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _showResult
                                    ? 'Suggested Case Type'
                                    : 'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _showResult
                                    ? 'Based on your answers'
                                    : '${_questions.length - _answeredQuestionsCount} questions left',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: _progressValue,
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (!_showResult) ...[
                      _QuestionCard(
                        question: currentQuestion.question,
                        onYes: () => _answerCurrentQuestion(true),
                        onNo: () => _answerCurrentQuestion(false),
                      ),
                      if (_currentQuestionIndex > 0) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _goToPreviousQuestion,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Back'),
                        ),
                      ],
                    ] else ...[
                      _ResultCard(
                        suggestedCaseType: _suggestedCaseType!,
                        helperText: _suggestedCaseType == _noClearSuggestion
                            ? 'We could not narrow it down from these answers. You can still create a post if you want a student review.'
                            : 'Use this suggestion as the case type for your post.',
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Create Post',
                        icon: Icons.send_rounded,
                        onPressed: _openCreatePostFromSuggestion,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.onYes,
    required this.onNo,
  });

  final String question;
  final VoidCallback onYes;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onYes,
                  child: const Text('Yes'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onNo,
                  child: const Text('No'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.suggestedCaseType,
    required this.helperText,
  });

  final String suggestedCaseType;
  final String helperText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestedCaseType,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            helperText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SuggestionQuestion {
  const _SuggestionQuestion({
    required this.question,
  });

  final String question;
}
