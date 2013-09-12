require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::SemanticModel do
  it "hello worlds with one" do
    statement = SQLAwesome::SemanticModel::Statement.new "1"
    statement.eval(nil).must_equal [{"1"=>1}]
  end

  it "has hello world, but with 2" do
    statement = SQLAwesome::SemanticModel::Statement.new "2"
    statement.eval(nil).must_equal [{"2" => 2 }]
  end
end