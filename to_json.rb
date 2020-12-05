require 'json'
require 'csv'
require 'pry'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }

Dir.glob('isteebu/*.csv') do |filepath|
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
end
