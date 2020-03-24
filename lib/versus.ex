defmodule Versus do
  @moduledoc false

  def scrub(obj) when is_map(obj) do
    obj
    |> Enum.map(fn {key, val} ->
      case key do
        :name -> {key, conceal(val)}
        :email -> {key, conceal(val)}
        :username -> {key, conceal(val)}
        other -> {key, scrub(val)}
      end
    end)
    |> Enum.into(%{})
  end

  def scrub(list) when is_list(list) do
    Enum.map(list, &scrub/1)
  end

  def scrub(data), do: data

  def conceal(str) do
    case String.contains?(str, "@") do
      true -> conceal_email(str)
      false -> conceal_text(str)
    end
  end

  defp conceal_email(email) do
    [_name, domain] = String.split(email, "@")
    "******@#{domain}"
  end

  defp conceal_text(text), do: "******"
end
