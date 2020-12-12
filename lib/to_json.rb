require 'json'
require 'csv'
require 'pry'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }

Dir.glob('isteebu/*.csv') do |filepath|
  headers = CSV.read(filepath, headers: true).headers.drop(3)

  rows = []
  source = ''
  CSV.foreach(filepath, csv_options) do |row|
    source = row['source']
    line = {}
    headers.each do |column|
      line[column] = row[column]
    end
    rows << line
  end

  File.open("json/#{File.basename(filepath, '.csv')}.json", 'w') do |file|
    file.write({ headers: headers, rows: rows.first(10), source: source }.to_json)
  end
end
