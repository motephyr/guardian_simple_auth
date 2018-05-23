
defmodule GuardianSimpleAuth.Session do
  alias Dresser.Repo

  def authenticate(model, %{"email" => email, "password" => password}) do
    user = Repo.get_by(model, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(model, password) do
    case model do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, model.password_hash)
    end
  end
end