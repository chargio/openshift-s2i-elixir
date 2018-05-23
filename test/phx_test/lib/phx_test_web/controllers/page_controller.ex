defmodule PhxTestWeb.PageController do
  use PhxTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
