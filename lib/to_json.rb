require 'json'
require 'csv'
require 'pry'

require_relative '../index'

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

  filename = "#{OPEN_DATA_DATASETS_PATH}/#{File.basename(filepath, '.csv')}.json"
  File.open(filename, 'w') do |file|
    file.write({ headers: headers, rows: rows.first(5), source: source }.to_json)
  end
end
