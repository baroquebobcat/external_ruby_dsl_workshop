module SQLAwesome
  # The transformer convers the intermediate tree built by the parser
  # into the semantic model.
  class Transformer < Parslet::Transform
    rule(args: simple(:args), from: simple(:table_name) )  { SelectQuery.new(WildCard.new, table_name) }
  end
end