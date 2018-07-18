module Api
  class UsersController < BaseController
    before_action :authenticate_user!

    respond_to :json

    expose(:user)

    api :GET,
        "/users/:id/profile",
        "user's profile"
    param :id, Integer, required: true
    example %q{
      { "age": "23",
        "birthday": "19/23/2000",
        "name": "Jhon Doe"
        "city": "Quito",
        "country": "Ecuador",
        "school": "Alejandrino",
        "email": "example@gmail.com",
        "id": "2",
        "last_contents_learnt": [
          "id": "12",
          "media": ["htttp://something.com"]
        ]
      }
    }
    def profile
      respond_with(
        user,
        serializer: Api::UserProfileSerializer
      )
    end

    expose(:search_results) {
      users_results = UserSearch.new(q:params[:query], id:current_user.id).results
      Kaminari.paginate_array(users_results)
        .page(params[:page])
        .per(8)
    }

    api :GET,
        "/users/search",
        "returns search from query"
    param :page, Integer
    param :query, String
    def search
      respond_with(
        search_results,
        meta: {
          total_items: search_results.total_count
        },
        serializer: Api::SearchUsersSerializer
      )
    end

    expose(:all_tasks) {
      results = current_user.all_tasks
      Kaminari.paginate_array(results)
        .page(params[:page])
        .per(4)
    }

    api :GET,
        "/users/content_tasks",
        "returns all contents saved by user"
    param :page, Integer
    def content_tasks
      respond_with(
        all_tasks,
        meta: {
          total_items: all_tasks.total_count
        },
        serializer: Api::ContentTasksSerializer
      )
    end

    expose(:all_notes) {
      results = current_user.content_notes.order(created_at: :desc)
      Kaminari.paginate_array(results)
        .page(params[:page])
        .per(2)
    }

    api :GET,
        "/users/content_notes",
        "returns all notes saved by user"
    param :page, Integer
    def content_notes
      respond_with(
        all_notes,
        meta: {
          total_items: all_notes.total_count
        },
        serializer: Api::ContentNotesSerializer
      )
    end

    expose(:all_favorites) {
      results = current_user.all_favorites
      Kaminari.paginate_array(results)
        .page(params[:page])
        .per(4)
    }

    api :GET,
        "/users/content_favorites",
        "returns all content-favorites saved by user"
    param :page, Integer
    def content_favorites
      respond_with(
        all_favorites,
        meta: {
          total_items: all_favorites.total_count
        },
        serializer: Api::ContentTasksSerializer
      )
    end

    api :POST,
      "/api/users/shared_contents",
      "Send a email with an screenshot(Shared content)"
    param :email, String
    param :public_url, String
    param :image_url, String

    def shared_contents
      areValidParams = !params[:email].blank? && !params[:public_url].blank? && !params[:image_url].blank?
      if (areValidParams)
        UserMailer.shared_content(
          current_user.username,
          params[:email],
          params[:image_url],
          params[:public_url]).deliver_now
        render nothing: true,
                status: :accepted
      else
        render text: "invalid params",
              status: :unprocessable_entity
      end
    end

  end
end
