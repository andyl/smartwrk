defmodule SmartworksWeb.TagController do
  use SmartworksWeb, :controller

  alias Smartworks.Blog

  def index(conn, _params) do
    render(conn, :index, tags: Blog.all_tags())
  end

  def show(conn, %{"id" => slug}) do
    tag = Blog.get_tag_by_slug!(slug)
    render(conn, :show, tag: tag, posts: Blog.posts_by_tag(tag))
  end
end
