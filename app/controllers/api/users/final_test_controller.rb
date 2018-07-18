module Api
  module Users
    class FinalTestController < BaseController
      before_action :authenticate_user!

      expose(:user) {
        current_user
      }

      expose(:test) {
        test = ContentLearningFinalTest.find(params[:id])
      }

      respond_to :json

      api :POST,
          "/users/final_test",
          "create a test with 21 questions"

      def create
        if user
          response = {
            status: :created,
            questions: final_test_fetcher.user_final_test_for_api,
          }
        else
          response = { status: :unprocessable_entity }
        end
        render json: response,
               status: response[:status]
      end

      api :GET,
          "/users/final_test/:id",
          "Get final test"
      example %q{
        // respuesta con test
        {
          "id": 1,
          "questions": [
            {
              "content_id":6,
              "title":"Content 6",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":7,
                  "text":"Possible answer 7"
                },
                {
                  "id":8,
                  "text":"Possible answer 8"
                },
                {
                  "id":9,
                  "text":"Possible answer 9"
                }
              ]
            },
            {
              "content_id":7,
              "title":"Content 7",
              "media_url": null,
              "possible_answers":[
                {
                  "id":10,
                  "text":"Possible answer 10"
                },
                {
                  "id":11,
                  "text":"Possible answer 11"
                },
                {
                  "id":12,
                  "text":"Possible answer 12"
                }
              ]
            },
            {
              "content_id":8,
              "title":"Content 8",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":13,
                  "text":"Possible answer 13"
                },
                {
                  "id":14,
                  "text":"Possible answer 14"
                },
                {
                  "id":15,
                  "text":"Possible answer 15"
                }
              ]
            },
            {
              "content_id":9,
              "title":"Content 9",
              "media_url": "some_url",
              "possible_answers":[
                {
                  "id":16,
                  "text":"Possible answer 16"
                },
                {
                  "id":17,
                  "text":"Possible answer 17"
                },
                {
                  "id":18,
                  "text":"Possible answer 18"
                }
              ]
            }
          ]
        }
      }
      def show
        render json: {
          id: test.id,
          questions: test.questions
        }
      end

      def answer
        answerer_result = answerer.result
        render json: {
          result: answerer_result,
          time: time_test,
          contents_learnt_by_branch: contents_learnt_by_branch,
          current_learnt_contents: user.content_learnings.count,
          total_approved_contents: total_approved_contents
        }
      end

      private

      expose(:total_approved_contents) {
        Neuron.approved_public_contents.count
      }

      def contents_learnt_by_branch
        AnalyticService::UtilsStatistic.new(user, nil).contents_learnt_by_branch
      end

      def time_test
        time_diff = test.updated_at - test.created_at
        time = Time.at(time_diff).utc.strftime("%M :%S")
      end

      def answerer
        TreeService::AnswerFinalTest.new(
          user_test: test,
          answers: JSON.parse(params[:answers])
        ).process!
      end


      def final_test_fetcher
        @final_test_fetcher ||= TreeService::FinalTestFetcher.new(
          user
        )
      end
    end
  end
end
