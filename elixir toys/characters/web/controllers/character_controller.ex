defmodule Characters.CharacterController do
  use Characters.Web, :controller

  alias Characters.Character

  def index(conn, _params) do
    struct = %Character{}
    params = %{}
    changeset = Character.changeset(struct, params)
    IO.inspect(render conn, "index.html", name: "Decai", changeset: changeset, conn: conn)
  end


  def create(conn, %{"character" => character} = params) do
    changeset = Character.changeset(%Character{}, character)

    IO.inspect(changeset)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Character Created")
        |> redirect(to: character_path(conn, :index))
      {:error, changeset} ->
        render conn, "index.html", name: "Decai", changeset: changeset, conn: conn
    end
  end
  # def index(conn, _params) do
  #   changeset = Character.changeset{%Character{}, %{}}
  #
  #   render conn, "index.html", name: "Decai", changeset: changeset
  # end
  #
  # def create(conn, %{"character" => character} = params) do
  #
  #   changeset = conn.assigns.user
  #   |> build_assoc(:characters)
  #   |> Character.changeset(character)
  #
  #   IO.inspect(changeset)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _topic} ->
  #       conn
  #       |> put_flash(:info, "Character Created")
  #       |> redirect(to: page_path(conn, :index))
  #     {:error, changeset} ->
  #       render conn, "index.html", changeset: changeset
  #   end
  # end
end
