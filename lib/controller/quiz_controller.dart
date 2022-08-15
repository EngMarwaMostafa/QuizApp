import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/question_model.dart';
import '../screens/WelcomeScreen.dart';
import '../screens/result_sreen.dart';

class QuizController extends GetxController{
  String name = '';
  //question variables
  int get countOfQuestion => _questionsList.length;
  final List<QuestionModel> _questionsList = [
    QuestionModel(
      id: 1,
      question:
      "What was Meta Platforms Inc formerly known as? ",
      answer: 2,
      options: ['Insta', 'Meta', 'Facebook', 'Whatsapp '],
    ),
    QuestionModel(
      id: 2,
      question: "Which English city is known as the Steel City? ",
      answer: 0,
      options: ['Sheffield', 'London', 'Paris', 'New York'],
    ),
    QuestionModel(
      id: 3,
      question: "How many lives is a cat said to have?",
      answer: 1,
      options: ['8', '9', '10', '11'],
    ),
    QuestionModel(
      id: 4,
      question: "Rojo is the Spanish word for which colour?",
      answer: 0,
      options: ['Red', 'Yellow', 'Black', 'Brown'],
    ),
    QuestionModel(
      id: 5,
      question:
      "Pyrophobia is the fear of what?",
      answer: 2,
      options: ['Animals', 'Sun', 'Fire', 'All of the above'],
    ),
    QuestionModel(
      id: 6,
      question: "Longest river in the world,which?",
      answer: 0,
      options: ['Nile', 'Amazon', 'Alforat', 'NONE OF ABOVE'],
    ),
    QuestionModel(
      id: 7,
      question: "What is the capital of New Zealand?",
      answer: 2,
      options: ['Cairo', 'Paris', 'Wellington', 'NONE OF ABOVE'],
    ),
    QuestionModel(
      id: 8,
      question: "Which 2019 film won the Golden Raspberry Award for Worst Film this year?",
      answer: 0,
      options: ['Cats', 'Underworld', 'Lucy', 'NONE OF ABOVE'],
    ),
    QuestionModel(
      id: 9,
      question:
      "What in the animal kingdom is a doe? ",
      answer: 1,
      options: ['Dog', 'A female deer', 'Snake', 'Cocodile '],
    ),
    QuestionModel(
      id: 10,
      question: "How many zeros are there in one thousand? ",
      answer: 3,
      options: ['6', '4', '8', '3'],
    ),
  ];

  List<QuestionModel> get questionsList => [..._questionsList];


  bool _isPressed = false;


  bool get isPressed => _isPressed; //To check if the answer is pressed


  double _numberOfQuestion = 1;


  double get numberOfQuestion => _numberOfQuestion;


  int? _selectAnswer;


  int? get selectAnswer => _selectAnswer;


  int? _correctAnswer;


  int _countOfCorrectAnswers = 0;


  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  //map for check if the question has been answered
  final Map<int, bool> _questionIsAnswerd = {};


  //page view controller
  late PageController pageController;

  //timer
  Timer? _timer;


  final maxSec = 15;


  final RxInt _sec = 15.obs;


  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  //get final score
  double get scoreResult {
    return _countOfCorrectAnswers * 100 / _questionsList.length;
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswerd.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500)).then((value) => nextQuestion());
    update();
  }

  //check if the question has been answered
  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswerd.entries
        .firstWhere((element) => element.key == quesId)
        .value;
  }

  void nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionsList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  //called when start again quiz
  void resetAnswer() {
    for (var element in _questionsList) {
      _questionIsAnswerd.addAll({element.id: false});
    }
    update();
  }

  //get right and wrong color
  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  //het right and wrong icon
  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer!.cancel();
  //call when start again quiz
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}