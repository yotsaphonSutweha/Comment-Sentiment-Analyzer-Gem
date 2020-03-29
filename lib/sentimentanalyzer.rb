require 'json'
require 'tokenizer'
require 'csv'

class SentimentAnalyzer
    def initialize()
        @file = nil,
        @sentimentWords = '',
        @score = 0,
        @totalScore = 0,
        @sentimentScore = '',
        @finalScore = 0,
        @sentimentResult = ''
        @profaneWords = ''
        @cleanContent = true
    end

    # Load JSON file from the word bank for sentiment analysis
    def loadFile(fileName)
        @file = File.read(fileName)
        @sentimentWords = JSON.parse(@file)
        return @sentimentWords
    end

    # Load CSV file from the word bank for profanity detection
    def loadProfaneWords(filePath)
        @profaneWords = CSV.read(filePath)
        return @profaneWords
    end

    def setFilePath(filePath)
        @sentimentWords = self.loadFile(filePath)
    end

    # The method that is responsible for analyzing the comment. It tokenises the comment individual word, and compare if the word is contained within the JSON word bank. If so, get the score of that word and use hash to store the word and the score.
    def analyzer(comment)
        @totalScore = 0
        @result = []
        @finalSentimentOutput = []
        @tokenizer = Tokenizer::WhitespaceTokenizer.new
        @tokensizedComment = @tokenizer.tokenize(comment)
        @tokensizedComment.each do |word|
            @score = @sentimentWords[word].to_f
            @totalScore += @score
            @result.push({"key": word, "score": @score})
        end

        @finalSentimentOutput.push({"result": @result, "totalScore": @totalScore})
        
        return @finalSentimentOutput
    end

    # This method is for profanity detection, again it tokenises the the comment and checks if there is any matches within the CSV file word bank. If so, it's will return false, saying that the content is not clean -> profane words are detected.
    def profaneWordsFilter(content)
        @cleanContent = true
        @tokenizer = Tokenizer::WhitespaceTokenizer.new
        @content = content.to_s
        @tokenizedContent = @tokenizer.tokenize(@content)
        @tokenizedContent.each do |word|
           if @profaneWords.include?([word])
                @cleanContent = false
           end
        end
        return @cleanContent
    end

    # The classifier method that uses the score to determine the sentiment
    def sentimentClassifier(totalScore)
        @sentimentScore = ""
        @totalScore = totalScore
        if @totalScore > 0
            @sentimentScore = "Positive"
        elsif @totalScore < 0
            @sentimentScore = "Negative"
        elsif @totalScore == 0
            @sentimentScore = "Neutral"
        end
        return @sentimentScore
    end

    def commentSentimentAnalyzer(comment)
        # Get the final score from the analyer
        @finalScore = self.analyzer(comment)[0][:totalScore]
        # Get the sentiment result by using the classifer that takes the final score as the parameter
        @sentimentResult = self.sentimentClassifier(@finalScore)
        return @sentimentResult
    end
end 


