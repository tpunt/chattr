defmodule Chattr.Api.V1.GoogleAuth do
  use Chattr.Web, :model

  schema "tokenaccess" do
    field :authenticator, :string
    field :user_id, :integer

    timestamps
  end

  @required_fields ~w(token)
  @optional_fields ~w()

  @google_auth_api "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token="

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    # |> cast(params, @required_fields, @optional_fields)
    |> authenticate
  end

  defp authenticate(changeset) do
    request = HTTPoison.get("#{@google_auth_api}#{changeset.changes.token}")

    case request do
      {:ok, %HTTPoison.Response{body: body}} ->
        case return = Poison.Parser.parse!(body) do
          %{"aud" => aud, "email" => email, "name" => name, "sub" => sub} ->
            # if changeset.changes.client_id != aud do
              # {:error, "aud to client_d value mismatch"}
            # else
              changeset
              |> put_change(:email, email)
              |> put_change(:name, name)
              |> put_change(:user_id, sub)
            # end
          _ ->
            {:error, "No results"}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
