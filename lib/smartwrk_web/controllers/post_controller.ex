defmodule SmartwrkWeb.PostController do
  use SmartwrkWeb, :controller

  alias Smartwrk.Blog

  def index(conn, _params) do
    render(conn, :index, posts: Blog.all_posts())
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, post: Blog.get_post_by_id!(id))
  end
end
