module SQLAwesome
  class Parser < Parslet::Parser
    # root :statement

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end
end