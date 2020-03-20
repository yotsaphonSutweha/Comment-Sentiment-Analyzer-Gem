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

    def loadFile(fileName)
        @file = File.read(fileName)
        @sentimentWords = JSON.parse(@file)
        return @sentimentWords
    end

    def loadProfaneWords(filePath)
        @profaneWords = CSV.read(filePath)
        return @profaneWords
    end

    def setFilePath(filePath)
        @sentimentWords = self.loadFile(filePath)
    end

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
        @finalScore = self.analyzer(comment)[0][:totalScore]
        @sentimentResult = self.sentimentClassifier(@finalScore)
        return @sentimentResult
    end
end 


