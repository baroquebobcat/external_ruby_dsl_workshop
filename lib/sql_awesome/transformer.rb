module SQLAwesome
  class Transform < Parslet::Transform
    rule(:integer => simple(:int))  { AST::IntLiteral.new int }
    rule(:args => simple(:arg)) { AST::SelectArgs.new [arg] }
    rule(:args => sequence(:args)) { AST::SelectArgs.new args }
    rule(:integer_argument => simple(:int), :name => simple(:name)) { AST::IntArgument.new int}
    rule(:column_argument => simple(:name), :name => simple(:raw)) { AST::ColumnArgument.new name}
    rule(:select => simple(:select),
          :args => simple(:args),
          :table_name => simple(:from) )   { AST::FromSelect.new args, from}
    rule(:select => simple(:select),
          :args => simple(:args))   { AST::Select.new args}
    rule(:wildcard => simple(:wildcard)) { AST::Wildcard.new }
  end
end