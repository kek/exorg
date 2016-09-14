defmodule OrgTest do
  @moduledoc "Integration test"
  use ExUnit.Case

  test "Parsing and rendering a document" do
    org_text = "* A heading\nSome text\n"

    parsed_doc = Org.Parser.parse(org_text)
    rendered_doc = Org.Renderer.Org.render(parsed_doc)

    assert rendered_doc == org_text
  end
end
