require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome do
  it "retrieves all columns for all rows with a wildcard" do
    db = SQLAwesome.new_from_csv_dir "#{File.dirname(__FILE__)}/../data/"

    result = db.eval "SELECT * FROM one_to_five"
    result.must_equal db["one_to_five"]
  end
end