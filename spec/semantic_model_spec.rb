require 'minitest/autorun'
require 'sql_awesome'

Model = SQLAwesome::SemanticModel

describe SQLAwesome::SemanticModel do
  before do
    @table = [{"col1"=>1, "col2"=>2}]
  end
  describe "wildcards" do
    it "gets all the datas" do
      statement = Model::WildcardFromStatement.new "table"
      statement.eval(table: @table)
    end
  end

  describe "no tables" do
    it "hello worlds with one" do
      statement = Model::Statement.new [Model::Integer.new("1")]
      statement.eval(nil).must_equal [{"1"=>1}]
    end

    it "has hello world, but with 2" do
      statement = Model::Statement.new [Model::Integer.new("2")]
      statement.eval(nil).must_equal [{"2" => 2 }]
    end

    it "handles multiple arguments" do
      statement = Model::Statement.new [Model::Integer.new("1"), Model::Integer.new("2")]
      statement.eval(nil).must_equal [{"1" => 1, "2" => 2 }]
    end
  end
end