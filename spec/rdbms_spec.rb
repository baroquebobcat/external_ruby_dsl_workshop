require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::RDBMS do
  let(:data_dir) { "#{File.dirname(__FILE__)}/../data" }
  
  def rows_in file
    File.open("#{data_dir}/#{file}.csv").readlines.size - 1
  end

  describe "SQLAwesome.new_from_csv_dir" do
    let(:db) { SQLAwesome.new_from_csv_dir data_dir }
    it "builds an RDBMS with tables including hats and one_to_five" do
      db.class.must_equal SQLAwesome::RDBMS
      db["one_to_five"].size.must_equal rows_in("one_to_five")
      db["hats"].size.must_equal rows_in("hats")
    end

  end
end