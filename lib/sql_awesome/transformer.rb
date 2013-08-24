module SQLAwesome
  class Transform < Parslet::Transform
    # rule(:integer => simple(:int))  { AST::IntLiteral.new int }
  end
end