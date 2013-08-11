require 'parslet'

module SQLAwesome
  class Parser < Parslet::Parser
    root :statement
    rule(:statement) { select.as(:select) }
    
    rule(:select) { str("SELECT") >> space? >> integer.as(:integer) >> space?}
 
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    rule(:integer)    { match('[0-9]').repeat(1) }
  end

  class Transform < Parslet::Transform
    rule(:integer => simple(:int)) { AST::IntLiteral.new int }
    rule(:select => simple(:integer)) { AST::Select.new integer }
  end

  module AST
    class IntLiteral < Struct.new(:int)
      def eval; int.to_i; end
    end
    class Select < Struct.new(:integer)
      def eval; [{integer.eval.to_s => integer.eval}] end
    end
  end

  def self.eval program
    raw_ast = Parser.new.parse program
    ast = Transform.new.apply raw_ast
    ast.eval
  end
end