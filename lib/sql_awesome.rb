require 'parslet'
require 'sql_awesome/parslet_ext'
require 'sql_awesome/parser'
require 'sql_awesome/semantic_model'
require 'sql_awesome/transformer'
require 'sql_awesome/rdbms'

module SQLAwesome
  def self.new_from_csv_dir directory
    require 'csv'
    tables = {}
    Dir["#{directory.chomp("/")}/*.csv"].each do |file|
      table = []
      CSV.foreach(file, headers: true) { |row| table << row }
      tables[file.split("/").last.chomp(".csv")] = table
    end
    RDBMS.new tables
  end
end