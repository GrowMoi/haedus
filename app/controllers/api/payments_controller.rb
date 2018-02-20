module Api
  class PaymentsController < BaseController

    api :POST,
        "/payments/tutor_account",
        "Create tutor account by payment method"
    param :total, Integer
    param :source, String
    param :payment_id, String
    param :name, String
    param :email, String

    def tutor_account
      isValid = true
      if isValid
        user = User.new(name: params[:name],
                        email: params[:email],
                        username: generate_username,
                        password: generate_password,
                        role: "tutor")
        if user.save
          payment = Payment.new(payment_params)
          payment.user = user
          payment.save
          TutorMailer.payment_account(user.name, user.password, user.email).deliver_now
          render nothing: true,
                 status: :accepted
        else
          render text: user.errors.full_messages,
                 status: :unprocessable_entity,
                 errors: user.errors.full_messages
        end
      else
        render text: "invalid payment",
               status: :unprocessable_entity
      end
    end

    private

    def payment_params
      params.require(:payment).permit(
        :total,
        :source,
        :payment_id,
        :user_id
      )
    end

    def generate_username
      username = "moi-" + params[:email].parameterize + rand(1000).to_s
    end

    def generate_password
      password = Devise.friendly_token.first(10)
    end
  end
end
