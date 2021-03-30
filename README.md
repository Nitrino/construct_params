# ConstructParams

Casting the incoming controller parameters

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `construct_params` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:construct_params, "~> 0.2.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/construct_params](https://hexdocs.pm/construct_params).

## Usage

ConstractParams provides a macro for controller params casting.  

1. First, you need to create a module that cast the input parameters.  
For casting uses [construct](https://hexdocs.pm/construct/readme.html) library.

```elixir
defmodule MyAppWeb.Api.Requests.Users.Index do
  use Construct do
    field(:next_page, :string, default: nil)
    field(:limit, :integer, default: nil)
    field(:user_id, :integer, default: nil)
  end
end
```

2. Then add a decorator to the action with the parameters you want to cast.

```elixir
defmodule MyAppWeb.Api.UsersController do
  use ConstructParams.CastDecorator

  @decorate cast(MyAppWeb.Api.Requests.Users.Index)
  def index(conn, params) do
  end
end
```

In case of a successful casting, the controller action params are replaced with the casted data.  
Otherwise the appropriate `FallbackController` is called with `{:error, errors}` parameters.
