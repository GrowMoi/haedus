class User < ActiveRecord::Base
  module UserStatistics

    include ApplicationHelper

    def generate_statistics(fields = [])
      statistics = {}
      default_fields = [
        "total_notes",
        "user_sign_in_count",
        "user_created_at",
        "user_updated_at",
        "images_opened_in_count",
        "total_neurons_learnt",
        "user_tests",
        "total_content_readings",
        "content_readings_by_branch",
        "total_right_questions",
        "used_time",
        "user_test_answers",
        "total_contents_learnt",
        "contents_learnt_by_branch",
        "content_learnings_with_reading_times"
      ]
      if fields.empty?
        default_fields.each do |field|
          data = extract_statistic_by_field(field, statistics)
          statistics[field] = {
            value: data[:value],
            meta: data[:meta]
          }
        end
      else
        fields.each do |field|
          statistic = extract_statistic_by_field(field, statistics)
          if (!statistic.empty?)
            statistics[field] = {
              value: statistic[:value],
              meta: statistic[:meta]
            }
          end
        end
      end
      statistics
    end

    private

    def extract_statistic_by_field(field, statistics)
      result = {}
      if field.eql?("total_notes") then result = total_notes(self) end
      if field.eql?("user_sign_in_count") then result = user_sign_in_count(self) end
      if field.eql?("user_created_at") then result = user_created_at(self) end
      if field.eql?("user_updated_at") then result = user_updated_at(self) end
      if field.eql?("images_opened_in_count") then result = images_opened_in_count(self) end
      if field.eql?("total_neurons_learnt") then result = total_neurons_learnt(self) end
      if field.eql?("user_tests") then result = user_tests(self) end
      if field.eql?("total_content_readings") then result = total_content_readings(self) end
      if field.eql?("content_readings_by_branch") then result = content_readings_by_branch(self) end
      if field.eql?("total_right_questions") then result = total_right_questions(self, statistics) end
      if field.eql?("used_time") then result = used_time(self) end
      if field.eql?("average_used_time_by_content") then result = average_used_time_by_content(self) end
      if field.eql?("user_test_answers") then result = user_test_answers(self) end
      if field.eql?("total_contents_learnt") then result = total_contents_learnt(self) end
      if field.eql?("contents_learnt_by_branch") then result = get_contents_learnt_by_branch(self) end
      if field.eql?("content_learnings_with_reading_times") then result =  content_learnings_with_reading_times(self) end
      return result
    end

    def total_notes(user)
      {
        value: ContentNote.where(user: user).size,
        meta: {
          label: I18n.t("views.tutor.analysis.total_notes"),
          label_analysis: I18n.t("views.tutor.analysis.total_notes")
        }
      }
    end

    def user_sign_in_count(user)
      {
        value: user.sign_in_count,
        meta: {
          label: I18n.t("views.tutor.analysis.user_sign_in_count"),
          label_analysis: I18n.t("views.tutor.analysis.user_sign_in_count")
        }
      }
    end

    def user_created_at(user)
      {
        value: user.created_at,
        meta: {}
      }
    end

    def user_updated_at(user)
      {
        value: user.updated_at,
        meta: {}
      }
    end

    def images_opened_in_count(user)
      {
        value: UserSeenImage.where(user: user).size,
        meta: {
          label: I18n.t("views.tutor.analysis.images_opened_in_count"),
          label_analysis: I18n.t("views.tutor.analysis.images_opened_in_count")
        }
      }
    end

    def total_neurons_learnt(user)
      {
        value: TreeService::LearntNeuronsFetcher.new(user).ids.uniq.size,
        meta: {
          label: I18n.t("views.tutor.client.total_neurons_learnt"),
          label_analysis: I18n.t("views.tutor.analysis.total_neurons_learnt")
        }
      }
    end

    def user_tests(user)
      {
        value: AnalyticService::TestStatistic.new(user).results,
        meta: {}
      }
    end

    def total_content_readings(user)
      {
        value: user.content_readings.size,
        meta: {
          label: I18n.t("views.tutor.client.total_content_readings"),
          label_analysis: I18n.t("views.tutor.analysis.total_content_readings")
        }
      }
    end

    def content_readings_by_branch(user)
      {
        value: AnalyticService::ContentReadingsByBranch.new(user).results,
        meta: {
          label: I18n.t("views.tutor.analysis.content_readings_by_branch"),
          label_analysis: I18n.t("views.tutor.analysis.content_readings_by_branch")
        }
      }
    end

    def total_right_questions(user, statistics)
      {
        value: AnalyticService::UtilsStatistic.new(user, statistics).total_right_questions,
        meta: {
          label: I18n.t("views.tutor.client.total_right_questions"),
          label_analysis: I18n.t("views.tutor.analysis.total_right_questions")
        }
      }
    end

    def used_time(user)
      time_ms = time_diff(user)
      {
        value: time_ms,
        meta: {
          label: I18n.t("views.tutor.analysis.used_time"),
          label_analysis: I18n.t("views.tutor.analysis.used_time"),
          value_humanized: humanize_ms(time_ms)
        }
      }
    end

    def average_used_time_by_content(user)
      average = AnalyticService::UsedTimeByContent.new(user).average
      {
        value: average,
        meta: {
          label: I18n.t("views.tutor.report.average_used_time_by_content"),
          value_humanized: humanize_ms(average)
        }
      }
    end

    def time_diff(user)
      start_d = user.created_at
      end_d = user.updated_at
      time_diff = end_d - start_d
      milliseconds = (time_diff.to_f.round(3)*1000).to_i
      milliseconds
    end

    def user_test_answers(user)
      learning_tests = []
      user.learning_tests.completed.order(updated_at: :asc).each do |test|
        test[:questions].each do |question|
          data = {
            question: {
              test_id: test.id,
              content_id: question["content_id"],
              question: question["title"],
              correct_answer: false
            }
          }
          if test[:answers].present?
            answer = test[:answers].detect {|a| a["content_id"] == question["content_id"]}
            data[:question][:correct_answer] = answer["correct"]
          end
          learning_tests.push data
        end
      end
      {
        value: learning_tests,
        meta: {}
      }
    end

    def total_contents_learnt(user)
      {
        value: user.learned_contents.count,
        meta: {}
      }
    end

    def get_contents_learnt_by_branch(user)
      {
        value: AnalyticService::UtilsStatistic.new(user, nil).contents_learnt_by_branch,
        meta: {}
      }
    end

    def content_learnings_with_reading_times(user)
      res = []
      content_reading_times = user.content_reading_times.select(:content_id, :time).group(:content_id).sum(:time)
      user.content_learnings.find_each do |content_learning|
        value = content_reading_times.detect{|k,v| k == content_learning[:content_id]}
        res.push ({
          content: content_learning.content,
          time_reading: value.present? ? value[1] : 0
        })
      end
      {
        value: res,
        meta: {}
      }
    end

  end
end
