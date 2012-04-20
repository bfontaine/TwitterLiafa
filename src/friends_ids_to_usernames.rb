#! /usr/bin/ruby1.9.1

require 'json'

filenames = Dir.glob('./friends_raw_data-partial-*.partial.json')
if (filenames.length == 0)
    puts 'fichier des ids de friends :'
    friends_ids_filename = gets.chomp
else
    friends_ids_filename = filenames.sort[-1]
end

friends_ids = JSON.parse(File.read(friends_ids_filename))

usernames_ids = JSON.parse(File.read('./cache_ids.json'))

ids_usernames = {}
usernames_ids.each_pair {|username,id| ids_usernames[id] = username}


friends_usernames = {}
friends_ids.each_key {|k| friends_usernames[k] = []}

friends_ids.each_pair { |user, ids|

    if (ids.nil?)
        next
    end

    ids.each {|id|
        if (ids_usernames.has_key? id)
            friends_usernames[user] << ids_usernames[id]
        end

    }
}

f = File.open('friends_usernames.json', 'w')
f.write(JSON.unparse(friends_usernames))
f.close
