module SQLAwesome
  # The transformer convers the intermediate tree built by the parser
  # into the semantic model.
  class Transformer < Parslet::Transform
    # rule(a: simple(:b)) {Blah.new b}
  end
end