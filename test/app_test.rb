require 'minitest/autorun'
require 'pry'
require 'json'
# require_relative '../lib/parser'

class AppTest < Minitest::Test
  def test_json_file_for_all_datasets
    file = File.read('./json/datasets.json')
    datasets = JSON.parse(file)
    all_ids = datasets.map { |dataset| dataset['data'].map { |data| "isteebu-annuaire-2018-#{data['id']}.json" } }.flatten
    exported_json_files = Dir.glob('json/isteebu-annuaire-2018-*.json').map { |path| File.basename(path) }
    assert_equal [], all_ids - exported_json_files
  end
end
