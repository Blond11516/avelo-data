defmodule AveloDataWeb.PageController do
  use AveloDataWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
