class WordProcessor

  def self.wordcount text
    text.split.count
  end

end

WordProcessor.wordcount(@article.text)
