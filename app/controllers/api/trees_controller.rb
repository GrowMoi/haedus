module Api
  class TreesController < BaseController
    respond_to :json

    expose(:user_tree) {
      user = User.find_by_username(params[:username])
      if user
        TreeService::UserTreeFetcher.new user
      end
    }

    api :GET,
        "/tree",
        "returns tree for current user"
    example %q{
      { "tree": { "root":
          { "id": 1,
            "title": "Neurona 1",
            "state": "florecida",
            "children": [
              { "id": 2,
                "title": "Neurona 2",
                "state": "descubierta",
                "children": [
                  { "id": 3,
                    "title": "Neurona 3",
                    "children": [] }
                ] },
              { "id": 4,
                "title": "Neurona 4",
                "state": "descubierta",
                "children": []}
            ]
          }
        },
        "meta": { "depth": 2 }
      }
    }
    param :username, String, required: true

    def show
      if user_tree
        respond_with tree: { root: user_tree.root },
                     meta: { depth: user_tree.depth }
      else
        render nothing: true,
                status: 404
      end
    end
  end
end
