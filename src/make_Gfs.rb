#! /usr/bin/ruby1.9.1

require 'json'

# -- configuration
graph_files = Dir.glob('../graphs/*_previous.gdf')
Friends_ids_dir = '../json-utils/friends_ids'
Output_dir = '../graphs/Gf'
# -- /configuration


if !Dir.exists?(Output_dir)
    Dir.mkdir Output_dir
end

def get_friends_ids(name)
    if !File.exists?("#{Friends_ids_dir}/#{name}.json")
        puts "No friends_ids data for @#{name}"
        return []
    end

    begin
        return JSON.parse(File.read("#{Friends_ids_dir}/#{name}.json"))
    rescue JSON::ParserError => err
        puts err.message
        return []
    end
end
