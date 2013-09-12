module SQLAwesome
  class Parser < Parslet::Parser
    root :statement

    rule(:statement) { str("SELECT") >> space? >> integer_list.as(:select_args) }

    rule(:integer_list) { (integer >> comma).repeat >> integer }

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end
end