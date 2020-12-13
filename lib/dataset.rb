require 'csv'
require 'pry'

class Dataset
  attr_reader :region, :titles, :type

  def initialize(region, type: 'province')
    @region = region
    @titles = []
    @type = type
  end

  def find
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    Dir.glob('isteebu/*.csv') do |filepath|
      CSV.foreach(filepath, csv_options) do |row|
        @titles << clean_title(row['titre_tableau']) if row.to_s.downcase.include? region.downcase
      end
    end
  end

  private

  def clean_title(title)
    title.gsub(' par province', '')
  end
end

dataset = Dataset.new('Cankuzo')
dataset.find
p dataset.titles
#  {
#             title: 'Population par âge et par sexe dans les communes',
#             data: doughnutData,
#             type: 'Doughnut'
#           }
