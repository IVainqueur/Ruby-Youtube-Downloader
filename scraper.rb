require "sinatra"
require "./utils.rb"

set :port, 80
set :bind, "0.0.0.0"

get "/" do
  erb :index
end

post "/search" do
  return "Go back" if params["downloader"] == nil
  return "Missing URL" if params["url"] == nil

  parsed = youtubeURLParse params["url"]

  return "Invalid URL" if parsed == nil

  puts "the video is #{parsed["videoId"]}"
  erb :formats, :locals => {
                  :videos => getAllFormats(parsed),
                }
end

get "/download/:videoId/:k_id/:quality/:type" do
  puts params
  redirect getDownloadLink(params["videoId"], params["k_id"], params["quality"], params["type"])
end
