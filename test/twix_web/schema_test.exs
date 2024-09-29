defmodule TwixWeb.SchemaTest do
  use TwixWeb.ConnCase, async: true

  describe "user query" do
    @get_user_query """
    query user($id: ID!){
      user(id: $id) {
        nickname
        email
      }
    }
    """

    test "returns a user", %{conn: conn} do
      user_params = %{nickname: "jhondoe", email: "jhondoe@email.com", age: 30}

      {:ok, user} = Twix.create_user(user_params)

      expected_response = %{
        "data" => %{"user" => %{"email" => "jhondoe@email.com", "nickname" => "jhondoe"}}
      }

      response =
        conn
        |> post("/api/graphql", %{query: @get_user_query, variables: %{"id" => user.id}})
        |> json_response(200)

      assert expected_response == response
    end

    test "returns not found error", %{conn: conn} do
      response =
        conn
        |> post("/api/graphql", %{query: @get_user_query, variables: %{"id" => 99}})
        |> json_response(200)

      expected_response = %{
        "data" => %{"user" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "not_found",
            "path" => ["user"]
          }
        ]
      }

      assert expected_response == response
    end
  end

  describe "user mutation" do
    @create_user_mutation """
    mutation createUser($input: CreateUserInput!) {
      createUser(input: $input) {
        nickname
        email
      }
    }
    """

    test "creates an user", %{conn: conn} do
      user_params = %{nickname: "jhondoe", email: "jhondoe@email.com", age: 30}

      response =
        conn
        |> post("/api/graphql", %{
          query: @create_user_mutation,
          variables: %{"input" => user_params}
        })
        |> json_response(200)

      assert %{
               "data" => %{
                 "createUser" => %{"email" => "jhondoe@email.com", "nickname" => "jhondoe"}
               }
             } == response
    end
  end

  describe "subscriptions" do
    test "new follow", %{socket: socket} do
      user_params_1 = %{nickname: "jhondoe", email: "jhondoe@email.com", age: 30}
      user_params_2 = %{nickname: "jhondoe2", email: "jhondoe2@email.com", age: 30}

      {:ok, user_1} = Twix.create_user(user_params_1)
      {:ok, user_2} = Twix.create_user(user_params_2)

      mutation = """
      mutation follow($input: FollowInput!) {
        follow(input: $input) {
          followerId
          followingId
        }
      }
      """

      subscription = """
      subscription {
        newFollow {
          followerId
          followingId
        }
      }
      """

      # SETUP SUBSCRIPTION
      socket_ref = push_doc(socket, subscription)
      assert_reply socket_ref, :ok, %{subscriptionId: subscription_id}

      # SETUP MUTATION
      socket_ref =
        push_doc(socket, mutation,
          variables: %{
            "input" => %{
              user_id: user_1.id,
              follower_id: user_2.id
            }
          }
        )

      assert_reply socket_ref, :ok, mutation_response

      expected_response = %{
        data: %{"follow" => %{"followerId" => "#{user_2.id}", "followingId" => "#{user_1.id}"}}
      }

      assert mutation_response == expected_response

      assert_push "subscription:data", subscription_response

      assert subscription_response == %{
               result: %{
                 data: %{
                   "newFollow" => %{
                     "followerId" => "#{user_2.id}",
                     "followingId" => "#{user_1.id}"
                   }
                 }
               },
               subscriptionId: subscription_id
             }
    end
  end
end
