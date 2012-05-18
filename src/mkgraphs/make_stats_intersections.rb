#! /usr/bin/ruby1.9.1
# -*- coding: UTF-8 -*-

require 'graph'
require 'graphs/gdf'
require 'json'
require 'uri'
require 'net/http'

CSV = File.open('stats_intersections.csv', 'w')

_cols = ['G0 & GRT', 'Gf & GRT', 'G0 & Gf & GRT']

cols = ['"numéro"', '"taille de G0 (noeuds)"', '"taille de G0 (liens)"']

_cols.each { |c|
    cols << "\"#{c} (recouvrement GRT)\""
}

cols << '"Gf & GRT & ~G0 (recouvrement GRT"'
cols << '"Domaine de l\'URL"'
cols << '"Sujet"'
cols << '"URL"'

CSV.write(cols.join(';')+"\n")

def resolve_url(u)
    uri = URI(u)
    Net::HTTP.new(uri.host, uri.port).get(uri.path).header['location'] || u
end

def percent(a, b)
    (a.to_f*100/b).round(2)
end

def frenchize(e)
    (e.is_a? Float) ? e.to_s.gsub(/\./, ',') : e
end

domain_regex = /^https?:\/\/(?:[^.]+\.)?([^.]+\.[^\/]+)\//
short_urls = ['bit.ly', 'goo.gl']
topics_kw = {
             'politic' => ['socialiste', 'ump', 'guaino', 'sarkozy', 'gueant',
                           'hollande', 'politique', 'u-m-p', 'nkm', 'halal',
                           'rigueur', 'kosciusko', 'je-suis-musulmane',
                           'noirs-et-blancs', 'l-euro', 'dette-americaine',
                           'aphatie',
                           # manuel
                           'spartacusk99', '01012392023-c', '1275401-2013438776.',
                           '1675801-2613239177.'],
             'sport' => ['football', 'rugby', 'basket', 'psg'],
             'music' => ['chartsinfrance'],
             'misc' => ['immoler', 'grippe', 'costa', 'bisexuelle', 'vodka',
                        'antivol', 'maurice-andre', 'diablo-3', 'un-pere',
                        'toilettes', 'seisme', 'la-terre-a',
                        'attentat', 'sticks-arcade', 'finance', 'acrimed',
                        # manuel
                        '1875001-2913930308.', 'nadien/chroniques/335936'],
             'cinema' => ['oscar', 'the-artist', 'dujardin', 'cinema',
                          # manuel
                          '01012392466-c'],
             'television' => ['al-jezira', 'the-voice', 'petit-journal'],
             'Web/IT' => ['apple', 'open-data', 'geek', 'android', 'internet',
                          'anonymous', 'facebook', 'social-media', 'le-stylet',
                          'reseaux-sociaux', 'twitter', 'tweet', 'youtube', 'mashable'],
             'international' => ['homs', 'saoudien',
                                 # manuel
                                 '.me/s/6lH7k']
            }

('001'..'124').each { |n|

    grt = GDF::load("../../graphs/GRT/#{n}_grt.gdf")
    #gf  = GDF::load("../../graphs/Gf/#{n}_gf.gdf")
    g0  = GDF::load("../../graphs/#{n}_previous.gdf")

    gi_0_rt   = GDF::load("../../graphs/intersections/grt-g0/#{n}_intersec_grt_g0.gdf")
    gi_f_rt   = GDF::load("../../graphs/intersections/grt-gf/#{n}_intersec_grt_gf.gdf")
    gi_0_f_rt = GDF::load("../../graphs/intersections/grt-g0-gf/#{n}_intersec_grt_g0_gf.gdf")

    search_f = File.open("../../graphs/#{n}.search", 'r')
    url = ''
    topic = 'unknow'

    while url == '' && !search_f.eof?
        search_result = JSON.parse(search_f.readline)
        url = search_result['entities']['urls'][0]['expanded_url']
        short_urls.each { |u|
            # si l'URL est raccourcie, on ne la prend pas
            # ou alors on la garde s'il n'y en a pas d'autres
            next if url.include? u
        }
    end

    # si on a que des URL raccourcies, on essaye d'en étendre une
    url = resolve_url(url)

    topics_kw.each_pair {|t, kws|
        kws.each {|kw|
            if url.downcase.include?(kw)
                topic = t
                break
            end
        }
    }

    # domain de l'url
    domain_match = domain_regex.match(url) #.captures[0]
    domain = domain_match ? domain_match.captures[0] : '<unknow>'

    # num, taille graph (noeuds, liens), % G0&GRT (liens),
    # % Gf&GRT (liens), % G0&Gf&GRT (liens)

    gf_and_grt = percent(gi_f_rt.edges.length, grt.edges.length)
    gf_and_grt_and_g0 = percent(gi_0_f_rt.edges.length, grt.edges.length)

    cols = [n,                                               # id du graph
            g0.nodes.length,                                 # nombre de noeuds
            g0.edges.length,                                 # nombre de liens
            percent(gi_0_rt.edges.length, grt.edges.length), # G0&Gf / GRT
            gf_and_grt,                                      # Gf&GRT / GRT
            gf_and_grt_and_g0,                               # Gf&GRT&G0 / GRT
            (gf_and_grt - gf_and_grt_and_g0).round(2),       # Gf&GRT / GRT - Gf&GRT&G0 / GRT
            domain.capitalize,                               # domaine de l'URL du spread
            topic.capitalize,                                # sujet
            url                                              # URL
    ]

    CSV.write(cols.map{|c| frenchize(c)}.join(';')+"\n")
}

CSV.close
