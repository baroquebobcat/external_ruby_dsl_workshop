require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome do
  describe "hello worldish" do
    it "has hello world, but with one" do
      result = SQLAwesome.eval "SELECT 1"

      assert_equal [{"1"=>1}], result
    end

    it "has hello world, but with 2" do
      result = SQLAwesome.eval "SELECT 2"
      
      assert_equal [{"2"=>2}], result
    end


    it "allows selecting multiple values" do
      result = SQLAwesome.eval "SELECT 1,2,3"
      
      assert_equal [{"1"=>1},{"2"=>2},{"3"=>3}], result
    end
  end
end