defmodule Org.Renderer do
  defmodule Org do
    def render(doc) do
      Enum.join(doc)
    end
  end
end
