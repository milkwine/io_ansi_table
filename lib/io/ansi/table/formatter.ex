
# Based on the book "Programming Elixir" by Dave Thomas.

defmodule IO.ANSI.Table.Formatter do
  @moduledoc """
  Prints a table to STDOUT applying a table style to a list of key-value
  collections.
  """

  alias IO.ANSI.Table.{Config, Formatter.Helper, Style}

  @type collection :: map | Keyword.t
  @type collection_key :: String.t | atom | charlist
  @type column :: [String.t]
  @type column_width :: non_neg_integer
  @type row :: [String.t]

  Mix.Project.config[:config_path] |> Mix.Config.read! |> Mix.Config.persist
  @external_resource Path.expand Mix.Project.config[:config_path]
  @app               Mix.Project.config[:app]
  @max_width_range   Application.get_env @app, :max_width_range
  @lower_max_width   @max_width_range.first
  @upper_max_width   @max_width_range.last

  @doc """
  Takes a list of key-value `collections`, the (maximum) number of
  `collections` to format, whether to ring the `bell`, a table `style` and
  up to six `options`:

    - `headers`      - to identify each column (keys)
    - `key headers`  - to sort the `collections` on
    - `header fixes` - to alter the `headers`
    - `align attrs`  - to align column elements
    - `margins`      - to position the table
    - `max width`    - to cap column widths

  Prints a table to STDOUT of the values in each selected `collection`.
  The columns are identified by successive `headers` in order.

  We calculate the width of each column to fit the longest element
  in that column, also considering the `header` itself. However, the
  `max width` option prevails.

  If the number of `collections` given is positive, we format
  the first _n_ `collections` in the list, once sorted. If negative,
  the last _n_ ones.

  ## Parameters

    - `collections` - list of collections (maps or keywords)
    - `count`       - number of collections to format (integer)
    - `bell?`       - ring the bell? (boolean)
    - `style`       - table style (atom)
    - `options`     - up to six options as described (keyword)

  ## Options

    - `:headers`      - defaults to config for `:headers` (list)
    - `:key_headers`  - defaults to config for `:key_headers` (list)
    - `:header_fixes` - defaults to config for `:header_fixes` (map)
    - `:align_attrs`  - defaults to config for `:align_attrs` (map)
    - `:margins`      - defaults to config for `:margins` (keyword)
    - `:max_width`    - defaults to config for `:max_width` (non neg integer)

  ## Table styles

  #{Style.texts "  - `&style`&filler - &note\n"}

  ## Examples

      alias IO.ANSI.Table.Formatter
      people = [
        %{name: "Mike", likes: "ski, arts", date_of_birth: "1992-04-15"},
        %{name: "Mary", likes: "reading"  , date_of_birth: "1985-07-11"},
        %{name: "Ray" , likes: "cycling"  , date_of_birth: "1977-08-28"}
      ]
      Formatter.print_table(
        people, 3, true, :dark,
        headers: [:name, :date_of_birth, :likes],
        key_headers: [:date_of_birth],
        header_fixes: %{~r[ of ]i => " of "},
        align_attrs: %{date_of_birth: :right},
        margins: [top: 2, bottom: 2, left: 2]
      )
  ## ![print_table_people](images/print_table_people.png)
      iex> alias ExUnit.CaptureIO
      iex> alias IO.ANSI.Table.Formatter
      iex> people = [
      ...>   %{name: "Mike", likes: "ski, arts", date_of_birth: "1992-04-15"},
      ...>   %{name: "Mary", likes: "reading"  , date_of_birth: "1985-07-11"},
      ...>   %{name: "Ray" , likes: "cycling"  , date_of_birth: "1977-08-28"}
      ...> ]
      iex> CaptureIO.capture_io fn ->
      ...>   Formatter.print_table(
      ...>     people, 3, false, :dashed,
      ...>     headers: [:name, :date_of_birth, :likes],
      ...>     key_headers: [:date_of_birth],
      ...>     header_fixes: %{~r[ of ]i => " of "},
      ...>     align_attrs: %{date_of_birth: :right},
      ...>     margins: [top: 0, bottom: 0, left: 0]
      ...>   )
      ...> end
      \"""
      +------+---------------+-----------+
      | Name | Date of Birth | Likes     |
      +------+---------------+-----------+
      | Ray  |    1977-08-28 | cycling   |
      | Mary |    1985-07-11 | reading   |
      | Mike |    1992-04-15 | ski, arts |
      +------+---------------+-----------+
      \"""
  """
  @spec print_table([collection], integer, boolean, Style.t, Keyword.t) ::
    :ok
  def print_table(collections, count, bell?, style, options \\ []) do
    headers = Keyword.get(options, :headers, Config.headers)
    key_headers = Keyword.get(options, :key_headers, Config.key_headers)
    header_fixes = Keyword.get(options, :header_fixes, Config.header_fixes)
    align_attrs = Keyword.get(options, :align_attrs, Config.align_attrs)
    margins = Config.margins Keyword.get(options, :margins)
    max_width = Keyword.get(options, :max_width, Config.max_width)
    collections =
      collections
      |> Stream.map(&take &1, headers) # optional
      |> Enum.sort_by(&key_for &1, key_headers)
      |> Enum.take(count)
    column_widths =
      [Map.new(headers, &{&1, titlecase(&1, header_fixes)}) | collections]
      |> columns(headers)
      |> column_widths(max_width) # => max widths of column values or headers
    rows = rows(collections, headers)
    Helper.print_table(
      rows, headers, key_headers,
      header_fixes, align_attrs, margins, column_widths, style, bell?
    )
  end

  @spec take(collection, [collection_key]) :: collection
  defp take(collection, headers) when is_map(collection) do
    Map.take collection, headers
  end
  defp take(collection, headers) when is_list(collection) do
    Keyword.take collection, headers
  end

  @doc """
  Takes a key-value `collection` and a list of `keys`.

  Returns a sort key for the `collection`.

  ## Examples

      iex> alias IO.ANSI.Table.Formatter
      iex> collection = [one: '1', two: "2", three: 3.0, four: 4]
      iex> keys = [:three, :one, :four]
      iex> Formatter.key_for(collection, keys)
      "3.014"
  """
  @spec key_for(collection, [collection_key]) :: String.t
  def key_for(collection, keys) do
    Enum.map_join keys, &collection[&1]
  end

  @doc """
  Takes a list of key-value `collections` and a list of `keys`.

  Returns a list of columns, each column being a list of string values
  selected from each `collection` on a given `key` and repeatedly on
  successive `keys` in order.

  ## Examples

      iex> alias IO.ANSI.Table.Formatter
      iex> list = [
      ...>   %{a: 1, b: 2, c: 3},
      ...>   %{a: 4, b: 5, c: 6}
      ...> ]
      iex> Formatter.columns list, [:c, :a]
      [["3", "6"], ["1", "4"]]

      iex> alias IO.ANSI.Table.Formatter
      iex> list = [
      ...>   %{:one => "1", '2' => 2.0, "3" => :three},
      ...>   %{:one => '4', '2' => "5", "3" => 000006}
      ...> ]
      iex> Formatter.columns list, ["3", :one, '2']
      [["three", "6"], ["1", "4"], ["2.0", "5"]]
  """
  @spec columns([collection], [collection_key]) :: [column]
  def columns(collections, keys) do
    for key <- keys do
      for collection <- collections, do: to_string collection[key]
    end
  end

  @doc """
  Takes a list of key-value `collections` and a list of `keys`.

  Returns a list of rows, each row being a list of string values
  orderly selected on successive `keys` from a given `collection` and
  repeatedly for each `collection` in turn.

  ## Examples

      iex> alias IO.ANSI.Table.Formatter
      iex> list = [
      ...>   %{a: 1, b: 2, c: 3},
      ...>   %{a: 4, b: 5, c: 6}
      ...> ]
      iex> Formatter.rows list, [:c, :a]
      [["3", "1"], ["6", "4"]]

      iex> alias IO.ANSI.Table.Formatter
      iex> list = [
      ...>   %{:one => "1", '2' => 2.0, "3" => :three},
      ...>   %{:one => '4', '2' => "5", "3" => 000006}
      ...> ]
      iex> Formatter.rows list, ["3", :one, '2']
      [["three", "1", "2.0"], ["6", "4", "5"]]
  """
  @spec rows([collection], [collection_key]) :: [row]
  def rows(collections, keys) do
    for collection <- collections do
      for key <- keys, do: to_string collection[key]
    end
  end

  @doc """
  Given a list of `columns` (string sublists), returns a list containing
  the width of each `column` capped by `maximum width`.

  ## Examples

      iex> alias IO.ANSI.Table.Formatter
      iex> data = [["cat", "wombat", "elk"], ["mongoose", "ant", "gnu"]]
      iex> Formatter.column_widths(data)
      [6, 8]

      iex> alias IO.ANSI.Table.Formatter
      iex> data = [["cat", "wombat", "elk"], ["mongoose", "ant", "gnu"]]
      iex> Formatter.column_widths(data, 7)
      [6, 7]
  """
  @spec column_widths([column], non_neg_integer) :: [column_width]
  def column_widths(columns, max_width \\ @upper_max_width)
  def column_widths(columns, max_width) when
    is_integer(max_width) and max_width >= @lower_max_width
  do
    for column <- columns do
      column |> Enum.map(&String.length/1) |> Enum.max |> min(max_width)
    end
  end
  def column_widths(columns, _max_width) do
    column_widths(columns, @lower_max_width)
  end

  @doc ~S"""
  Uppercases the first letter of every "word" of a `title` (must be
  convertible to a string).

  Any underscore is considered a space and consecutive
  whitespace characters are treated as a single occurrence.
  Leading and trailing whitespace characters are removed.

  If a map of `fixes` is given, all occurrences of each `fix` key in the
  `title` will be replaced with the corresponding `fix` value.

  ## Examples

      iex> alias IO.ANSI.Table.Formatter
      iex> Formatter.titlecase " son   of a gun ", %{
      ...>   ~r[ of ]i => " of ",
      ...>   ~r[ a ]i  => " a "
      ...> }
      "Son of a Gun"

      iex> alias IO.ANSI.Table.Formatter
      iex> Formatter.titlecase "_date___of_birth_", %{
      ...>   ~r[ of ]i => " of "
      ...> }
      "Date of Birth"

      iex> alias IO.ANSI.Table.Formatter
      iex> Formatter.titlecase :" _an_ _oDD case_ "
      "An ODD Case"
  """
  @spec titlecase(collection_key, map) :: String.t
  def titlecase(title, fixes \\ %{}) do
    import Enum, only: [map_join: 3, reduce: 3]
    import String, only: [first: 1, replace: 3, slice: 2, split: 3, upcase: 1]
    title =
      title
      |> to_string
      |> split(~r/(_| )+/, trim: true)
      |> map_join(" ", &(upcase(first &1) <> slice &1, 1..-1))
    reduce fixes, title, &replace(&2, elem(&1, 0), elem(&1, 1))
  end
end
