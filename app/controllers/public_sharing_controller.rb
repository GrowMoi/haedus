class PublicSharingController < ApplicationController
  layout false

  def show
    @social_sharing = SocialSharing.friendly.find(params[:id])
    if !agent_is_facebook? && !agent_is_twitter? && !Rails.env.test?
      redirect_to(@social_sharing.uri)
    end
  end

  private

  def agent_is_facebook?
    request.user_agent =~ Regexp.new("facebookexternalhit", Regexp::IGNORECASE)
  end

  def agent_is_twitter?
    request.user_agent =~ Regexp.new("twitterbot", Regexp::IGNORECASE)
  end

  def facebook_app_id
    Rails.application.secrets.facebook_app_id
  end
  helper_method :facebook_app_id

  def twitter_site
    Rails.application.secrets.twitter_site
  end
  helper_method :twitter_site
end
