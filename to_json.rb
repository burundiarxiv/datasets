require 'json'
require 'csv'
require 'pry'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }

Dir.glob('isteebu/*.csv') do |filepath|
  headers = CSV.read(filepath, headers: true).headers.drop(3)

  data = []
  source = ''
  CSV.foreach(filepath, csv_options) do |row|
    source = row['source']
    line = {}
    headers.each do |column|
      line[column] = row[column]
    end
    data << line
  end

  File.open("json/#{File.basename(filepath, '.csv')}.json", 'w') do |file|
    file.write({ headers: headers, data: data, source: source }.to_json)
  end
end
