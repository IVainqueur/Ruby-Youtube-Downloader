require "uri"
require "httparty"
require "nokogiri"
require "./classes.rb"

def isYoutubeUrl?(url)
  if !url.include?("http") && url.include?("http")
    return false
  elsif !url.include?("youtube.com") && !url.include?("youtu.be")
    return false
  elsif url.include?(" ")
    return false
  end
  return true
end

# youtube url format 'https://youtu.be/<videoId>' -> 0
# youtube url format 'https://youtube.com/watch?v=<videoId>&list=<playlistId>' -> 1
def youtubeURLType(url)
  return nil unless isYoutubeUrl?(url)
  return url.include?("youtu.be") ? 0 : 1
end

def httpGetParams(url)
  return nil unless url.index("?")
  params = url[url.index("?") + 1..]
  Hash[URI.decode_www_form(params)]
end

def youtubeURLParse(url)
  return nil unless isYoutubeUrl? url
  params = httpGetParams url
  videoId = youtubeURLType(url) == 0 ? url.match(/youtu\.be\/([a-zA-Z0-9\-]+)/)[1] : (params == nil ? nil : params["v"])
  playlistId = params != nil ? params["list"] : nil
  isPlaylist = params != nil ? !!params["list"] : nil

  return nil if videoId == nil && !isPlaylist
  return {
           "videoId" => videoId,
           "playlistId" => playlistId,
           "isPlaylist" => isPlaylist,
           "isJustPlaylist" => videoId == nil && isPlaylist,
         }
end

def getAllFormats(url)
  p "https://www.youtube.com/watch?v=#{url["videoId"]}"
  response = HTTParty.post("https://www.y2mate.com/mates/analyze/ajax", {
    :body => {
      :url => "https://www.youtube.com/watch?v=#{url["videoId"]}",
      :q_auto => "1",
      :ajax => "1",
    },
  })
  parsed = JSON.parse response.body
  return nil if parsed["status"] != "success"
  parsedHTML = Nokogiri::HTML(parsed["result"])
  video = {}
  # video thumbnail
  video["thumbnail"] = parsedHTML.css(VideoMetaData.videoThumbnailSelector)[0].attributes["src"].to_s
  # video Name
  video["videoName"] = parsedHTML.css(VideoMetaData.videoNameSelector)[0].text
  # sizes
  video["sizes"] = []
  parsedHTML.css(VideoMetaData.videoSizeSelectors["row"]).to_a.each { |el|
    video["sizes"] << {
      "pixelRatio" => Nokogiri::HTML(el.to_s).css(VideoMetaData.videoSizeSelectors["pixelRatio"]).text,
      "fileSize" => Nokogiri::HTML(el.to_s).css(VideoMetaData.videoSizeSelectors["fileSize"]).text,
      "download" => {
        "ftype" => Nokogiri::HTML(el.to_s).at_css(VideoMetaData.videoSizeSelectors["download"]).attributes["data-ftype"].value,
        "fquality" => Nokogiri::HTML(el.to_s).at_css(VideoMetaData.videoSizeSelectors["download"]).attributes["data-fquality"].value,
      },
    }
  }
  # video k_id
  video["k_id"] = parsed["result"].match(VideoMetaData.video_k_id_selector)[1]
  video["videoId"] = url["videoId"]
  puts video
  return video
end

def getDownloadLink(videoId, k_id, quality, type)
  response = HTTParty.post("https://www.y2mate.com/mates/convert", {
    :body => {
      :type => "youtube",
      :_id => k_id,
      :v_id => videoId,
      :ajax => "1",
      :token => "",
      :ftype => type,
      :fquality => quality,
    },
  })
  parsed = JSON.parse response.body
  return nil if parsed["status"] != "success"
  parsedHTML = Nokogiri::HTML(parsed["result"])
  # The download link
  link = parsedHTML.at_css("a").attributes["href"]

  return link
end

def getPlaylistVideos(playlistId)
  puts VideoMetaData.ytVideoSelectors["parent"]
  response = HTTParty.get("https://www.youtube.com/playlist?list=#{playlistId}")
  File.open("test.html", "w") { |file| file.write(response.body) }
  parsedHTML = Nokogiri::HTML(response.body)
  videos = []
  # Find each video in the playlist
  parsedHTML.css(VideoMetaData.ytVideoSelectors["parent"]).to_a.each { |video|
    puts "in parent\n\n"
    videos << {
      "thumbnail": Nokogiri::HTML(video.to_s).at_css(VideoMetaData.ytVideoSelectors["thumbnail"]).attributes["src"],
      "link": Nokogiri::HTML(video.to_s).at_css(VideoMetaData.ytVideoSelectors["link"]).attributes["href"],
      "title": Nokogiri::HTML(video.to_s).at_css(VideoMetaData.ytVideoSelectors["title"]).text,

    }
  }
  p videos
  return videos
end
