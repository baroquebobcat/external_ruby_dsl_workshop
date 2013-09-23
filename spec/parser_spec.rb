require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::Parser do
  it "converts a wildcard statement with no where into an intermediate tree" do
    tree = SQLAwesome::Parser.new.parse "SELECT * FROM a"
    tree.must_equal args: {wildcard: "*"}, from: "a"
  end

  it "converts a one field statement with no where into an intermediate tree" do
    tree = SQLAwesome::Parser.new.parse "SELECT b FROM a"
    tree.must_equal args: {field: "b"}, from: "a"
  end
end