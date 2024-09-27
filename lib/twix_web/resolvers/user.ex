defmodule TwixWeb.Resolvers.User do
  def get(%{id: id}, _context), do: Twix.get_user(id)
  def create(%{input: params}, _context), do: Twix.create_user(params)
  def update(%{input: params}, _context), do: Twix.update_user(params)

  def follow(%{input: %{user_id: user_id, follower_id: follower_id}}, _context) do
    # with {:ok, result} <- Twix.follow(user_id, follower_id) do
    #   Absinthe.Subscription.publish(TwixWeb.Endpoint, result, new_follow: "new_follow_topic")
    #   {:ok, result}
    # end

    Twix.follow(user_id, follower_id)
  end

  def get_posts(user, %{page: page, page_size: page_size}, _context),
    do: Twix.get_user_posts(user, page, page_size)
end
