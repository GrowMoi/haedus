class TutorAchievementsSearch < Searchlight::Search
  search_on TutorAchievement.all
  searches :q, :current_user

  def search_current_user
    search.where(tutor: options[:current_user])
  end

  def search_q
    search.where("unaccent(tutor_achievements.name) ILIKE :q", q: "%#{q}%")
  end

end


