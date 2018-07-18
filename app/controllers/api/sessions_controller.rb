module Api
  class SessionsController < DeviseTokenAuth::SessionsController
    extend BaseDoc
    include DeviseTokenAuth::Concerns::SetUserByToken
    include BaseController::JsonRequestsForgeryBypass

    resource_description do
      short "user session"
      description "sessions handled by `devise_token_auth` gem"
    end

    doc_for :sign_out do
      api :DELETE,
          "/auth/user/sign_out",
          "log out"
      description "aka end session"
    end

    doc_for :sign_in do
      api :POST,
          "/auth/user/sign_in",
          "login"
      description "authenticate using email and password. Response includes user's content preferences"
      param :login, String, required: true
      param :password, String, required: true
      example '{"success":true,"data":{"id":1,"email":"somebody@example.com","name":"Somebody","role":"role","uid":"somebody@example.com","provider":"email","content_preferences":[{"kind":"que-es","level":1, "order":0},...]}}'
    end

    ##
    # @note override so that we can authenticate
    #   using username as well
    def create
      # Check
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      @resource = nil
      if field
        q_value = resource_params[field]

        if resource_class.case_insensitive_keys.include?(field)
          q_value.downcase!
        end

        conditions = { field => q_value }
        @resource = resource_class.find_for_database_authentication(conditions)
      end

      if @resource and valid_params?(field, q_value) and @resource.valid_password?(resource_params[:password]) and (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)
        create_resource_session!
      elsif @resource and not (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)
        render_create_error_not_confirmed
      else
        render_create_error_bad_credentials
      end
    end

    api :POST,
        "/auth/user/key_authorize",
        "login using `authorization_key`"
    description "authenticate using login and authorization key. Response includes user's content preferences"
    param :login, String, required: true
    param :authorization_key, String, required: true
    def key_authorize
      @resource = nil
      @resource = resource_class.find_for_database_authentication(login: params[:login])

      if @resource.present? && @resource.authorization_key == params[:authorization_key]
        create_resource_session!
      else
        render_create_error_bad_credentials
      end
    end

    private

    def create_resource_session!
      # create client id
      @client_id = SecureRandom.urlsafe_base64(nil, false)
      @token     = SecureRandom.urlsafe_base64(nil, false)

      @resource.tokens[@client_id] = {
        token: BCrypt::Password.create(@token),
        expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
      }
      @resource.save

      sign_in(:user, @resource, store: false, bypass: false)

      yield if block_given?

      render_create_success
    end

    def render_create_success
      if @resource.tutor? || @resource.tutor_familiar?
        render :nothing => true, :status => 403
      else
        render json: {
          data: UserSerializer.new(@resource)
        }
      end
    end
  end
end
