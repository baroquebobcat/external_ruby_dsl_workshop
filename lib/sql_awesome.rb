require 'parslet'
require 'parslet_ext'
require 'sql_awesome/parser'
require 'sql_awesome/ast'
require 'sql_awesome/transformer'

module SQLAwesome
  def self.eval program, database={}
    raw_ast = Parser.new.parse program
    ast = Transform.new.apply raw_ast
    ast.eval database
  end
end