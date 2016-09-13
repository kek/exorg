defmodule Org.Parser do
  @moduledoc "Transforms an org file into a tree structure"

  def parse(text) do
    text
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reverse
    |> Enum.reduce([], &collapse/2)
  end

  defp parse_line(line) do
    case Regex.run(~r/(\*+) (.*)/, line) do
      nil -> %Org.Tree.Text{contents: line}
      [^line, stars, text] -> %Org.Tree.Heading{contents: text, level: String.length(stars)}
    end
  end

  defp collapse(this, [previous | rest]), do: Org.Tree.Section.join(this, previous) ++ rest
  defp collapse(this, []), do: [this]
end
