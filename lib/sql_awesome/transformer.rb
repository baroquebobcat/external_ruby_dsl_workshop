module SQLAwesome
  class Transformer < Parslet::Transform
    rule(:integer => simple(:int))  { SemanticModel::Statement.new int }
  end
end