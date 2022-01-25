require 'json'

class SumJsonFileArray

  def initialize(params)
    @read_file_path = params[:read_file_path]
    @result_file_path = params[:result_file_path]
    @item_string = ''
    @first_sym = ''
    @new_string = ''
  end

  def calc
    clear_file

    data = read_line_by_line
    data.each_entry do |line|
      processing_line(line)
    end
  end

  private

  def clear_file
    File.delete(@result_file_path) if File.exist?(@result_file_path)
  end

  def read_line_by_line
    File.foreach(@read_file_path)
  end

  def write_to_part(part)
    File.write(@result_file_path, part, mode: "a")
  end

  def processing_line(line)
    formatted_line = line.strip.gsub(' ', '')
    handle_formatted_line(formatted_line)
  end

  def handle_formatted_line(str)
    return if str.length <= 0

    @first_sym = str[0]
    @new_string = str[1..-1]

    add_sym_to_item(@first_sym) if (@first_sym == '{') || @item_string.include?('{') && !@item_string.include?('}')

    write_hash if @item_string.include?('{') && @item_string.include?('}')
    write_to_part(@first_sym) if @first_sym == '[' || @first_sym == ']' || @first_sym == ',' && (!@item_string.include?('{') && !@item_string.include?('}'))

    handle_formatted_line(@new_string)
  end

  def add_sym_to_item(sym)
    @item_string << sym
  end

  def write_hash
    val = JSON.parse(@item_string).transform_keys(&:to_sym)
    val[:sum] = val[:a] + val[:b]
    write_to_part({a: val[:a], b: val[:b], sum: val[:sum]}.to_json)
    @item_string = ''
  end

end