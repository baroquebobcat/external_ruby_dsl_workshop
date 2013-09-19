module SQLAwesome
  # The transformer convers the intermediate tree built by the parser
  # into the semantic model.
  class Transformer < Parslet::Transform
    # rule(:somename => sequence(:args))  { Blah.new args }
    # rule(:x => simple(:y))  { Blah.new y }
  end
end