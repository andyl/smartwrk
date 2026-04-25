defmodule Mix.Tasks.Smartworks.Export do
  use Mix.Task

  @shortdoc "Export the site to @output"
  @output "docs"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    File.rm_rf!(@output)
    File.mkdir_p!(@output)

    # 1. Copy compiled assets (digested or not, your call)
    copy_static_assets()

    # 2. Render every exportable route
    for path <- exportable_paths() do
      html = render(path)
      write(path, html)
    end

    # 3. Write sitemap
    File.write!(Path.join(@output, "sitemap.xml"), sitemap(exportable_paths()))

    Mix.shell().info("Exported to #{@output}")
  end

  defp exportable_paths do
    static_paths = ["/", "/about", "/posts", "/tags"]
    post_paths = Enum.map(Smartworks.Blog.all_posts(), &"/posts/#{&1.id}")
    tag_paths = Enum.map(Smartworks.Blog.all_tags(), &"/tags/#{Smartworks.Blog.tag_slug(&1)}")
    static_paths ++ post_paths ++ tag_paths
  end

  defp render(path) do
    Phoenix.ConnTest.build_conn()
    |> Phoenix.ConnTest.dispatch(SmartworksWeb.Endpoint, :get, path)
    |> Phoenix.ConnTest.html_response(200)
  end

  defp write("/", html), do: File.write!(Path.join(@output, "index.html"), html)

  defp write(path, html) do
    dir = Path.join(@output, String.trim_leading(path, "/"))
    File.mkdir_p!(dir)
    File.write!(Path.join(dir, "index.html"), html)
  end

  defp copy_static_assets do
    src = Application.app_dir(:smartworks, "priv/static")
    File.cp_r!(src, @output)
  end

  defp sitemap(paths) do
    base = "https://yoursite.com"
    urls = Enum.map_join(paths, "\n", &"<url><loc>#{base}#{&1}</loc></url>")

    ~s(<?xml version="1.0"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n#{urls}\n</urlset>)
  end
end
