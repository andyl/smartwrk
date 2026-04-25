defmodule Smartworks.Blog do
  alias Smartworks.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:smartworks, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def all_posts, do: @posts
  def all_tags, do: @tags
  def get_post_by_id!(id), do: Enum.find(@posts, &(&1.id == id)) || raise("no post #{id}")

  def tag_slug(tag) do
    tag
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "-")
    |> String.trim("-")
  end

  def get_tag_by_slug!(slug) do
    Enum.find(@tags, &(tag_slug(&1) == slug)) || raise("no tag #{slug}")
  end

  def posts_by_tag(tag), do: Enum.filter(@posts, &(tag in &1.tags))
end
