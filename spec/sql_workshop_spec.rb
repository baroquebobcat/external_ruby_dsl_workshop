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


  #   it "allows selecting multiple values" do
  #     result = SQLAwesome.eval "SELECT 1,2,3"
      
  #     assert_equal [{"1"=>1, "2"=>2, "3"=>3}], result
  #   end
   end
  # describe '"tables"' do
  #   before do
  #     require 'csv'
  #     @hat_data = []
  #     CSV.foreach("data/hats.csv", headers: true) do |row|
  #       @hat_data << row
  #     end
  #   end
  #   it "should support wildcards" do
  #     result = SQLAwesome.eval "SELECT * FROM hats", hats: @hat_data
  #     assert_equal @hat_data, result
  #   end

  #   it "should support specifying specific columns" do
  #     result = SQLAwesome.eval "SELECT name FROM hats", hats: @hat_data
  #     assert_equal [{"name" => "Ascot cap"},
  #                   {"name" => "Beaver Hat"},
  #                   {"name" => "Boater"},
  #                   {"name" => "Busby"},
  #                   {"name" => "Coonskin cap"},
  #                   {"name" => "Deerstalker"},
  #                   {"name" => "Fedora"}
  #       ], result
  #   end
  # end
end