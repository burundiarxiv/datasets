require 'json'
require 'csv'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = 'isteebu/isteebu-annuaire-2018-2-02.csv'

headers = CSV.read(filepath, headers: true).headers

data = []
CSV.foreach(filepath, csv_options) do |row|
  line = {}
  headers.each do |column|
    line[column] = row[column]
  end
  data << line
end

File.open("json/#{File.basename(filepath, '.csv')}.json", 'w') { |file| file.write(data.to_json) }
