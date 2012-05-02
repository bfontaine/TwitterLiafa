#! /usr/bin/ruby1.9.1

require 'graph'
require 'graphs/gdf'
require 'json'

GRAPHS_DIR = '../../donnees_2012-02-28/*.gdf'

puts "filename,nodes,edges,most_popular,friends_gt_5000"

json = []

Dir.glob(GRAPHS_DIR).each {|f|

   g = GDF.load(f)

   # >5000 friends
   lot_of_friends = []
   lot_of_friends_nb_names = []
   lot_of_friends_nb_nb = []

   g.nodes.each {|n|
       if n['friends'] > 5000
           lot_of_friends << n['name']
       end

       lot_of_friends_nb_names << n['name']
       lot_of_friends_nb_nb    << n['friends']
   }


   # most popular
   max_friends = lot_of_friends_nb_nb.max
   most_popular = (max_friends.nil?)?'null':lot_of_friends_nb_names[lot_of_friends_nb_nb.find_index(max_friends)]

   puts "#{f},\t#{g.nodes.size},\t#{g.edges.size},\t#{most_popular} (#{max_friends}),\t#{JSON.unparse(lot_of_friends)}"

   json << [f, g.nodes.size, g.edges.size, most_popular, max_friends, lot_of_friends]
}

File.open('stats_graphes.json', 'w').write(JSON.unparse(json))
