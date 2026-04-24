defmodule SmartwrkWeb.TagHTML do
  @moduledoc """
  This module contains pages rendered by TagController.

  See the `tag_html` directory for all templates available.
  """
  use SmartwrkWeb, :html

  embed_templates "tag_html/*"
end
