require 'csv'
require 'pry'

class Region
  attr_reader :name, :datasets, :graphs

  def initialize(name)
    @name = name
    @datasets = []
  end

  def find_datasets
    csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
    Dir.glob('isteebu/*.csv') do |filepath|
      CSV.foreach(filepath, csv_options) do |row|
        @datasets << clean_title(row['titre_tableau']) if row.to_s.downcase.include? name.downcase
      end
    end
    @datasets.uniq!
  end

  def graphs
    find_datasets
    datasets.map do |dataset|
      {
        title: dataset,
        data: data,
        type: 'Doughnut'
      }
    end
  end

  private

  def data
    {
      labels: ['Red', 'Green', 'Yellow'],
      datasets: [
        {
          data: [400, 300, 34],
          backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
          hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
        }
      ]
    }
  end

  def clean_title(title)
    title
      .gsub(" des communes (en milliers de FBU)", '')
      .gsub(" par provinces", '')
      .gsub(" par province", '')
      .gsub(" par Province", '')
      .gsub(" par Province Scolaire", '')
  end
end

# commune = Region.new('Mpanda')
# commune.find_datasets
# p commune.datasets.count
# p commune.graphs
