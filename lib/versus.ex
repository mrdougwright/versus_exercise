defmodule Versus do
  @moduledoc false

  def scrub(obj) when is_map(obj) do
    obj
    |> Enum.map(fn {key, val} ->
      case key do
        :email -> {key, conceal_email(val)}
        :name -> {key, conceal_text(val)}
        :password -> {key, conceal_text(val)}
        :username -> {key, conceal_text(val)}
        other -> {key, scrub(val)}
      end
    end)
    |> Enum.into(%{})
  end

  def scrub(list) when is_list(list) do
    Enum.map(list, &scrub/1)
  end

  def scrub(data), do: data

  defp conceal_email(email) do
    [_name, domain] = String.split(email, "@")
    "******@#{domain}"
  end

  defp conceal_text(text), do: "******"
end
