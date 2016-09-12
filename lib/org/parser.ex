defmodule Org.Parser do
  defmodule Text, do: defstruct contents: ""
  defmodule Heading, do: defstruct contents: "", children: [], level: 1

  defprotocol Section do
    def join(this, other)
  end

  defimpl Section, for: Text do
    def join(this, other) do
      %Text{contents: Enum.join([other.contents, this.contents], "\n")}
    end
  end

  def parse(text) do
    text
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reverse
    |> Enum.reduce([], &collapse/2)
  end

  defp parse_line("* " <> contents), do: %Heading{contents: contents, level: 1}
  defp parse_line("** " <> contents), do: %Heading{contents: contents, level: 2}
  defp parse_line(contents), do: %Text{contents: contents}

  defp collapse(this = %Text{}, [previous = %Text{}|rest]) do
    [Section.join(previous, this) | rest]
  end
  defp collapse(%Heading{contents: heading_contents, children: children}, [previous = %Text{} | rest]) do
    heading = %Heading{contents: heading_contents, children: [previous | children]}
    [heading | rest]
  end
  defp collapse(this = %Heading{level: this_level}, [previous = %Heading{level: previous_level} | rest]) when this_level < previous_level do
    heading = %{this | children: this.children ++ [previous]}
    [heading | rest]
  end
  defp collapse(x, acc) do
    [x | acc]
  end
end
