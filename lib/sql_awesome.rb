require 'parslet'
require 'parslet_ext'
require 'sql_awesome/parser'
require 'sql_awesome/semantic_model'
require 'sql_awesome/transformer'

module SQLAwesome
  def self.eval program, database={}
    raw_ast = Parser.new.parse program
    model = Transformer.new.apply raw_ast
    model.eval database
  end
end