defmodule IO.ANSI.Table.FormatterTest do
  @moduledoc false

  use ExUnit.Case, async: true

  # Allows to capture IO...
  alias ExUnit.CaptureIO
  alias IO.ANSI.Table.{Formatter, Spec}

  doctest Formatter

  setup_all do
    maps = [
      # Unordered maps with atom keys and string values...
      %{c1: "r3 c1", c2: "r3 c2" , c3: "r3 c3", c4: "r3 c4"  },
      %{c1: "r1 c1", c2: "r1 c2" , c3: "r1 c3", c4: "r1+++c4"},
      %{c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"  },
      %{c1: "r2 c1", c2: "r2 c2" , c3: "r2 c3", c4: "r2 c4"  }
    ]

    options = [
      bell: false,
      count: 4,
      style: :test,
      headers: [:c4, :c1, :c2],
      margins: [top: 0, bottom: 0, left: 0],
      sort_specs: [:c4],
      sort_symbols: [asc: "↑"]
    ]

    spec = Spec.new() |> Spec.apply(options)
    {:ok, maps: maps, spec: spec}
  end

  describe "Formatter.print_table/2" do
    test "formats table ok", %{maps: maps, spec: spec} do
      capture =
        fn -> Formatter.print_table(spec, maps) end
        |> CaptureIO.capture_io()

      output = """
      ┌─────────┬───────┬────────┐
      │ C4↑     │ C1    │ C2     │
      ├─────────┼───────┼────────┤
      │ r1+++c4 │ r1 c1 │ r1 c2  │
      │ r2 c4   │ r2 c1 │ r2 c2  │
      │ r3 c4   │ r3 c1 │ r3 c2  │
      │ r4 c4   │ r4 c1 │ r4++c2 │
      └─────────┴───────┴────────┘
      """

      assert capture == output
    end

    test "positions table ok", %{maps: maps, spec: spec} do
      options = [
        margins: [top: 1, bottom: 0, left: 2],
        sort_symbols: [asc: "⬆", pos: :leading]
      ]

      left = "\e[2C" # move cursor forward N columns: \e[<N>C
      spec = Spec.apply(spec, options)

      capture =
        fn -> Formatter.print_table(spec, maps) end
        |> CaptureIO.capture_io()
        |> String.replace(left, "  ")

      output = """

        ┌─────────┬───────┬────────┐
        │ ⬆C4     │ C1    │ C2     │
        ├─────────┼───────┼────────┤
        │ r1+++c4 │ r1 c1 │ r1 c2  │
        │ r2 c4   │ r2 c1 │ r2 c2  │
        │ r3 c4   │ r3 c1 │ r3 c2  │
        │ r4 c4   │ r4 c1 │ r4++c2 │
        └─────────┴───────┴────────┘
      """

      assert capture == output
    end

    test "bad options are ignored", %{maps: maps, spec: spec} do
      options = [margins: %{}, sort_symbols: nil]
      left = "\e[2C" # move cursor forward N columns: \e[<N>C
      spec = Spec.apply(spec, options)

      capture =
        fn -> Formatter.print_table(spec, maps) end
        |> CaptureIO.capture_io()
        |> String.replace(left, "  ")

      output = """

        ┌─────────┬───────┬────────┐
        │ C4↑     │ C1    │ C2     │
        ├─────────┼───────┼────────┤
        │ r1+++c4 │ r1 c1 │ r1 c2  │
        │ r2 c4   │ r2 c1 │ r2 c2  │
        │ r3 c4   │ r3 c1 │ r3 c2  │
        │ r4 c4   │ r4 c1 │ r4++c2 │
        └─────────┴───────┴────────┘

      """

      assert capture == output
    end

    test "bad sort specs are ignored", %{maps: maps, spec: spec} do
      options = [sort_specs: {}, sort_symbols: [asc: "▲"]]
      spec = Spec.apply(spec, options)

      capture =
        fn -> Formatter.print_table(spec, maps) end
        |> CaptureIO.capture_io()

      output = """
      ┌─────────┬───────┬────────┐
      │ C4      │ C1    │ C2     │
      ├─────────┼───────┼────────┤
      │ r3 c4   │ r3 c1 │ r3 c2  │
      │ r1+++c4 │ r1 c1 │ r1 c2  │
      │ r4 c4   │ r4 c1 │ r4++c2 │
      │ r2 c4   │ r2 c1 │ r2 c2  │
      └─────────┴───────┴────────┘
      """

      assert capture == output
    end
  end
end
