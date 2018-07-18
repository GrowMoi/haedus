module TreeService
  class AnswerFinalTest
    attr_reader :user_test

    def initialize(options)
      @answers = options.fetch(:answers)
      @user_test = options.fetch(:user_test)
    end

    def process!
      self
    end

    def result
      answers_result = @answers.map do |answer|
        correct_answer = correct_answer?(answer)
        {
          correct: !!correct_answer,
          content_id: answer["content_id"],
          question: Content.find(answer["content_id"]).title
        }
      end
      @user_test.answers = answers_result
      @user_test.save
      answers_result
    end

    private

    def correct_answer?(answer)
      question = user_test.questions.detect do |question|
        question["content_id"] == answer["content_id"]
      end
      answered = question["possible_answers"].detect do |possible_answer|
        possible_answer["id"] == answer["answer_id"]
      end
      answered && answered["correct"]
    end
  end
end
