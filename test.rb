require './sum_json_file_array'

init = SumJsonFileArray.new(read_file_path: 'disk.json', result_file_path: 'result.json')
init.calc