module Api
  class PaymentsController < BaseController

    api :POST,
        "/payments/tutor_basic_account",
        "Create tutor account by payment method"
    param :total, Integer
    param :source, String
    param :payment_id, String
    param :code_item, String
    param :quantity, Float
    param :name, String
    param :email, String

    def tutor_basic_account
      tutor_isValid = !params[:name].blank? && !params[:email].blank?
      payment_isValid = validate_params(params)
      product_key = Rails.application.secrets.basic_account_tutor_key
      product = Product.where(code: params[:code_item], key: product_key ).first
      isValidCode = !product.nil?

      if (tutor_isValid && payment_isValid && isValidCode)
        user = User.new(name: params[:name],
                        email: params[:email],
                        username: generate_username,
                        password: generate_password,
                        role: "tutor_familiar")
        if user.save
          #account and 1 student free
          product_key = Rails.application.secrets.add_client_to_tutor_key
          product_add_student  = Product.find_by_key(product_key)
          payment_products =  [
            {
              total: params[:total],
              source: params[:source],
              payment_id: params[:payment_id],
              code_item: params[:code_item],
              user_id: user.id,
              product_id: product.id,
              quantity: 1
            },
            {
              total: 0,
              source: params[:source],
              payment_id: params[:payment_id],
              code_item: product_add_student.code,
              user_id: user.id,
              product_id: product_add_student.id,
              quantity: 1
            }
          ]
          payment_products.map {|payment| Payment.new(payment).save }
          TutorMailer.payment_account(user.name, user.password, user.email).deliver_now
          render text: "Valid payment",
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

    api :POST,
        "/payments/add_students",
        "Allow to add students at the tutor list by payment method"
    param :total, Integer
    param :source, String
    param :payment_id, String
    param :code_item, String
    param :quantity, Float
    param :name, String
    param :email, String

    def add_students
      tutor_isValid = !params[:email].blank?
      payment_isValid = validate_params(params) && !params[:quantity].blank?
      product_key = Rails.application.secrets.add_client_to_tutor_key
      product = Product.where(code: params[:code_item], key: product_key).first
      isValidCode = !product.nil?

      if (tutor_isValid && payment_isValid && isValidCode)
        user = User.find_by_email(params[:email])
        if user
          payment = Payment.new(payment_params)
          payment.user = user
          payment.product = product
          payment.save
          TutorMailer.payment_add_student(user.name, user.email, params[:quantity]).deliver_now
          render text: "Valid payment",
                 status: :accepted
        else
          render nothing: true,
                  status: 404
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
        :code_item,
        :user_id,
        :quantity
      )
    end

    def generate_username
      username = "moi-" + params[:email].parameterize + rand(1000).to_s
    end

    def generate_password
      password = Devise.friendly_token.first(10)
    end

    def validate_params(params)
      return !params[:payment_id].blank? && !params[:code_item].blank?
    end
  end
end
