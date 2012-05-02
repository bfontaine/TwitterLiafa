#! /usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require 'graph'
require 'graphs/gdf'

Root_dir = '../..'

csv = File.open('stats_intersections.csv', 'w')

csv.write('numéro de fichier,nombre de noeuds,') #nombre de comptes privés/supprimés (cps),')
csv.write('nombre de liens dans G0,')
csv.write('nombre de liens dans Gf,nombre de liens dans l\'intersection,')
csv.write('taux de recouvrement sur G0 (TrG0),taux de recouvrement sur Gf (TrGf),')
csv.write('TrG0 sans les inactifs (<5tweets),TrGf sans les inactifs (<5 tweets)')
csv.write("TrG0 sans les cps,TrGf sans les cps\n")

inactives = []
cps       = []



('001'..'124').each {|n|

    g0 = GDF::load("#{Root_dir}/graphs/#{n}_previous.gdf")
    gf = GDF::load("#{Root_dir}/graphs/Gf/#{n}_gf.gdf")

    g0_edges = g0.edges.map{ |e|
        { 'node1'=>e['node1'], 'node2'=>e['node2'] }
    }

    intersec = gf.edges & g0_edges

    g0nodesize = g0.nodes.size
    g0edgesize = g0.edges.size
    gfedgesize = gf.edges.size
    intersecsize = intersec.size


    fields = [n, g0nodesize, g0edgesize, gfedgesize, intersecsize]

    fields << (intersecsize.to_f / g0edgesize)
    fields << (intersecsize.to_f / gfedgesize)



    csv.write(fields.join(',')+"\n")
}

csv.close
