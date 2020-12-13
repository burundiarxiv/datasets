require 'pry'
require 'json'
require_relative '../index'
require_relative './regions'
require_relative './region'

data = {
  labels: ['Red', 'Green', 'Yellow'],
  datasets: [
    {
      data: [400, 300, 34],
      backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
      hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
    }
  ]
}

TABS = [
  {
    name: "pays",
    label: "Pays",
    sections: [
      {
        title: 'EMPLOI',
        graphs: []
      },
      {
        title: 'ENSEIGNEMENT',
        graphs: []
      },
      {
        title: 'FINANCES PUBLIQUES',
        graphs: []
      },
      {
        title: 'POPULATION',
        graphs: []
      },
      {
        title: 'SANTÉ ET NUTRITION',
        graphs: []
      },
      {
        title: 'TOURISME ET HOTELLERIE',
        graphs: []
      }
    ]
  },
  {
    name: "provinces",
    label: "Provinces",
    sections: PROVINCES.map { |province| { title: province, graphs: [] } }
  },
  {
    name: "communes",
    label: "Communes",
    sections: COMMUNES.map do |commune|
      province, commune = commune.split(',')
      { title: commune, subtitle: province, graphs: [] }
    end
  }
]
result = {}
TABS.each do |tab|
  result[tab[:name]] = {
    label: tab[:label],
    sections: tab[:sections]
  }
end

puts result.to_json

File.open(OPEN_DATA_DASHBOARD_ENDPOINT.to_s, 'w') do |file|
  file.write(result.to_json)
end
