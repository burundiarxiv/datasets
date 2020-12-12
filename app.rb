require 'google_drive'
require 'csv'
require 'pry'

require_relative 'index'

session = GoogleDrive::Session.from_config('config.json')
index = session.spreadsheet_by_key(INDEX_FILE).worksheets[0]

chapters = index.rows.drop(8).first(2)
chapters.each do |chapter|
  _number, title, _, _, _, _, _, key = chapter

  next if key.empty?

  puts "opening #{title}"
  sheets = session.spreadsheet_by_key(key).worksheets
  sheets.each do |sheet|
    rows = sheet.rows
    title = sheet.title.gsub('.', '-')
    csv_str = rows.inject([]) { |csv, row| csv << CSV.generate_line(row) }.join('')
    filename = "isteebu/isteebu-annuaire-2018-#{title}.csv"
    File.open(filename, 'w') { |f| f.write(csv_str) }
  end
end
