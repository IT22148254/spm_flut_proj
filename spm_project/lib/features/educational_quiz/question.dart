// lib/question.dart
class Question {
  final int? id;
  final String question;
  final String answer1;
  final String answer2;
  final String correctAnswer;

  Question({
    this.id,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.correctAnswer,
  });

  // Convert a Question into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer1': answer1,
      'answer2': answer2,
      'correctAnswer': correctAnswer,
    };
  }

  // Implement toString to make it easier to see information about each question when using the print statement.
  @override
  String toString() {
    return 'Question{id: $id, question: $question, answer1: $answer1, answer2: $answer2, correctAnswer: $correctAnswer}';
  }

  // Create a Question from a Map
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      answer1: map['answer1'],
      answer2: map['answer2'],
      correctAnswer: map['correctAnswer'],
    );
  }
}
