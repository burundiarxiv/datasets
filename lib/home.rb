require 'google_drive'
require 'csv'
require 'pry'

require_relative '../index'

BASE_URL = '/datasets'

session = GoogleDrive::Session.from_config('config.json')
sheet = session.spreadsheet_by_key(INDEX_FILE).worksheets[1]
rows = sheet.rows

datasets = {}
rows.each do |row|
  category = row[0]
  id = row[1].gsub(/\./, '-').chop!
  name = row[2]
  path = "#{BASE_URL}/isteebu-annuaire-2018-#{id}.csv"

  data = { name: name, path: path, id: id }

  datasets[category] = [] unless datasets.key?(category)

  datasets[category] << data
end

datasetsv2 = datasets.map do |category, data|
  { category: category, data: data.sort_by { |d| d[:name] } }
end

File.open(OPEN_DATA_HOME_ENDPOINT.to_s, 'w') do |file|
  file.write(datasetsv2.to_json)
end
