module SQLAwesome
  # The Parser takes a string and turns it into an intermediate representation.
  # This representation can be used to populate the Semantic Model.
  class Parser < Parslet::Parser
    root :statement

    rule(:statement) { str("SELECT") >> space? >>
                       args.as(:args) >> space? >>
                       str("FROM") >> space? >> ident.as(:from)
                     }
    rule(:args) { str("*").as(:wildcard)}

    # handy list pattern x.repeat(1,1) > (y >> x).repeat

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end
end