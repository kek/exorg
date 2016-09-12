defmodule OrgParserTest do
  use ExUnit.Case
  doctest Org.Parser

  test "parsing text" do
    just_text = "Some text\n"

    doc = Org.Parser.parse(just_text)

    assert doc == [%Org.Parser.Text{contents: "Some text"}]
  end

  test "parsing a heading" do
    a_heading = "* A heading\n"

    doc = Org.Parser.parse(a_heading)

    assert doc == [%Org.Parser.Heading{contents: "A heading"}]
  end

  test "parsing more text" do
    two_lines_of_text = "Some text\nMore text\n"

    doc = Org.Parser.parse(two_lines_of_text)

    assert doc == [%Org.Parser.Text{contents: "Some text\nMore text"}]
  end

  test "parsing a heading with text" do
    heading_with_text = "* A heading\nSome text\nMore text\n"

    doc = Org.Parser.parse(heading_with_text)

    assert doc ==
      [
        %Org.Parser.Heading{
          contents: "A heading",
          children: [
            %Org.Parser.Text{contents: "Some text"},
            %Org.Parser.Text{contents: "More text"}
          ]
        }
      ]
  end

  test "parsing two headings" do
    two_headings = "* A heading\n* A second heading\n"

    doc = Org.Parser.parse(two_headings)

    assert doc ==
      [
        %Org.Parser.Heading{contents: "A heading"},
        %Org.Parser.Heading{contents: "A second heading"}
      ]
  end

  # test "parsing a subheading" do
  #   heading_and_subheading = "* A heading\n** A subheading\n"
  #
  #   doc = Org.Parser.parse(heading_and_subheading)
  #
  #   assert doc ==
  #     {
  #       {:heading, "A heading",
  #         [
  #           {:heading, "A subheading", []}
  #         ]
  #       }
  #     }
  # end
end
