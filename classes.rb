class VideoMetaData
  @videoThumbnailSelector = ".video-thumbnail img"
  @videoNameSelector = ".caption b"
  @videoSizeSelectors = {
    "row" => "tbody tr",
    "pixelRatio" => "tr td:first-child",
    "fileSize" => "tr td:nth-child(2)",
    "download" => "tr td:last-child a",
  }
  @ytVideoSelectors = {
    "parent" => "ytd-playlist-video-renderer",
    "thumbnail" => "ytd-thumbnail yt-image img",
    "link" => "ytd-thumbnail a",
    "title" => "h3",

  }
  @video_k_id_selector = /var k__id\s=\s\"(\w+)\"/

  class << self
    attr_reader :videoThumbnailSelector
    attr_reader :videoNameSelector
    attr_reader :videoSizeSelectors
    attr_reader :video_k_id_selector
    attr_reader :ytVideoSelectors
  end

  def initialize
  end
end
