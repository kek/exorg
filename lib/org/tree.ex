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
end
