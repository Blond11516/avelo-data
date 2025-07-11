defmodule AveloDataWeb.ErrorJSONTest do
  use AveloDataWeb.ConnCase, async: true

  test "renders 404" do
    assert AveloDataWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert AveloDataWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
