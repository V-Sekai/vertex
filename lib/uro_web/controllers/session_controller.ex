defmodule UroWeb.SessionController do
  use UroWeb, :controller
  use UroWeb.Helpers.Auth

  @doc false
  defp login_valid(conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @doc false
  defp login_invalid(conn) do
    conn
    |> put_flash(:info, "Invalid email or password")
    |> render("new.html", changeset: Pow.Plug.change_user(conn, conn.params["user"]))
  end

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> validate_login(user_params)
    |> case do
      {:ok, conn} -> login_valid(conn)
      {:error, conn} -> login_invalid(conn)
    end
  end

  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
