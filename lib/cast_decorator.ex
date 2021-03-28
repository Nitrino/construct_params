defmodule ConstructParams.CastDecorator do
  @moduledoc """
  The macro allows casting the incoming controller parameters.

  This macro uses the [construct](https://hexdocs.pm/construct/readme.html) library for params validation.

  In case of a successful casting, the controller action params are replaced with the casted data.
  Otherwise the `FallbackController` is called with `{:error, errors}` parameters.

  ## Examples

      defmodule MyApp.MyController do
        use MyApp.CastDecorator

        @decorate cast(MyApp.ConstructCastModule)
        def create(conn, params)
        end
      end
  """

  use Decorator.Define, cast: 1

  def cast(cast_module, body, %{args: [conn, params], module: module}) do
    fallback_module = get_fallback_module(module)

    quote do
      case unquote(cast_module).make(unquote(params), make_map: true) do
        {:ok, casted_params} ->
          unquote(params) = casted_params
          unquote(body)

        {:error, errors} ->
          unquote(fallback_module).call(unquote(conn), {:error, errors})
      end
    end
  end

  defp get_fallback_module(module) do
    module
    |> Module.split()
    |> List.replace_at(-1, "FallbackController")
    |> Module.safe_concat()
  end
end
