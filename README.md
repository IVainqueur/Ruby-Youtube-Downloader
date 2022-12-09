# Sinatra101

Here I am learning the basics of Sinatra to then be able to move onto _Ruby On Rail_


| ruby                  | js equivalent                 |
| --------------------- | ----------------------------- |
| `params`              | `req.params` \| `req.query`   |
| `headers`             | `req.headers` \| `res.header` |
| `status`              | `res.status`                  |
| `data.to_json`        | `res.json(data)`              |
| `redirect '/newpath'` | `res.redirect('/newpath')`    |

## tips

### Sending file as download

```ruby
require 'sinatra'

get '/' do
  send_file 'test.txt', :disposition => 'attachment', :filename => 'customname.txt'
end
```

In the snippet above, the file `test.txt` will be considered as a **download** by the browser and be downloaded as `customname.txt`

### templates with `.erb`

The ruby file (say `server.rb`)

```ruby
require 'sinatra'

get '/dashboard' do
  erb :dashboard, :locals => {
    :username => "IVainqueur",
    :history => [
        'https://github.com/IVainqueur/package-mover',
        'https://github.com/IVainqueur/auto-push',
        'https://github.com/IVainqueur/swaggerbuilder'
    ]
    }
end
```

the template `views/dashboard.erb`

```erb
<div>
  <p>Welcome, <%= username %>!</p>
  <p>You recently visited the following repos: </p>
  <ul>
  <% history.each do |repo| %>
    <a href="<%= repo %>">
        <li><%= repo.gsub('https://github.com/', '') %></li>
    </a>
  <% end %>
  </ul>
</div>
```


# Project Built: Youtube Video and Playlist downloader

After learning the basics of Sinatra and a little about web scraping with Ruby, I made a simple Youtube Scraper.

- It can take youtube url, determine weather it is a link to a video or a playlist. 
- If it's a video, it goes ahead and scrapes Y2mate website for the video's download link.
- If the provided link is a playlist link, the scraper first scrapes the youtube page to get all the videos' links and then scrapes on y2mate for each video individually .