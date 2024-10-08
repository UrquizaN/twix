defmodule Twix do
  @moduledoc """
  Twix keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Twix.Posts
  alias Twix.Users

  defdelegate create_post(params), to: Posts.Create, as: :call
  defdelegate add_like_to_post(id), to: Posts.AddLike, as: :call

  defdelegate create_user(params), to: Users.Create, as: :call
  defdelegate get_user(id), to: Users.Get, as: :call
  defdelegate update_user(params), to: Users.Update, as: :call
  defdelegate follow(user_id, follower_id), to: Users.Follow, as: :call

  defdelegate get_user_posts(user, page, page_size), to: Posts.Get, as: :call
end
