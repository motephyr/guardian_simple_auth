
defmodule GuardianSimpleAuth.Guardian do
  use Guardian, otp_app: :dresser
  
    alias Dresser.Coherence.User
    alias Dresser.Repo
    def subject_for_token(resource, _claims) do
      {:ok, to_string(resource.id)}
    end
  
    def subject_for_token(_, _) do            
      {:error, :reason_for_error}
    end

    def resource_from_claims(claims) do            
      {:ok, Repo.get(User, claims["sub"])}
    end
    def resource_from_claims(_claims) do          
      {:error, :reason_for_error}
    end

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
