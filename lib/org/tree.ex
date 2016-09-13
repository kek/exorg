defmodule Org.Tree do
  defprotocol Section do
    def join(first, other)
  end

  defmodule Text, do: defstruct contents: ""

  defmodule Heading, do: defstruct contents: "", children: [], level: nil

  defimpl Section, for: Text do
    def join(first, second = %Text{}) do
      [%Text{contents: Enum.join([first.contents, second.contents], "\n")}]
    end
    def join(first, second) do
      [first, second]
    end
  end

  defimpl Section, for: Heading do
    def join(first, second = %Text{}) do
      [%{first | children: [second | first.children]}]
    end
    def join(first = %Heading{level: this_level},
             second = %Heading{level: previous_level})
             when this_level < previous_level do
      [%{first | children: first.children ++ [second]}]
    end
    def join(first, second) do
      [first, second]
    end
  end

  defimpl String.Chars, for: Heading do
    def to_string(heading) do
      stars = Enum.join(for _ <- 1..heading.level, do: "*")
      this = "#{stars} #{heading.contents}\n"
      rendered_children = Org.Renderer.Org.render(heading.children)
      Enum.join([this, rendered_children])
    end
  end

  defimpl String.Chars, for: Text do
    def to_string(text), do: "#{text.contents}\n"
  end
end
