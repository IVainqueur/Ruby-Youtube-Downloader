# The needed requests
### Find all available video qualities
`request`
```curl
curl -X POST \
  'https://www.y2mate.com/mates/analyze/ajax' \
  --header 'Accept: */*' \
  --header 'User-Agent: Thunder Client (https://www.thunderclient.com)' \
  --form 'url="https://www.youtube.com/watch?v=7AS9r_E0PY4"' \
  --form 'q_auto="1"' \
  --form 'ajax="1"'
```
`response sample`
```json
{
  "status": "success",
  "result": "<div>HTML data to display or parse"
}
```

### Find link to single quality
`request`
```curl
curl -X POST \
  'https://www.y2mate.com/mates/convert' \
  --header 'Accept: */*' \
  --header 'User-Agent: Thunder Client (https://www.thunderclient.com)' \
  --form 'type="youtube"' \
  --form '_id="6330c6fbf99cc5981c8b45c7"' \
  --form 'v_id="7AS9r_E0PY4"' \
  --form 'ajax="1"' \
  --form 'token=""' \
  --form 'ftype="mp4"' \
  --form 'fquality="1080"'
```

`response sample`
```json
{
  "status": "success",
  "result": "[html content that contains an Ancor tag with class 'btn btn-success btn-file' whose href attribute is the link to the file download ]"

}


