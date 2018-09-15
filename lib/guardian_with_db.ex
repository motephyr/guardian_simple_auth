defmodule GuardianSimpleAuth.GuardianWithDb do
  use Guardian, otp_app: Application.get_env(:guardian_simple_auth, :otp_app)

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  # def subject_for_token(_, _) do
  #   {:error, :reason_for_error}
  # end

  def resource_from_claims(claims) do
    schema =
      if is_nil(claims["user_schema"]),
        do: Application.get_env(:guardian_simple_auth, :user_schema),
        else: String.to_existing_atom("Elixir.#{claims["user_schema"]}")

    {:ok, Application.get_env(:guardian_simple_auth, :repo).get(schema, claims["sub"])}
  end

  # def resource_from_claims(_claims) do
  #   {:error, :reason_for_error}
  # end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
