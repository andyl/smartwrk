defmodule Smartworks.Version do
  @moduledoc """
  Exposes the project version baked in at compile time from `mix.exs`.
  """

  @version Mix.Project.config()[:version]

  def current, do: @version
end
