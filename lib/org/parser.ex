defmodule Org.Parser do
  @moduledoc "Transforms an org file into a tree structure"

  defprotocol Section do
    def join(this, other)
  end

  defmodule Text, do: defstruct contents: ""

  defmodule Heading, do: defstruct contents: "", children: [], level: nil

  defimpl Section, for: Text do
    def join(this, previous = %Text{}) do
      [%Text{contents: Enum.join([this.contents, previous.contents], "\n")}]
    end
    def join(this, previous) do
      [this, previous]
    end
  end

  defimpl Section, for: Heading do
    def join(this, previous = %Text{}) do
      [%{this | children: [previous | this.children]}]
    end
    def join(this = %Heading{level: this_level},
             previous = %Heading{level: previous_level})
             when this_level < previous_level do
      [%{this | children: this.children ++ [previous]}]
    end
    def join(this, previous) do
      [this, previous]
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

  defp collapse(this, [previous | rest]), do: Section.join(this, previous) ++ rest
  defp collapse(this, []), do: [this]
end
