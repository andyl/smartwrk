defmodule SmwrkWeb.PageController do
  use SmwrkWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
