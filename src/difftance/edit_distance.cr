module Difftance
  module EditDistance
    extend self

    def edit_distance(before before_str : String, after after_str : String, costs = { deletion: 1, insertion: 1, substitution: 1 })
      if costs[:deletion] == 1 && costs[:insertion] == 1 && costs[:substitution] == 2
        edit_distance_no_substitution(before_str, after_str)
      else
        dp(before_str, after_str, costs)
      end
    end

    # Wagner–Fischer algorithm
    def dp(before before_str : String, after after_str : String, costs = { deletion: 1, insertion: 1, substitution: 1 })
      before_chars = before_str.chars
      after_chars = after_str.chars
      ins = costs[:insertion]
      del = costs[:deletion]
      sub = costs[:substitution]
      dp = Array.new(before_chars.size + 1) { |i| i == 0 ? Array.new(after_chars.size + 1) { |j| j * ins } : Array.new(after_chars.size + 1) { |j| j == 0 ? i * del : 0 } }
      (1..before_chars.size).each do |i|
        (1..after_chars.size).each do |j|
          a = dp[i][j - 1] + ins
          b = dp[i - 1][j] + del
          c = dp[i - 1][j - 1] + (before_chars[i - 1] == after_chars[j - 1] ? 0 : sub)
          dp[i][j] = a > b ? (b > c ? c : b) : (a > c ? c : a)
        end
      end

      dp.last.last
    end

    # Wu, S., Manber, U., Myers, E.W., & Miller, W. (1990). An O(NP) Sequence Comparison Algorithm. Inf. Process. Lett., 35, 317-323.
    # https://api.semanticscholar.org/CorpusID:9968782
    # ins=1, del=1, sub=2(disallowing substitution)
    def edit_distance_no_substitution(str1 : String, str2 : String)
      chars1, chars2 = str1.size < str2.size ? {str1.chars, str2.chars} : {str2.chars, str1.chars}

      delta = chars2.size - chars1.size
      offset = chars1.size + 1
      dd = delta + offset

      fp = Array.new(chars1.size + chars2.size + 3) { -1 }

      p = 0
      while fp[dd] != chars2.size
        (-p).upto(delta - 1) do |k|
          kk = k + offset
          v0 = fp[kk - 1] + 1
          v1 = fp[kk + 1]
          fp[kk] = snake(k, (v0 > v1 ? v0 : v1), chars1, chars2)
        end
        (delta + p).downto(delta + 1) do |k|
          kk = k + offset
          v0 = fp[kk - 1] + 1
          v1 = fp[kk + 1]
          fp[kk] = snake(k, (v0 > v1 ? v0 : v1), chars1, chars2)
        end
        v0 = fp[dd - 1] + 1
        v1 = fp[dd + 1]
        fp[dd] = snake(delta, (v0 > v1 ? v0 : v1), chars1, chars2)
        p += 1
      end
      delta + (p - 1) * 2
    end

    private def snake(k : Int, y : Int, str1 : Array(Char), str2 : Array(Char))
      x = y - k
      while x < str1.size && y < str2.size && str1[x] == str2[y]
        x += 1
        y += 1
      end
      y
    end
  end
end
