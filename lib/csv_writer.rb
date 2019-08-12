require 'csv'


class CsvWriter

  def initialize(output_path, header = %w[name price image])
    @output_path = output_path
    @@writer = CSV.open(output_path, 'a',
                        write_headers: true, headers: header)
  end

  def self.writer
    @@writer
  end
end