defmodule IO.ANSI.Table.IE do
  @moduledoc false

  # Functions for iex session...
  #
  # Examples:
  #   use IO.ANSI.Table.IE
  #   people()
  #   people_sorted()
  #   people_as_keywords()
  #   people_sorted_as_keywords()
  #   print_people(:dotted_mult)
  #   print_people(:dotted_mult, 9)
  #   print_people_as_keywords(:green_mult)
  #   print_people_as_keywords(:green_mult, 9)
  #   styles()
  #   styles(:light_green)
  #   Style.styles()
  #   print_people([:pretty_alt, :dotted_alt, :medium_alt])
  #   print_people()
  #   Application.put_env(:io_ansi_table, :async, true)
  #   r(Table)
  #   print_people([:pretty_alt, :dotted_alt, :medium_alt])
  #   print_people()

  alias IO.ANSI.Table
  alias IO.ANSI.Table.Style

  require MapSorter

  @align_specs [center: :dob, right: :weight]
  @headers [:name, :dob, :likes, :bmi]
  @header_fixes %{"Dob" => "DOB", "Bmi" => "BMI"}
  @margins [top: 1, bottom: 0]
  # Using @people with struct dobs requires to...
  # config :map_sorter, sorting_on_structs?: true
  # mix deps.compile map_sorter
  @people [ # struct dobs
    %{name: "Mike", likes: "ski, arts", dob: ~D[1992-04-15], bmi: 23.9},
    %{name: "Mary", likes: "travels"  , dob: ~D[1992-04-15], bmi: 26.8},
    %{name: "Ann" , likes: "reading"  , dob: ~D[1992-04-15], bmi: 24.7},
    %{name: "Ray" , likes: "cycling"  , dob: ~D[1977-08-28], bmi: 19.1},
    %{name: "Bill", likes: "karate"   , dob: ~D[1977-08-28], bmi: 18.1},
    %{name: "Joe" , likes: "boxing"   , dob: ~D[1977-08-28], bmi: 20.8},
    %{name: "Jill", likes: "cooking"  , dob: ~D[1976-09-28], bmi: 25.8}
  ]
  @people [ # string dobs
    %{name: "Mike", likes: "ski, arts", dob: "1992-04-15", bmi: 23.9},
    %{name: "Mary", likes: "travels"  , dob: "1992-04-15", bmi: 26.8},
    %{name: "Ann" , likes: "reading"  , dob: "1992-04-15", bmi: 24.7},
    %{name: "Ray" , likes: "cycling"  , dob: "1977-08-28", bmi: 19.1},
    %{name: "Bill", likes: "karate"   , dob: "1977-08-28", bmi: 18.1},
    %{name: "Joe" , likes: "boxing"   , dob: "1977-08-28", bmi: 20.8},
    %{name: "Jill", likes: "cooking"  , dob: "1976-09-28", bmi: 25.8}
  ]
  @sort_specs [:dob, desc: :likes]

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)
      alias IO.ANSI.Table
      alias IO.ANSI.Table.{Column, Config, Formatter, Heading}
      alias IO.ANSI.Table.{Line, Line_type, Row, Spec, Style}
      require MapSorter
      :ok
    end
  end

  def people(), do: @people()

  def people_as_keywords(), do: Enum.map(@people, &Keyword.new/1)

  def print_people(styles \\ Style.styles())
  def print_people(styles) when is_list(styles) do
    Enum.each(styles, &print_people/1)
  end
  def print_people(style) do
    Table.format(
      @people, bell: true, count: length(@people), style: style,
      headers: @headers, header_fixes: @header_fixes,
      sort_specs: @sort_specs, align_specs: @align_specs,
      margins: @margins
    )
  end

  def print_people_as_keywords(style) do
    Table.format(
      people_as_keywords(), bell: true, count: length(@people), style: style,
      headers: @headers, header_fixes: @header_fixes,
      sort_specs: @sort_specs, align_specs: @align_specs,
      margins: @margins
    )
  end

  def print_people(style, max_width) do
    Table.format(
      @people, bell: true, count: length(@people), style: style,
      headers: @headers, header_fixes: @header_fixes,
      sort_specs: @sort_specs, align_specs: @align_specs,
      margins: @margins, max_width: max_width
    )
  end

  def print_people_as_keywords(style, max_width) do
    Table.format(
      people_as_keywords(), bell: true, count: length(@people), style: style,
      headers: @headers, header_fixes: @header_fixes,
      sort_specs: @sort_specs, align_specs: @align_specs,
      margins: @margins, max_width: max_width
    )
  end

  def styles(color \\ :light_magenta) do
    chardata = [color, " &style&filler", :reset, " - &rank - &note"]
    fragments = IO.ANSI.format(chardata)
    "#{fragments}"
    |> Style.texts(&IO.puts/1)
    |> length()
  end

  def people_sorted(), do: MapSorter.sort(@people, @sort_specs)

  def people_sorted_as_keywords() do
    MapSorter.sort(people_as_keywords(), @sort_specs)
  end
end
