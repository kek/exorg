defmodule Org.Parser do
  defmodule Text do
    defstruct contents: ""
  end

  defmodule Heading do
    defstruct contents: "", children: []
  end

  def parse(text) do
    text
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce([], &collapse/2)
  end

  defp parse_line("* " <> text), do: heading(text)
  defp parse_line("** " <> text), do: heading(text)
  defp parse_line(contents), do: %Text{contents: contents}

  defp heading(contents) do
    %Heading{contents: contents}
  end

  defp collapse(%Text{contents: new_contents}, [%Text{contents: previous_contents}|rest]) do
    rest ++ [%Text{contents: Enum.join([previous_contents, new_contents], "\n")}]
  end
  defp collapse(text = %Text{}, [%Heading{contents: heading_contents, children: children}]) do
    [%Heading{contents: heading_contents, children: children ++ [text]}]
  end
  defp collapse(x, acc) do
    acc ++ [x]
  end
end
