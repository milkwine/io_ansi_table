defmodule IO.ANSI.Table.Server do
  # @moduledoc """
  # Table GenServer...
  # """
  @moduledoc false

  use GenServer

  alias __MODULE__
  alias IO.ANSI.Table.{Formatter, Spec}

  # require Logger

  @typep from :: GenServer.from()

  @spec start_link(term) :: GenServer.on_start()
  def start_link(:ok), do: GenServer.start_link(Server, :ok, name: Server)

  ## Callbacks

  @spec init(term) :: {:ok, Spec.t()}
  def init(:ok), do: {:ok, Spec.new()}

  @spec handle_cast(term, Spec.t()) :: {:noreply, Spec.t()}
  def handle_cast({maps, options}, spec) do
    # Logger.debug("Handling cast with options #{inspect(options)}")
    :ok = Formatter.print_table(spec, maps, options)
    {:noreply, spec}
  end

  @spec handle_call(term, from, Spec.t()) :: {:reply, :ok, Spec.t()}
  def handle_call({maps, options}, {from_pid, _ref}, spec) do
    # Logger.debug("Handling call with options #{inspect(options)}")

    group_leader = Process.info(from_pid)[:group_leader]
    if group_leader do
      Process.group_leader(self(), group_leader)
    end

    :ok = Formatter.print_table(spec, maps, options)
    {:reply, :ok, spec}
  end
end
