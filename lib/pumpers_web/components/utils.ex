defmodule PumpersWeb.Utils do
  def get_limit_offset(%{"page" => page, "page_size" => page_size, "count" => count})
      when is_bitstring(page) and is_bitstring(page_size) and is_bitstring(count) do
    get_limit_offset(%{
      "page" => String.to_integer(page),
      "page_size" => String.to_integer(page_size),
      "count" => String.to_integer(count)
    })
  end

  def get_limit_offset(%{"page" => page, "page_size" => page_size, "count" => count})
      when is_integer(page) and is_integer(page_size) and page > 0 and page_size > 0 do
    offset = (page - 1) * page_size
    limit = page_size

    has_rem = rem(count, page_size) > 0
    pages = div(count, page_size) + ((has_rem && 1) || 0)

    {limit, offset, pages}
  end

  # def normalize_toolbar(
  #       %{
  #         "page" => page,
  #         "pages" => pages,
  #         "page_size" => page_size,
  #         "search_path" => search_path,
  #         "search_text" => search_text
  #       } = toolbar
  #     ) do
  #   IO.puts("XXX5: #{inspect(toolbar)}")
  #   toolbar = Map.put(toolbar, "page", String.to_integer(page))
  #   toolbar = Map.put(toolbar, "pages", String.to_integer(pages))
  #   toolbar = Map.put(toolbar, "page_size", String.to_integer(page_size))
  #   search_path = (string_nil_or_empty?(search_path) && nil) || String.trim(search_path)
  #   search_text = (string_nil_or_empty?(search_text) && nil) || String.trim(search_text)
  #   toolbar = Map.put(toolbar, "search_path", search_path)
  #   toolbar = Map.put(toolbar, "search_text", search_text)

  #   toolbar
  # end

  def string_nil_or_empty?(str) do
    str |> String.trim() |> String.length() == 0
  end

  @schemes ["http", "https"]
  def is_valid_url?(url) do
    uri = URI.parse(url)
    if uri.scheme != nil && uri.scheme in @schemes && uri.host =~ ".", do: {:ok, uri}, else: {:error, uri}
  end
end
