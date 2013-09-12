module SQLAwesome
  class Transformer < Parslet::Transform
    rule(:select_args => simple(:args))  { SemanticModel::Statement.new args }
    rule(:integer => simple(:int))  { SemanticModel::Integer.new int }
  end
end