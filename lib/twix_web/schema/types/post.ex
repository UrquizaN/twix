defmodule TwixWeb.Schema.Types.Post do
  use Absinthe.Schema.Notation

  @desc "Post"
  object :post do
    @desc "Id"
    field :id, non_null(:id)
    @desc "Texto"
    field :text, non_null(:string)
    @desc "Likes"
    field :likes, non_null(:integer)
  end

  @desc "Input para criar um post"
  input_object :create_post_input do
    @desc "Texto"
    field :text, non_null(:string)
    @desc "Id do usuário"
    field :user_id, non_null(:id)
  end
end
