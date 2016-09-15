defmodule OrgRendererTest do
  use ExUnit.Case
  doctest Org.Renderer

  describe "Rendering org format" do
    test "Rendering a heading" do
      doc = [%Org.Tree.Heading{contents: "A heading", level: 1}]

      assert Org.Renderer.Org.render(doc) == "* A heading\n"
    end

    test "Rendering a text" do
      doc = [%Org.Tree.Text{contents: "Some text"}]

      assert Org.Renderer.Org.render(doc) == "Some text\n"
    end

    test "Rendering a heading with children" do
      doc =
        [%Org.Tree.Heading{contents: "A heading", level: 1,
                           children: [%Org.Tree.Text{contents: "Some text"}]}]

      assert Org.Renderer.Org.render(doc) ==
        "* A heading\nSome text\n"
    end

    test "Rendering two headings without children" do
      doc =
        [%Org.Tree.Heading{contents: "A heading", level: 1},
         %Org.Tree.Heading{contents: "Another heading", level: 1}]

      assert Org.Renderer.Org.render(doc) ==
        "* A heading\n* Another heading\n"
    end
  end

  describe "Rendering HTML format" do
    doc =
      [%Org.Tree.Heading{contents: "A heading", level: 1, children:
                         [
                           %Org.Tree.Text{contents: "Some text"},
                           %Org.Tree.Text{contents: "More text"}
                         ]},
       %Org.Tree.Heading{contents: "Another heading", level: 1}]

    html = Org.Renderer.HTML.render(doc)

    assert Floki.parse(html) ==
      [
        {"h1", [], ["A heading"]},
        {"p", [], ["Some text"]},
        {"p", [], ["More text"]},
        {"h1", [], ["Another heading"]}
      ]
  end
end
