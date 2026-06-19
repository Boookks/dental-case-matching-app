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

enum _SuggestionStage { topicSelection, questions, result }

class _SmartSuggestionScreenState extends State<SmartSuggestionScreen> {
  static const List<_SuggestionTopic> _topics = <_SuggestionTopic>[
    _SuggestionTopic(
      title: 'Cavity',
      subtitle: 'Tooth sensitivity or pain',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(
          question:
              'Do you feel pain or sensitivity when eating or drinking something cold, hot, or sweet?',
        ),
        _SuggestionQuestion(
          question: 'Do you have pain in one tooth when chewing?',
        ),
        _SuggestionQuestion(
          question:
              'Do you see a dark spot, a hole, or food getting stuck in one tooth?',
        ),
      ],
    ),
    _SuggestionTopic(
      title: 'Root Canal',
      subtitle: 'Severe tooth pain',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(
          question:
              'Do you have a strong toothache that keeps coming back or feels constant?',
        ),
        _SuggestionQuestion(
          question: 'Does one tooth hurt more when you bite on it?',
        ),
        _SuggestionQuestion(
          question:
              'Do you have swelling or a pimple-like bump near that tooth or gum?',
        ),
      ],
    ),
    _SuggestionTopic(
      title: 'Gum Disease',
      subtitle: 'Bleeding or swollen gums',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(
          question: 'Do your gums bleed when brushing or flossing?',
        ),
        _SuggestionQuestion(question: 'Are your gums red, swollen, or tender?'),
        _SuggestionQuestion(
          question:
              'Do you have bad breath or gums that seem to be pulling away from the teeth?',
        ),
      ],
    ),
    _SuggestionTopic(
      title: 'Extraction',
      subtitle: 'Broken or badly damaged tooth',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(
          question:
              'Is one of your teeth badly broken or too damaged to use normally?',
        ),
        _SuggestionQuestion(
          question: 'Do you have severe pain or swelling around that tooth?',
        ),
        _SuggestionQuestion(
          question: 'Does the tooth feel very loose or hard to keep clean?',
        ),
      ],
    ),
    _SuggestionTopic(
      title: 'Prosthesis',
      subtitle: 'Missing teeth or replacement issue',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(question: 'Are you missing one or more teeth?'),
        _SuggestionQuestion(
          question:
              'Do you already wear a denture, bridge, or similar replacement that does not fit well?',
        ),
        _SuggestionQuestion(
          question:
              'Do missing teeth make it hard to chew or speak comfortably?',
        ),
      ],
    ),
    _SuggestionTopic(
      title: 'Braces',
      subtitle: 'Crooked teeth or bite alignment',
      questions: <_SuggestionQuestion>[
        _SuggestionQuestion(
          question: 'Are your teeth crowded, overlapping, or spaced far apart?',
        ),
        _SuggestionQuestion(
          question: 'Does your bite feel uneven, off, or not aligned properly?',
        ),
        _SuggestionQuestion(
          question:
              'Do you want to correct the position of your teeth or jaw alignment?',
        ),
      ],
    ),
  ];

  static const String _noClearSuggestion = 'No Clear Suggestion';

  _SuggestionStage _stage = _SuggestionStage.topicSelection;
  _SuggestionTopic? _selectedTopic;
  List<bool?> _answers = List<bool?>.filled(3, null);
  int _currentQuestionIndex = 0;
  String? _suggestedCaseType;

  double get _progressValue {
    if (_stage == _SuggestionStage.result) {
      return 1;
    }

    if (_stage != _SuggestionStage.questions || _questions.isEmpty) {
      return 0;
    }

    return _answeredQuestionsCount / _questions.length;
  }

  List<_SuggestionQuestion> get _questions =>
      _selectedTopic?.questions ?? const <_SuggestionQuestion>[];

  int get _answeredQuestionsCount =>
      _answers.where((answer) => answer != null).length;

  int get _yesAnswersCount => _answers.where((answer) => answer == true).length;

  bool get _showResult => _stage == _SuggestionStage.result;

  void _selectTopic(_SuggestionTopic topic) {
    setState(() {
      _selectedTopic = topic;
      _suggestedCaseType = null;
    });
  }

  void _startQuestions() {
    final topic = _selectedTopic;
    if (topic == null) {
      return;
    }

    setState(() {
      _selectedTopic = topic;
      _stage = _SuggestionStage.questions;
      _currentQuestionIndex = 0;
      _answers = List<bool?>.filled(topic.questions.length, null);
      _suggestedCaseType = null;
    });
  }

  void _answerCurrentQuestion(bool answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
      if (_currentQuestionIndex == _questions.length - 1) {
        _suggestedCaseType = _buildSuggestion();
        _stage = _SuggestionStage.result;
      } else {
        _currentQuestionIndex += 1;
      }
    });
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _answers[_currentQuestionIndex - 1] = null;
        _currentQuestionIndex -= 1;
      });
      return;
    }
  }

  void _exitToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.patientHome,
      (route) => false,
    );
  }

  String _buildSuggestion() {
    final topic = _selectedTopic;
    if (topic == null || _yesAnswersCount == 0) {
      return _noClearSuggestion;
    }

    return 'Possible ${topic.title} Case';
  }

  void _openCreatePostFromSuggestion() {
    final suggestion = _suggestedCaseType;
    if (suggestion == null) {
      return;
    }

    final preselectedCaseType = suggestion == _noClearSuggestion
        ? null
        : suggestion;

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

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _stage == _SuggestionStage.questions
        ? _questions[_currentQuestionIndex]
        : null;

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
                    if (_stage == _SuggestionStage.topicSelection) ...[
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
                            child: Text(
                              'What seems to be the main problem?',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...[
                        for (final topic in _topics) ...[
                          _TopicCard(
                            subtitle: topic.subtitle,
                            selected: _selectedTopic == topic,
                            onTap: () => _selectTopic(topic),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                      const SizedBox(height: 4),
                      CustomButton(
                        label: 'Continue',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _selectedTopic == null
                            ? null
                            : _startQuestions,
                      ),
                    ] else ...[
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
                          question: currentQuestion!.question,
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

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.softBlue : AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : AppColors.softBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? AppColors.primary : AppColors.textSecondary,
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
          Text(question, style: Theme.of(context).textTheme.titleLarge),
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
                child: OutlinedButton(onPressed: onNo, child: const Text('No')),
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
          Text(helperText, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SuggestionQuestion {
  const _SuggestionQuestion({required this.question});

  final String question;
}

class _SuggestionTopic {
  const _SuggestionTopic({
    required this.title,
    required this.subtitle,
    required this.questions,
  });

  final String title;
  final String subtitle;
  final List<_SuggestionQuestion> questions;
}
