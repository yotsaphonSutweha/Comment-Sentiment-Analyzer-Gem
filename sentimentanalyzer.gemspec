Gem::Specification.new do |s|
    s.name = 'sentimentanalyzer'
    s.version = '0.1.3'
    s.date = '2020-02-20'
    s.summary = "Sentiment analyzer"
    s.description = "A gem that does sentiment analysis and profane words filter on provided text. Cloud Application Development project 2020"
    s.authors = ["YotsaphonS"]
    s.email = 'yotsaphon2018@gmail.com'
    s.files = ["lib/sentimentanalyzer.rb"]
    s.add_dependency "json"
    s.add_dependency "tokenizer"
    s.add_dependency "csv"
end