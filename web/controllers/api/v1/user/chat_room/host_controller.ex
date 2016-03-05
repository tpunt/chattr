defmodule Chattr.Api.V1.User.ChatRoom.HostController do
  use Chattr.Web, :controller

  alias Chattr.Api.V1.User.ChatRoom.Host

  plug :scrub_params, "host" when action in [:create, :update]

  def index(conn, _params) do
    hosts = Repo.all(Host)
    render(conn, "index.json", hosts: hosts)
  end

  def create(conn, %{"host" => host_params, "chatroom_id" => chatroom_id, "user_id" => user_id}) do
    changeset = Host.changeset(%Host{}, Map.put(host_params, "chatroom_id", chatroom_id))

    case Repo.insert(changeset) do
      {:ok, host} ->
        conn
        |> put_status(:created)
        # |> put_resp_header("location", host_path(conn, :show, host))
        |> render("show.json", host: host)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    host = Repo.get!(Host, id)
    render(conn, "show.json", host: host)
  end

  def update(conn, %{"id" => id, "host" => host_params}) do
    host = Repo.get!(Host, id)
    changeset = Host.changeset(host, host_params)

    case Repo.update(changeset) do
      {:ok, host} ->
        render(conn, "show.json", host: host)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    host = Repo.get!(Host, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(host)

    send_resp(conn, :no_content, "")
  end
end
