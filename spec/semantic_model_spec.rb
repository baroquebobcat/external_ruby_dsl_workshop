require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::SemanticModel do
  it "hello worlds" do
    statement = SQLAwesome::SemanticModel::Statement.new 1
    statement.eval.must_equal [{"1"=>1}]
  end
end