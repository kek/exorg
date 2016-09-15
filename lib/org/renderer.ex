defmodule Org.Renderer do
  alias Org.Tree

  defmodule Org do
    def render(doc) do
      Enum.join(doc)
    end
  end

  defmodule HTML do
    def render(text = %Tree.Text{}) do
      text.contents
      |> String.split("\n")
      |> Enum.map(&("<p>#{&1}</p>"))
      |> Enum.join
    end
    def render(heading = %Tree.Heading{}) do
      tag = "h#{heading.level}"
      Enum.join(["<#{tag}>#{heading.contents}</#{tag}>",
                 render(heading.children)])
    end
    def render(doc) do
      doc
      |> Enum.map(&render/1)
      |> Enum.join
    end
  end
end
