Mix.install([:bandit, :websock_adapter])

defmodule EchoServer do
  def init(options) do
    {:ok, options}
  end

  def handle_in({"ping", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in(params, state) do
    IO.puts("Received: #{inspect(params)}")
    IO.puts("State: #{inspect(state)}")
    {:reply, :ok, {:text, "echo: #{inspect(params)}"}, state}
  end

  def terminate(:timeout, state) do
    {:ok, state}
  end
end

defmodule Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, """
    Use the JavaScript console to interact using websockets

    sock  = new WebSocket("ws://localhost:4001/websocket")
    sock.addEventListener("message", console.log)
    sock.addEventListener("open", () => sock.send("ping"))
    """)
  end

  get "/websocket" do
    conn
    |> WebSockAdapter.upgrade(EchoServer, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end

require Logger
webserver = {Bandit, plug: Router, scheme: :http, port: 4001}
{:ok, _} = Supervisor.start_link([webserver], strategy: :one_for_one)
Logger.info("Plug now running on localhost:4001")
Process.sleep(:infinity)
