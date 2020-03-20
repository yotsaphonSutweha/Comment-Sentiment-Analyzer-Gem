require_relative './../sentimentanalyzer.rb'
require 'test/unit'

class SentimentanalyzerTest < Test::Unit::TestCase 
    def test_load_file
        sentimentAnalyzer = SentimentAnalyzer.new
        data = sentimentAnalyzer.loadFile('./word_bank/words.json')
        assert_not_nil(true, data)
    end

    def test_load_profane_words
        sentimentAnalyzer = SentimentAnalyzer.new
        data = sentimentAnalyzer.loadProfaneWords('./word_bank/bad-words.csv')
        assert_not_nil(true, data)
    end

    def test_set_file_path
        sentimentAnalyzer = SentimentAnalyzer.new
        data = sentimentAnalyzer.setFilePath('./word_bank/words.json')
        assert_not_nil(true, data)
    end

    def test_analyzer
        sentimentAnalyzer = SentimentAnalyzer.new
        actual_result = sentimentAnalyzer.analyzer('good')
        expected_result = [{:result=>[{:key=>'good',:score=>0.0}],:totalScore => 0.0}]
        assert_equal(actual_result, expected_result)
    end

    def test_profane_words_filter
        sentimentAnalyzer = SentimentAnalyzer.new
        sentimentAnalyzer.loadProfaneWords('./word_bank/bad-words.csv')
        actual_result = sentimentAnalyzer.profaneWordsFilter('shit')
        expected_result = false
        assert_equal(expected_result, actual_result)
    end

    def test_sentiment_classifier
        sentimentAnalyzer = SentimentAnalyzer.new
        actual_result = sentimentAnalyzer.sentimentClassifier(1)
        expected_result = 'Positive'
        assert_equal(expected_result, actual_result)
    end

    def test_comment_sentiment_analyzer 
        sentimentAnalyzer = SentimentAnalyzer.new
        sentimentAnalyzer.setFilePath('./word_bank/words.json')
        actual_result = sentimentAnalyzer.commentSentimentAnalyzer('This is good')
        expected_result = 'Positive'
        assert_equal(expected_result, actual_result)
    end
end
