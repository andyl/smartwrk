defmodule SmartwrkWeb.PostController do
  use SmartwrkWeb, :controller

  def post(conn, _params) do
    render(conn, :post)
  end
end
