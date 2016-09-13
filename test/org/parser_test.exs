defmodule OrgParserTest do
  use ExUnit.Case
  doctest Org.Parser

  test "parsing text" do
    just_text = "Some text\n"

    doc = Org.Parser.parse(just_text)

    assert doc == [%Org.Tree.Text{contents: "Some text"}]
  end

  test "parsing a heading" do
    twenty_stars = Enum.join(for _ <- 1..20, do: "*")
    a_heading = "#{twenty_stars} A heading\n"

    doc = Org.Parser.parse(a_heading)

    assert doc == [%Org.Tree.Heading{contents: "A heading", level: 20}]
  end

  test "parsing more text" do
    two_lines_of_text = "Some text\nMore text\n"

    doc = Org.Parser.parse(two_lines_of_text)

    assert doc == [%Org.Tree.Text{contents: "Some text\nMore text"}]
  end

  test "parsing a heading with text" do
    heading_with_text = "* A heading\nSome text\nMore text\n"

    doc = Org.Parser.parse(heading_with_text)

    assert doc == [
      %Org.Tree.Heading{
        contents: "A heading",
        level: 1,
        children: [
          %Org.Tree.Text{contents: "Some text\nMore text"},
        ]
      }
    ]
  end

  test "parsing two headings" do
    two_headings = "* A heading\n* A second heading\n"

    doc = Org.Parser.parse(two_headings)

    assert doc == [
      %Org.Tree.Heading{contents: "A heading", level: 1},
      %Org.Tree.Heading{contents: "A second heading", level: 1}
    ]
  end

  test "parsing a subheading" do
    heading_and_subheading = "* A heading\n** A subheading\n"

    doc = Org.Parser.parse(heading_and_subheading)

    assert doc == [
      %Org.Tree.Heading{
        contents: "A heading",
        level: 1,
        children: [
          %Org.Tree.Heading{
            contents: "A subheading",
            level: 2
          }
        ]
      }
    ]
  end
end
