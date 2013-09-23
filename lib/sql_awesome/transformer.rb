module SQLAwesome
  # The transformer convers the intermediate tree built by the parser
  # into the semantic model.
  class Transformer < Parslet::Transform
    rule(args: simple(:args),
         from: simple(:table_name)) { 
           SemanticModel::SelectQuery.new(args, table_name.to_s)
         }
    rule(wildcard: simple(:asterisk)) { SemanticModel::WildCard.new }
    rule(field: simple(:field_name)) { SemanticModel::Field.new field_name.to_s }
  end
end