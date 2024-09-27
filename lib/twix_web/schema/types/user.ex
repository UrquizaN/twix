defmodule TwixWeb.Schema.Types.User do
  use Absinthe.Schema.Notation
  alias TwixWeb.Resolvers.User, as: UserResolver

  @desc "Usuário"
  object :user do
    @desc "Id"
    field :id, non_null(:id)
    @desc "Apelido"
    field :nickname, non_null(:string)
    @desc "Idade"
    field :age, non_null(:integer)
    @desc "Email"
    field :email, non_null(:string)
    @desc "Posts"
    field :posts, list_of(:post) do
      arg :page, :integer, default_value: 1
      arg :page_size, :integer, default_value: 10

      resolve &UserResolver.get_posts/3
    end

    @desc "Seguidores"
    field :followers, list_of(:follower)
    @desc "Seguindo"
    field :following, list_of(:following)
  end

  @desc "Seguidor"
  object :follower do
    @desc "Seguidor"
    field :follower, non_null(:user)
    @desc "Id"
    field :follower_id, non_null(:id)
  end

  @desc "Seguindo"
  object :following do
    @desc "Seguindo"
    field :following, non_null(:user)
    @desc "Id"
    field :following_id, non_null(:id)
  end

  @desc "Resposta de seguir"
  object :follow_response do
    @desc "Id"
    field :following_id, non_null(:id)
    @desc "Id "
    field :follower_id, non_null(:id)
  end

  input_object :create_user_input do
    @desc "Apelido"
    field :nickname, non_null(:string)
    @desc "Email"
    field :email, non_null(:string)
    @desc "Idade"
    field :age, non_null(:integer)
  end

  input_object :update_user_input do
    @desc "Id do usuário"
    field :id, non_null(:id)
    @desc "Apelido"
    field :nickname, :string
    @desc "Email"
    field :email, :string
    @desc "Idade"
    field :age, :integer
  end

  input_object :follow_input do
    @desc "Id do usuário"
    field :user_id, non_null(:id)
    @desc "Id do seguidor"
    field :follower_id, non_null(:id)
  end
end
