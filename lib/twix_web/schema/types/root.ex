defmodule TwixWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  import_types TwixWeb.Schema.Types.User

  alias TwixWeb.Resolvers.User, as: UserResolver

  object :root_query do
    field :user, type: :user do
      arg :id, non_null(:id)

      resolve &UserResolver.get/2
    end
  end

  object :root_mutation do
    field :create_user, type: :user do
      arg :input, type: non_null(:create_user_input)

      resolve &UserResolver.create/2
    end

    field :update_user, type: :user do
      arg :input, type: non_null(:update_user_input)

      resolve &UserResolver.update/2
    end
  end
end
