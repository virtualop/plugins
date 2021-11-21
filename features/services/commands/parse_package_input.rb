param! "input"

run do |input|
  input.split("\n").flat_map do |line|
    # lines can end in backslash + newline for continuation on the next line,
    # we can filter this out since we're merging all lines together in the end
    words = line.tr("\\", " ").split(" ")

    # all of these known words are filtered out from the beginning of the line
    known = %w|sudo apt-get apt install -y|
    known.each do |word|
      words.shift if words.first == word
    end

    words
  end
end
