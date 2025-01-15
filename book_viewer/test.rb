# require_relative "data/"

def paragraphs(text)
  text.split("\n\n").map do |line|
    "<p>#{line}</p>"
  end.join("\n\n")
end

puts paragraphs(File.read("data/chp1.txt"))