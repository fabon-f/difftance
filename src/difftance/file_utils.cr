module Difftance
  module FileUtils
    extend self

    def read_textfile(path : String | Path)
      content = File.read(path)
      return content if content.valid_encoding?

      begin
        content = String.new(content.to_slice, "Shift_JIS")
        return content if content.valid_encoding?
      rescue exception
      end

      # binary or unsupported encoding
      nil
    end
  end
end
