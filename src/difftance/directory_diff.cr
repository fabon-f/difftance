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
          puts "#{f} (created): #{Difftance::EditDistance.edit_distance("", File.read(Path.new(dir2, f)))}"
        elsif !hash2.has_key?(f)
          puts "#{f} (deleted): #{Difftance::EditDistance.edit_distance(File.read(Path.new(dir1, f)), "")}"
        else
          content1, content2 = {dir1, dir2}.map{|d| File.read(Path.new(d, f)) }
          distance = Difftance::EditDistance.edit_distance(content1, content2)
          puts "#{f}: #{distance}"
        end
      end
    end
  end
end
