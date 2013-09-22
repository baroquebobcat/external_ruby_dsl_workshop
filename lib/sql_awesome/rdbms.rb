module SQLAwesome
  class RDBMS
    def initialize tables
      @tables = tables
    end
    def [] table_name
      @tables[table_name]
    end

    def eval query_string
      intermediate_tree = Parser.new.parse query_string
      model = Transformer.new.apply intermediate_tree
      model.eval @tables
    end
  end
end