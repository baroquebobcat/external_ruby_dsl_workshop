require 'parslet'

module SQLAwesome
  class Parser < Parslet::Parser
    root :statement
    rule(:statement) { select }

    rule(:select) { str("SELECT").as(:select) >> space? >> argument_list.as(:args) >> space?}
 
    rule(:argument_list) { integer >> (comma >> integer).repeat }

    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1).as(:integer) }

    rule(:comma)      { str(',') >> space? }
  end

  class Transform < Parslet::Transform
    rule(:integer => simple(:int)) { AST::IntLiteral.new int }
    rule(:select => simple(:select),
          :args => sequence(:args)) { AST::Select.new args }
    rule(:select => simple(:select),
          :args => simple(:args)) { AST::Select.new [args] }
  end

  module AST
    class IntLiteral < Struct.new(:int)
      def eval; int.to_i; end
    end
    class Select < Struct.new(:args)
      def eval
        args.map do |arg|
          value = arg.eval
          {value.to_s => value}
        end
      end
    end
  end

  def self.eval program
    raw_ast = Parser.new.parse program
    ast = Transform.new.apply raw_ast
    ast.eval
  end
end