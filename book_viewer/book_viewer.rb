require "sinatra"
require "sinatra/reloader" if development?

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |paragraph, idx|
      "<p id=paragraph#{idx}>#{paragraph}</p>"
    end.join("\n\n")
  end

  def strong(full_text, strong_text)
    full_text.gsub(strong_text) do |match|
      if match.downcase.casecmp?(strong_text.downcase)
        match.chars.map { |letter| "<strong>#{letter}</strong>" }.join
      end
    end
  end
end

get "/" do
  @title = 'The Adventures of Sherlock Holmes'

  erb :home
end

get "/chapters/:number" do
  @chapter_number = params[:number].to_i
  redirect "/" unless (1..@contents.size).include? @chapter_number

  @chapter = File.read("data/chp#{@chapter_number}.txt")
  chapter_name = @contents[@chapter_number - 1]
  @title = "Chapter #{@chapter_number}: #{chapter_name}"

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])

  erb :search
end

def each_chapter
  @contents.each_with_index do |chapter, idx|
    number = idx + 1
    contents = File.read("data/chp#{number}.txt")
    yield chapter, number, contents
  end
end

def chapters_matching(query)
  results = []

  return results unless query

  each_chapter do |chapter, number, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, idx|
      matches[idx] = paragraph if paragraph.downcase.include? query.downcase
    end

    results << { number: number, name: chapter, paragraph: matches } if matches.any?
  end

  results
end

not_found do
  redirect "/"
end
