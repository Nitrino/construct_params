defmodule ConstructParams.ErrorView do
  @doc """
  Format construct error params.

  ## Examples

      iex> format_errors(%{

      })
  """
  def format_errors(errors) do
    Enum.reduce(errors, %{}, fn {key, value}, acc ->
      error = get_error(key, value, [])
      Map.put(acc, error.main_key, %{message: error.message, path: error.path})
    end)
  end

  defp get_error(key, value, acc) when is_atom(value) do
    path_list = Enum.reverse([key | acc])

    %{
      path: "/" <> Enum.join(path_list, "/"),
      message: error_message(key, value),
      main_key: key
    }
  end

  defp get_error(key, value, acc) when is_map(value) do
    [{new_key, new_value}] = Map.to_list(value)
    get_error(new_key, new_value, [key | acc])
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
