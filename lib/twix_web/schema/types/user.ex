defmodule TwixWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

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
    field :posts, list_of(:post)
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
end
