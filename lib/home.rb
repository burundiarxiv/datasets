require 'google_drive'
require 'csv'
require 'pry'

require_relative '../index'

BASE_URL = '/datasets'

session = GoogleDrive::Session.from_config('config.json')

def export_data(language, sheet)
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

  filename = "#{OPEN_DATA_PUBLIC_PATH}/#{language}/datasets.json"

  File.open(filename, 'w') do |file|
    file.write(datasetsv2.to_json)
  end
end

LOCALES.each do |locale|
  language = locale[0]
  index = locale[1]

  sheet = session.spreadsheet_by_key(INDEX_FILE).worksheets[index]
  export_data(language, sheet)
end
