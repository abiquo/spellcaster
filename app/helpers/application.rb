def stage_string(id)
  Sinatra::Application.post_stage_strings[id]
end
