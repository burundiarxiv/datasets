require 'google_drive'
require 'csv'
require 'pry'

require_relative 'index'

# session = GoogleDrive::Session.from_config('config.json')
# sheet = session.spreadsheet_by_key(INDEX_FILE).worksheets[1]
# binding.pry
# rows = sheet.rows

rows = [["POPULATION", "1.01.", "Principaux indicateurs démographiques et socio-économiques du Burundi"],
        ["POPULATION", "1.02.", "Population totale par sexe et âge aux recensements de 1979, 1990 et 2008"],
        ["POPULATION", "1.03.", "Population  de 10 ans ou plus par sexe, âge et niveau d'instruction au recensement de 2008"],
        ["POPULATION", "1.04.", "Population résidente active occupée par sexe, âgé et grands groupes professionnels au recensement de 2008"],
        ["POPULATION", "1.05.", "Actifs occupés au lieu de travail par sexe et situation dans la profession par branche d'activité économique au recensement de 2008"]]


datasets = {}
# rows = CSV.read(filename)
rows.each do |row|
  category = row[0]
  id = row[1].gsub(/\./, '-').chop!
  name = row[2]
  path = "https://burundiarxiv-api.herokuapp.com/datasets/isteebu-annuaire-2018-#{id}.csv"

  data = { name: name, path: path }

  datasets[category] = [] unless datasets.key?(category)

  datasets[category] << data
end

datasetsv2 = datasets.map { |category, data| { category: category, data: data } }
# pp datasetsv2

File.open("json/datasets.json", 'w') do |file|
  file.write(datasetsv2.to_json)
end



# chapters = index.rows.drop(1).first(21)
# chapters.each do |chapter|
#   _number, title, _, _, _, _, _, key = chapter

#   next if key.empty?

#   puts "opening #{title}"
#   sheets = session.spreadsheet_by_key(key).worksheets
#   sheets.each do |sheet|
#     rows = sheet.rows
#     title = sheet.title.gsub('.', '-')
#     csv_str = rows.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join('')
#     filename = "isteebu/isteebu-annuaire-2018-#{title}.csv"
#     File.open(filename, 'w') { |f| f.write(csv_str) }
#   end
# end
