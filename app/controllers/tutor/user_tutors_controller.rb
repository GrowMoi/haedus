module Tutor
  class UserTutorsController < TutorController::Base
    def create
      if current_user.admin?
        add_new_students
      end

      if current_user.tutor?
        sent_new_requests
      end

      if current_user.tutor_familiar?
        check_payment_and_sent_new_requests
      end
    end

    def destroy
      request = UserTutor.where(tutor_id: current_user.id, user_id: params[:id] ).first
      if request.destroy
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.cancel_request_ok"
          ),
          type: 'cancel_request_ok',
        },
        status: 200
      else
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.cancel_request_failed"
          ),
          type: 'cancel_request_failed',
        },
        status: 422
      end
    end

    def remove_user
      request = UserTutor.where(tutor_id: current_user.id, user_id: params[:id] ).first
      if request
        request.status = "deleted"
        request.save
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.remove_user_ok"
          ),
          type: 'deleted_ok',
        },
        status: 200
      else
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.remove_user_failed"
          ),
          type: 'deleted_failed',
        },
        status: 422
      end
    end

    private

    def add_new_students
      if params[:user_ids]
        user_ids = params[:user_ids]
        user_names = []
        user_ids.each do |id|
          tutor_request = current_user.tutor_requests_sent.new(
            user_id: id,
            status: :accepted
          )
          if tutor_request.save
            user_names.push(tutor_request.user.name)
          end
        end
        if user_names.any?
          render json: {
            message: I18n.t(
              "views.tutor.moi.tutor_request.user_added",
              clients: user_names.join(", ")
            )
          }
        else
          render json: {
            message: I18n.t("views.tutor.moi.tutor_request.user_added_error")
          },
          status: 422
        end
      end
    end

    def sent_new_requests
      if params[:user_id]
        add_one_user
      end

      if params[:user_ids]
        add_many_user
      end
    end

    def check_payment_and_sent_new_requests
      product_key = Rails.application.secrets.add_client_to_tutor_key
      product = Product.find_by_key(product_key)
      total_payments = Payment.where(user: current_user, code_item: product.code).sum(:quantity)
      total_my_users = current_user.tutor_requests_sent.accepted.count

      if total_payments > total_my_users
        if params[:user_id]
          add_one_user
        end

        if params[:user_ids]
          total_users = params[:user_ids].count + total_my_users
          if total_payments >= total_users
            add_many_user
          else
            render json: {
              message: I18n.t(
                "views.tutor.moi.tutor_request.cant_add_users",
                number: total_payments
              ),
              type: 'limit_exceeded'
            },
            status: 422
          end
        end
      else
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.cant_add_users",
            number: total_payments
          ),
          type: 'limit_exceeded'
        },
        status: 422
      end
    end


    def add_one_user
      tutor_request = current_user.tutor_requests_sent.new(
        user_id: params[:user_id]
      )
      if tutor_request.save
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.created",
            name: tutor_request.user.name
          )
        }
      else
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.not_created",
            name: tutor_request.user.name
          )
        },
        status: 422
      end
    end

    def add_many_user
      user_ids = params[:user_ids]
      user_names = []
      user_ids.each do |id|
        tutor_request = current_user.tutor_requests_sent.new(
          user_id: id
        )
        if tutor_request.save
          user_names.push(tutor_request.user.name || tutor_request.user.username || tutor_request.user.email)
        end
      end
      if user_names.any?
        render json: {
          message: I18n.t(
            "views.tutor.moi.tutor_request.created_list",
            clients: user_names.join(", ")
          )
        }
      else
        render json: {
          message: I18n.t("views.tutor.moi.tutor_request.not_created_list")
        },
        status: 422
      end
    end
  end
end
