require 'google_drive'
require 'csv'
require 'pry'

session = GoogleDrive::Session.from_config("config.json")
index = '1nsBIvK4a_jdW4h4Wpd2S2KqJqTvyx3lFN5jeFJVDdH0'

# sheets = session.spreadsheet_by_key("1AregRaxaT_DTLGa2bvtuJhvId64KWn1PAREunZnM5v0").worksheets
index = session.spreadsheet_by_key("1nsBIvK4a_jdW4h4Wpd2S2KqJqTvyx3lFN5jeFJVDdH0").worksheets[0]

chapters = index.rows.drop(1).first(21)
chapters.each do |chapter|
  number, title, _, _, _, _, _, key = chapter

  next if key.empty?

  puts "opening #{title}"
  sheets = session.spreadsheet_by_key(key).worksheets
  sheets.each do |sheet|
    rows = sheet.rows
    title = sheet.title.gsub('.', '-')
    csv_str = rows.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join("")
    filename = "isteebu/isteebu-annuaire-2018-#{title}.csv"
    File.open(filename, "w") {|f| f.write(rows.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}
  end
end
