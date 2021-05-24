defmodule ConstructParams.ErrorHelper do
  @moduledoc """
  Helpers for rendering casting errors
  """

  @doc """
  Format construct error params.

  ## Examples

      iex> format_errors(%{user_id: :invalid})
      %{user_id: %{message: "Invalid field type", path: "/user_id"}}

      iex> format_errors(%{user: %{custom_data: :missing, metadata: %{avatar_url: :invalid}}})
      %{
        custom_data: %{message: "Missing field", path: "/user/custom_data"},
        avatar_url: %{message: "Invalid field type", path: "/user/metadata/avatar_url"}
      }
  """
  def format_errors(errors) do
    errors
    |> Map.to_list()
    |> format_errors([], %{})
  end

  defp format_errors([], _path, acc), do: acc

  defp format_errors([{key, value} | errors], path, acc) when is_atom(value) do
    format_errors(errors, path, put_error(acc, key, value, path))
  end

  defp format_errors([{key, value} | errors], path, acc) when is_map(value) do
    format_errors(Map.to_list(value), [key | path], acc)
  end

  defp put_error(acc, key, value, path) do
    path =
      [key | path]
      |> Enum.reverse()
      |> Enum.join("/")

    error = %{
      path: "/" <> path,
      message: error_message(key, value)
    }

    Map.put(acc, key, error)
  end

  defp error_message(_key, :missing) do
    "Missing field"
  end

  defp error_message(_key, :invalid) do
    "Invalid field type"
  end

  defp error_message(_key, :invalid_record_file) do
    "Invalid record file"
  end
end
