#! /usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require 'graph'
require 'graphs/gdf'
require 'json'

# -- configuration
graph_file_str = '../../graphs/%s_interactions.json'
Output_dir = '../../graphs/GRT'
# -- /configuration

if !Dir.exists?(Output_dir)
    Dir.mkdir Output_dir
end

('001'..'124').each { |n|

    interactions = JSON.parse(File.read(graph_file_str % n))['interactions']

    users = []
    rts = []

    nodes = []
    edges = []

    interactions.each { |i|

        i['user'].downcase!

        i['rt'].downcase! if (i['rt'])

        if !users.include?(i['user'])
            node = {'name'=>i['user'], 'nid'=>i['id']}
            node['epoch'] = i['epoch']
            #node['start'] = i['date']
            node['date'] = i['date']
            users << i['user']
            nodes << node
        end

        if (i['rt'])

            if rts.include?([i['user'], i['rt']])
                ind = rts.find_index([i['user'], i['rt']])
                edges[ind]['_weight'] += 1
            else
                rt = {'node1'=>i['user'], 'node2'=>i['rt'], '_weight'=>1}
                rt['eid'] = i['id']
                rt['epoch'] = i['epoch']
                #rt['start'] = i['date']
                rt['date'] = i['date']

                edges << rt if !edges.include?(rt)
                rts << [i['user'], i['rt']]
            end
        end
    }

    g = Graph.new(nodes, edges)

    g.write("#{Output_dir}/#{n}_grt.gdf", {:gephi=>true})
    puts "#{n}/124"
}
