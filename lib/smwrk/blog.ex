defmodule Smwrk.Blog do
  alias Smwrk.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:smwrk, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def all_posts, do: @posts
  def all_tags, do: @tags
  def get_post_by_id!(id), do: Enum.find(@posts, &(&1.id == id)) || raise("no post #{id}")
end
