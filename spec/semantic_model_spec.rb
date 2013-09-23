require 'minitest/autorun'
require 'sql_awesome'

include SQLAwesome::SemanticModel
describe SQLAwesome::SemanticModel do
  describe SelectQuery do
    it "has a nice inspect format" do
      query = SelectQuery.new "args", "table"
      query.inspect.must_equal "Query: \"args\" FromTable:table"
    end

    it "gives you back all the things in the table when args is a wild card" do
      query = SelectQuery.new WildCard.new, "a"
      result = query.eval "a" => [{"x"=>1}]
      result.must_equal [{"x"=>1}]
    end
  end
  describe WildCard do
    it "has an inspect that says it shows all fields" do
      WildCard.new.inspect.must_equal "Fields:all"
    end
    
    it "passes back the row as is when asked to filter" do
      wildcard = WildCard.new
      original = {"a"=>1,"b"=>2}
      result = wildcard.filter original
      result.must_equal original
    end
  end
  describe Field do
    it "has an inspect method that shows its field" do
      field = Field.new "myfield"
      field.inspect.must_equal "Fields:[myfield]"
    end
  end
end