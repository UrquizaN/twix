defmodule Twix.Posts.Get do
  alias Twix.Posts.Post
  alias Twix.Repo

  import Ecto.Query

  def call(user, page, page_size) do
    query =
      from p in Post,
        where: p.user_id == ^user.id,
        order_by: [desc: p.id],
        offset: (^page - 1) * ^page_size,
        limit: ^page_size

    {:ok, Repo.all(query)}
  end
end
