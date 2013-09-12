module SQLAwesome
  class Transformer < Parslet::Transform
    rule(:select_args => sequence(:args))  { SemanticModel::Statement.new args }
    rule(:integer => simple(:int))  { SemanticModel::Integer.new int }
  end
end