class UserMailer < ApplicationMailer
	default from: 'Moi Aprendizaje Social <noreply@growmoi.com>'

  def notify_role_change(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("user_mailer.change_permission.subject"))
  end

  def shared_content(name, email, image_url, public_url)
    @user_name = name
    @public_url = public_url
    @image_url = image_url
    @profile_url = "http://moi.growmoi.com/#/user/"+name+"/profile"
    @url_dashboard = "http://moi-backend.growmoi.com/tutor"
    @url_sign_in = "http://moi.growmoi.com/#/login"
    @url_web_site = "http://growmoi.com/"
    @url_facebook = "http://facebook.com/growmoi"
    @url_youtube = "https://www.youtube.com/user/growmoi"
    @url_twitter = "https://twitter.com/growmoi"
    attachments.inline['header_email_shared.png'] = File.read("#{Rails.root}/app/assets/images/header_email_shared.png")
    attachments.inline['footer_email_shared.png'] = File.read("#{Rails.root}/app/assets/images/footer_email_shared.png")
    attachments.inline['tw_icon.png'] = File.read("#{Rails.root}/app/assets/images/tw_icon.png")
    attachments.inline['yt_icon.png'] = File.read("#{Rails.root}/app/assets/images/yt_icon.png")
    attachments.inline['fb_icon.png'] = File.read("#{Rails.root}/app/assets/images/fb_icon.png")
    mail(to: email, subject: I18n.t("user_mailer.shared_content.subject"))
  end
end
