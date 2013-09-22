require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::Transformer do
  it "converts {args:'*', from:'a'} into a wild card query object" do
    result = SQLAwesome::Transformer.new.apply args:'*', from:'a'

    result.inspect.must_equal "Query: Fields:all FromTable:a"
  end
end