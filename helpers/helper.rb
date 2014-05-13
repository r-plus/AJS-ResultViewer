#!/usr/bin/env ruby

helpers do
  def app_root
    "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  end
end
