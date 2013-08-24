module SQLAwesome
  class Parser < Parslet::Parser
    root :statement
    rule(:statement) { select }

    rule(:select) { str("SELECT").as(:select) >> space? >>
                    arguments.as(:args) >> from.maybe }
    rule(:arguments) { (argument_list.as(:args) | wildcard) >> space? }
    rule(:argument_list) { argument >> (comma >> argument).repeat  }
    rule(:argument) { (integer.as(:integer_argument) | ident.as(:column_argument)).raw_as(:name)}

    rule(:from) { str("FROM") >> space? >> ident.as(:table_name) }

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }

    rule(:wildcard) { str('*').as(:wildcard) }


    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end
end