require 'minitest/autorun'
require 'sql_awesome'

describe SQLAwesome::Transformer do
  it "converts {select_args: [{integer: '1'}]} into an Statement node" do
    transformer = SQLAwesome::Transformer.new
    result = transformer.apply select_args: [{integer: "1"}]
    result.inspect.must_equal "Statement[1]"
  end
  it "converts {select_args: [{integer: '1'},{integer: '2'}]} into an Statement node" do
    transformer = SQLAwesome::Transformer.new
    result = transformer.apply select_args: [{integer: "1"},{integer: "2"}]
    result.inspect.must_equal "Statement[1, 2]"
  end
end