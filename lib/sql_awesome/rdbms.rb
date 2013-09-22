module SQLAwesome
  class RDBMS
    def initialize tables
      @tables = tables
    end
    def [] table_name
      @tables[table_name]
    end
  end
end