require 'pry'
require 'json'
require_relative '../index'
require_relative './regions'
require_relative './region'

# data = {
#   labels: ['Red', 'Green', 'Yellow'],
#   datasets: [
#     {
#       data: [400, 300, 34],
#       backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
#       hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
#     }
#   ]
# }

row = %w[234
          184
          273
          280
          128
          279
          326
          192
          264
          205
          337
          125
          227
          145
          240
          345
          228
          242].map(&:to_i)

data = {
  labels: %w[Bubanza
      Bujumbura-Mairie
      Bujumbura-Rural
      Bururi
      Cankuzo
      Cibitoke
      Gitega
      Karuzi
      Kayanza
      Kirundo
      Makamba
      Muramvya
      Muyinga
      Mwaro
      Ngozi
      Rumonge
      Rutana
      Ruyigi],
  datasets: [
    {
      data: row,
      backgroundColor: 18.times.map{"#%06x" % rand(0..0xffffff)},
      # hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
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
        graphs: [{
          title: 'Répartition des Écoles du Fondamental par Province Scolaire',
          data: data,
          type: 'Doughnut'
        }]
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
