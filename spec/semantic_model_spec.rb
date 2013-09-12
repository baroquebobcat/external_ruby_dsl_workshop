require 'minitest/autorun'
require 'sql_awesome'

Model = SQLAwesome::SemanticModel
describe SQLAwesome::SemanticModel do
  it "hello worlds with one" do
    statement = Model::Statement.new [Model::Integer.new("1")]
    statement.eval(nil).must_equal [{"1"=>1}]
  end

  it "has hello world, but with 2" do
    statement = Model::Statement.new [Model::Integer.new("2")]
    statement.eval(nil).must_equal [{"2" => 2 }]
  end
end