defmodule Characters.PageController do
  use Characters.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", name: "Decai"
  end
end
