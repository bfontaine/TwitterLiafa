#! /usr/bin/ruby1.9.1

require 'json'
require_relative './twitterapi'

usernames = JSON.parse(File.read('all_usernames_uniq.json'))

dict = {}
unauthorized = []
unexist =      []

usernames.each {|u| dict[u] = nil}

api_method = 'GET friends/ids'
api_params = {'include_entities' => false}

log = File.open('extract_friends_infos.log', 'a')

usernames.each {|u|

    err_nb = 0

    params = {}.update api_params
    params['screen_name'] = u

    while (err_nb != -1)

        begin
            resp = JitaTwitterAPI::call(api_method, params)
            err_nb = -1
        rescue JitaTwitterAPI::TwitterAPIError => err
            # 401 error
            if (err.hash['text'].to_s.start_with?('401'))
                unauthorized << u
                dict[u] = []
                next
            end
            # user does not exist anymore
            if (err.hash.is_a?(Hash) && err.hash['error']=='Not found')
                unexist << u
                dict[u] = []
                next
            end

            log.write("Error: #{err.hash} (username:#{u}), waiting 1sec\n")
            err_nb += 1
            sleep 1

        rescue JSON::ParserError => jpe

            log.write("JSON ParserError: #{jpe} (username:#{u}), waiting 1sec\n")
            err_nb += 1
            sleep 1

        rescue RateLimitExceeded => rle

            log.write("Rate limit exceeded. ")

            limit, reset = @@co.rate_limit_status
            
            remaining = reset - Time.now.to_i

            log.write("Waiting #{remaining} seconds.\n")
            sleep remaining

        end

        if (err_nb > 5)
            log.write("5 errors with @#{username}, skipping")
            err_nb = -1
            dict[u] = []
            next
        end

    end

    puts u
}

f = File.open('friends.json', 'w')
f.write(JSON.unparse(dict))
f.close
puts "'friends.json' saved."
