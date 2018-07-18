module Api
  module Users
    class CertificatesController < BaseController
      before_action :authenticate_user!

      respond_to :json

      expose(:all_certificates) {
        results = current_user.certificates
        Kaminari.paginate_array(results)
          .page(params[:page])
          .per(4)
      }

      api :GET,
          "/users/certificates",
          "returns all certificates saved by user"
      param :page, Integer
      def index
        respond_with(
          all_certificates,
          meta: {
            total_items: all_certificates.total_count
          }
        )
      end

      api :POST,
          "/users/certificates",
          "saved a new certificate by user"
      param :media_url, String, required: true
      def create
        user_certificate = Certificate.new(user_id: current_user.id, media_url: params[:media_url])
        user_certificate.save
        unless user_certificate.nil?
          response = { certificate: user_certificate }
          render json: response,
               status: :ok
        else
          response = { status: :unprocessable_entity }
          render json: response,
               status: response[:status]
        end
      end

      api :DELETE,
          "/users/certificates/:id",
          "delete a certificate of an user"
      param :id, Integer, required: true
      def destroy
        user_certificate = Certificate.find(params[:id])
        user_certificate.destroy
        if user_certificate.destroy
          render nothing: true,
               status: :ok
        else
          response = { status: :unprocessable_entity }
          render json: response,
               status: response[:status]
        end
      end

    end
  end
end
