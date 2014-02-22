require 'sinatra'
require 'open-uri'
require 'uri'
require 'twilio-ruby'
require 'htmlentities'

KEY = ''

get '/' do
	coder = HTMLEntities.new
	get_translation params['Body']
	twiml = Twilio::TwiML::Response.new do |r|
		coder.decode(r.Message get_translation params['Body'])
	end
	coder.decode(twiml.text)
end

def detect_language q
	source = open(URI.escape("https://www.googleapis.com/language/translate/v2/detect?key=#{KEY}&q=#{q}")).read
	start = source.index('"language": "') + '"language": "'.length
	language = source[start] + source[start+1]
	language
end

def get_translation q
	source = open(URI.escape("https://www.googleapis.com/language/translate/v2?key=#{KEY}&q=#{q}&source=#{detect_language q}&target=en")).read
	start = source.index('"translatedText": "') + '"translatedText": "'.length
	text = source[start, start]
	text = text[0, text.index('"')]
	text
end
