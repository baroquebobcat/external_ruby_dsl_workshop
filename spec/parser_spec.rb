require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::Parser do
  it "can parse hello world into intermediate tree" do
    parser = SQLAwesome::Parser.new
    tree = parser.parse "SELECT 1"
    tree.must_equal select_args: {integer: "1"}
  end
end