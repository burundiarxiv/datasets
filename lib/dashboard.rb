require 'pry'
require 'json'
require_relative '../index'
require_relative './regions'
require_relative './region'

row_enseignement = %w[234
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

row_tourisme = %w[107
2858
71
173
188
172
755
124
228
284
370
207
406
102
739
232
175
120].map(&:to_i)

data_enseignement = {
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
      data: row_enseignement,
      backgroundColor: 18.times.map{"#%06x" % rand(0..0xffffff)},
    }
  ]
}


data_tourisme = {
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
      label: "# hotels",
      backgroundColor: 'rgba(255,99,132,0.2)',
      borderColor: 'rgba(255,99,132,1)',
      borderWidth: 1,
      hoverBackgroundColor: 'rgba(255,99,132,0.4)',
      hoverBorderColor: 'rgba(255,99,132,1)',
      data: row_tourisme
    }
  ]
};

TABS = [
  {
    name: "country",
    label: "country",
    sections: [
      {
        title: 'education',
        graphs: [{
          title: 'distribution_fundamental_schools',
          data: data_enseignement,
          type: 'Doughnut',
          source: "Bureau de la Planification et des Statistiques de l'Education"
        }]
      },
      {
        title: 'tourism_and_hotel_business',
        graphs: [{
          title: "hotels_capacity",
          data: data_tourisme,
          type: 'HorizontalBar',
          source: 'ISTEEBU/ONT'
          }]
        },
        {
          title: 'employment',
          graphs: []
        },
        {
        title: 'public_finances',
        graphs: []
      },
      {
        title: 'population',
        graphs: []
      },
      {
        title: 'health_and_nutrition',
        graphs: []
      }
    ]
  },
  {
    name: "provinces",
    label: "provinces",
    sections: PROVINCES.map { |province| { title: province, graphs: [] } }
  },
  {
    name: "communes",
    label: "communes",
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
