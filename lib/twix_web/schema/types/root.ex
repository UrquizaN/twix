defmodule TwixWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  import_types TwixWeb.Schema.Types.User
  import_types TwixWeb.Schema.Types.Post

  alias Twix.Repo
  alias Twix.Users.User
  alias Crudry.Middlewares.TranslateErrors
  alias TwixWeb.Resolvers.User, as: UserResolver
  alias TwixWeb.Resolvers.Post, as: PostResolver

  object :root_query do
    field :user, type: :user do
      arg :id, non_null(:id)

      resolve &UserResolver.get/2
    end

    field :users, type: list_of(:user) do
      resolve fn _params, _context ->
        {:ok, Repo.all(User)}
      end
    end
  end

  object :root_mutation do
    field :create_user, type: :user do
      arg :input, type: non_null(:create_user_input)

      resolve &UserResolver.create/2
      middleware TranslateErrors
    end

    field :update_user, type: :user do
      arg :input, type: non_null(:update_user_input)

      resolve &UserResolver.update/2
      middleware TranslateErrors
    end

    field :create_post, type: :post do
      arg :input, type: non_null(:create_post_input)

      resolve &PostResolver.create/2
      middleware TranslateErrors
    end

    field :add_like_to_post, type: :post do
      arg :id, type: non_null(:id)

      resolve &PostResolver.add_like/2
    end

    field :follow, type: :follow_response do
      arg :input, type: non_null(:follow_input)

      resolve &UserResolver.follow/2
      middleware TranslateErrors
    end
  end

  object :root_subscription do
    field :new_follow, :follow_response do
      config fn _args, _context ->
        {:ok, topic: "new_follow_topic"}
      end

      trigger :follow, topic: fn _context -> "new_follow_topic" end
    end
  end
end
