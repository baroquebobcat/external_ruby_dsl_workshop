require 'parslet'

module SQLAwesome
  class Parser < Parslet::Parser
    root :statement
    rule(:statement) { select }

    rule(:select) { str("SELECT").as(:select) >> space? >>
                    arguments.as(:args) >> from.maybe }
    rule(:arguments) { (argument_list.as(:args) | wildcard) >> space? }
    rule(:argument_list) { integer >> (comma >> integer).repeat  }

    rule(:from) { str("FROM") >> space? >> ident.as(:table_name) }

    rule(:ident) { match('[a-zA-Z]') >> match('\w').repeat }

    rule(:wildcard) { str('*').as(:wildcard) }


    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end

  class Transform < Parslet::Transform
    rule(:integer => simple(:int))  { AST::IntLiteral.new int }
    rule(:args => simple(:arg)) { AST::SelectArgs.new [arg] }
    rule(:args => sequence(:args)) { AST::SelectArgs.new args }
    rule(:select => simple(:select),
          :args => simple(:args),
          :table_name => simple(:from) )   { AST::FromSelect.new args, from}
    rule(:select => simple(:select),
          :args => simple(:args))   { AST::Select.new args}
    rule(:select => simple(:select),
          :args => sequence(:args))   { AST::Select.new args}
    rule(:wildcard => simple(:wildcard)) { AST::Wildcard.new }
  end

  module AST
    class IntLiteral < Struct.new(:int)
      def eval; int.to_i; end
    end
    
    class Wildcard < Struct.new(:int)
      def eval table
        table.map { |row| row }
      end
    end

    class SelectArgs < Struct.new(:args)
      def eval database
        args.map do |arg|
          value = arg.eval
          {value.to_s => value}
        end
      end
    end

    class FromSelect < Struct.new(:args, :table_name)
      def eval database
        table = database[table_name.to_sym]
        args.eval table
      end
    end

    class Select < Struct.new(:args)
      def eval table
        args.eval table
      end
    end
  end

  def self.eval program, database={}
    raw_ast = Parser.new.parse program
    ast = Transform.new.apply raw_ast
    ast.eval database
  end
end