defmodule ConstructParams.CastDecorator do
  @moduledoc """
  The macro allows casting the incoming controller parameters.

  This macro uses the [construct](https://hexdocs.pm/construct/readme.html) library for params validation.

  In case of a successful casting, the controller action params are replaced with the casted data.
  Otherwise the `FallbackController` is called with `{:error, errors}` parameters.

  ## Examples

      defmodule MyApp.MyController do
        use ConstructParams.CastDecorator

        @decorate cast(MyApp.ConstructCastModule)
        def create(conn, params)
        end
      end
  """

  use Decorator.Define, cast: 2

  def cast(cast_module, options, body, %{args: [conn, params], module: module}) do
    fallback_module = get_fallback_module(module)

    quote do
      origin_params =
        if Keyword.get(unquote(options), :with_root, false) do
          %{"root" => unquote(params)}
        else
          unquote(params)
        end

      case unquote(cast_module).make(origin_params, make_map: true) do
        {:ok, casted_params} ->
          unquote(params) =
            if Keyword.get(unquote(options), :with_root, false) do
              casted_params[:root]
            else
              casted_params
            end

          unquote(body)

        {:error, errors} ->
          errors =
            if Keyword.get(unquote(options), :with_root, false) do
              errors[:root]
            else
              errors
            end

          unquote(fallback_module).call(unquote(conn), {:error, :invalid_params, errors})
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
