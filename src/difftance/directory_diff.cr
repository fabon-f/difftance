module Difftance
  module DirectoryDiff
    extend self

    def list_files(dir)
      Dir.cd(dir) do
        return Dir.glob("**/*", match_hidden: true).select{ |f| File.info(f).file? }
      end
    end

    def exec(dir1 : String, dir2 : String, costs : Hash(Symbol, Int))
      files1 = list_files(dir1)
      files2 = list_files(dir2)

      hash1 = Hash.zip(files1, Array.new(files1.size, true))
      hash2 = Hash.zip(files2, Array.new(files2.size, true))

      hash1.merge(hash2).each_key do |f|
        if !hash1.has_key?(f)
          content = Difftance::FileUtils.read_textfile(Path.new(dir2, f))
          if content.nil?
            puts "#{f} (created): binary or unsupported encoding"
            next
          end
          puts "#{f} (created): #{Difftance::EditDistance.edit_distance("", content)}"
        elsif !hash2.has_key?(f)
          content = Difftance::FileUtils.read_textfile(Path.new(dir1, f))
          if content.nil?
            puts "#{f} (deleted): binary or unsupported encoding"
            next
          end
          puts "#{f} (deleted): #{Difftance::EditDistance.edit_distance(content, "")}"
        else
          content1, content2 = {dir1, dir2}.map{|d| Difftance::FileUtils.read_textfile(Path.new(d, f)) }
          if content1.nil? || content2.nil?
            puts "#{f}: binary or unsupported encoding"
            next
          end
          distance = Difftance::EditDistance.edit_distance(content1, content2)
          puts "#{f}: #{distance}"
        end
      end
    end
  end
end
