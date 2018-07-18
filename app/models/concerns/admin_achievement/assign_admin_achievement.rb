class AdminAchievement < ActiveRecord::Base
  module AssignAdminAchievement

    def user_win_achievement?(user)
      case self.number
      when 1
        user_learnt_n_content(self, user)
      when 2..5
        learnt_contents_in_branch(self, user)
      when 6
        learnt_all_contents(user)
      when 7
        learnt_a_content_in_each_public_neuron(user)
      when 8
        successful_continous_tests(self, user)
      when 9
        tests_given(self, user)
      when 10
        user_reach_level(self, user)
      else
        puts "no achievement found"
      end
    end

    private

    ##
    # user learnt n contents
    def user_learnt_n_content(achievement, user)
      number = achievement.settings['quantity']
      user.content_learnings.size >= number
    end

    ##
    # user gave n tests
    def tests_given(achievement, user)
      number = achievement.settings['quantity']
      user.learning_tests.size >= number
    end

    ##
    # user gave tests without errors
    def successful_continous_tests(achievement, user)
      number = achievement.settings['quantity']
      user.continuous_successful_tests(number)
    end

    ##
    # user learnt all contest public/approved
    def learnt_all_contents(user)
      total_contents = Neuron.approved_public_contents.count
      user.content_learnings.size == total_contents
    end

    ##
    # user learnt almost a content by public neuron
    def learnt_a_content_in_each_public_neuron(user)
      public_neurons = Neuron.where(is_public: true, active: true)
                             .sort_by(&:position)
      give_achievement = false
      runLoop = true
      i = 0
      until runLoop == false || i == public_neurons.count
        neuron = public_neurons[i]
        runLoop = user.already_learnt_any?(neuron.contents)
        give_achievement = runLoop
        i += 1
      end
      give_achievement
    end

    ##
    # user learnt content specific branch
    def learnt_contents_in_branch(achievement, user)
      name = achievement.settings['branch']
      contents = user.contents_learnt_by_branch(name)
      unless contents.blank?
        contents.size >= achievement.settings['quantity']
      else
        false
      end
    end

    ##
    # user reach a specific level
    def user_reach_level(achievement, user)
      user_tree = TreeService::UserTreeFetcher.new(user, nil)
      user_tree.depth == achievement.settings['level']
    end
  end
end
