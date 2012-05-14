#! /usr/bin/ruby1.9.1
# -*- coding: UTF-8 -*-

require 'graph'
require 'graphs/gdf'

CSV = File.open('explications_rts.csv', 'w')

cols = ['"numéro"', '"taille de G0 (noeuds)"', '"taille de G0 (liens)"']

['G0','un voisinage dans G0', 'Gf', 'un voisinage dans Gf'].each {|exp|
    cols << "\"RT expliqués par #{exp}\""
}

CSV.write(cols.join(';')+"\n")

def percent(a, b)
    (a.to_f*100/b).round(2)
end

def frenchize(e)
    (e.is_a? Float) ? e.to_s.gsub(/\./, ',') : e
end

# liste tous les voisins d'un element dans un ensemble de liens
def neighborhood(edges, el)
    neighbours = []
    edges.each { |e|
        neighbours << e['to'] if e['from'] == el
    }
    neighbours
end

('001'..'124').each { |n|

    grt = GDF::load("../../graphs/GRT/#{n}_grt.gdf")
    gf  = GDF::load("../../graphs/Gf/#{n}_gf.gdf")
    g0  = GDF::load("../../graphs/#{n}_previous.gdf")

    # on ne garde que {'from'=>…, 'to'=>…} pour les liens des graphs
    # sauf GRT avec l'epoch
    gf_edges = gf.edges.to_a.map {|e|
        {'from' => e['node1'].downcase, 'to'=> e['node2'].downcase}
    }

    g0_edges = g0.edges.to_a.map {|e|
        {'from' => e['node1'].downcase, 'to'=> e['node2'].downcase}
    }
    
    grt_edges = grt.edges.to_a.map {|e|
        {'from' => e['node1'].downcase, 'to'=> e['node2'].downcase,
            'epoch'=> e['epoch']}
    }

    nb_rts = grt_edges.length

    # explications des RTs
    expls = {
        'g0'=>0,  # G0
        'vg0'=>0, # voisinage dans G0
        'gf'=>0,  # Gf
        'vgf'=>0  # voisinage dans Gf
    }

    # on fait une liste chronologique des RT
    grt_edges.sort_by! {|rt| rt['epoch']}

    # on supprime l'epoch
    grt_edges.map! {|e| {'from' => e['from'], 'to' => e['to']} }

    # pour chaque RT
    grt_edges.each_index {|i|

        # expliqué par G0
        if (g0_edges.include?(grt_edges[i]))
            expls['g0'] += 1
        end

        catch(:vg0_explicated) {

            # voisins de l'auteur du RT courant dans G0
            neighbours = neighborhood(g0_edges, grt_edges[i]['from'])

            # pour chaque précédent RT
            grt_edges.slice(0, i).each {|prev_rt|

                # expliqué par un voisinage dans G0
                if (neighbours.include?(prev_rt['from']))
                    expls['vg0'] += 1
                    throw :vg0_explicated
                end
            }
        }

        # expliqué par Gf
        if (gf_edges.include?(grt_edges[i]))
            expls['gf'] += 1
        end

        catch (:vgf_explicated) {

            # voisins de l'auteur du RT courant dans Gf
            neighbours = neighborhood(gf_edges, grt_edges[i]['from'])

            # pour chaque précédent RT
            grt_edges.slice(0, i).each {|prev_rt|

                # expliqué par un voisinage dans Gf
                if (neighbours.include?(prev_rt['from']))
                    expls['vgf'] += 1
                    throw :vgf_explicated
                end
            }
        }
    }

    cols = [n,                             # id du graph
            g0.nodes.length,               # nombre de noeuds
            g0.edges.length,               # nombre de liens
            percent(expls['g0'], nb_rts),  # % de RT expliqués par g0
            percent(expls['vg0'], nb_rts), # % de RT expliqués par un voisinage dans g0
            percent(expls['gf'], nb_rts),  # % de RT expliqués par gf
            percent(expls['vgf'], nb_rts)  # % de RT expliqués par un voisinage dans gf
    ]

    CSV.write(cols.map{|c| frenchize(c)}.join(';')+"\n")
}

CSV.close
