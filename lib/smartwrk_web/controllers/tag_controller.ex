defmodule SmartwrkWeb.TagController do
  use SmartwrkWeb, :controller

  def tag(conn, _params) do
    render(conn, :tag)
  end
end
