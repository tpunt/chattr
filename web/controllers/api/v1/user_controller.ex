defmodule Chattr.Api.V1.UserController do
  use Chattr.Web, :controller

  alias Chattr.Api.V1.User

  # plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"authenticator" => "google"} = params) do
    changeset = User.changeset(%User{}, params)

    case User.get_user_by_user_id(changeset.changes.user_id) do
      nil ->
        case Repo.insert(changeset) do
          {:ok, user} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", user_path(conn, :show, user))
            |> render("show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
        end
      user ->
        conn
        |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case User.get_user_by_user_id(id) do
      nil ->
        user = Repo.get!(User, id)
        render(conn, "show.json", user: user)
      user ->
        render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Chattr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
