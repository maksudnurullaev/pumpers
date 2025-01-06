defmodule Unless do
  def fun_unless(clause, do: expression) do
    if(!clause, do: expression)
  end

  defmacro macro_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end

  defmacro initialize_to_char_count(variables) do
    Enum.map(variables, fn name ->
      var = Macro.var(name, nil)
      length = name |> Atom.to_string() |> String.length()

      quote do
        unquote(var) = unquote(length)
      end
    end)
  end

  def run do
    initialize_to_char_count([:red, :green, :yellow])
    [red, green, yellow]
  end
end
