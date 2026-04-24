defmodule SmartwrkWeb.PageController do
  use SmartwrkWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
