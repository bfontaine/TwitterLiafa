#! /usr/bin/ruby1.9.1

require '../../../../Programmation/Github/Graph.rb/gdf'

lines = []

nums = (1..124).to_a

nodes = nums.map {|n| GDF::load("../../graphs/Gf/#{n.to_s.rjust(3, '0')}_gf.gdf").nodes }

nums.each {|n|

    g_n = nodes[n-1]

    col = []
    nums.each {|m|
        
        if (n === m)
            col << -1
            next
        end

        col << (g_n & nodes[m-1]).size
    }

    lines << col

}

lines.sort!

f = File.open('intersections_entre_2_graphes-js.html', 'w')
    f.write("<html><head><meta charset=\"utf-8\"/><script>\nvar tab=")
    f.write(lines.inspect)
    f.write(";</script></head><body></body></html>")
f.close

f = File.open('intersections_entre_2_graphes.html', 'w')

f.write("<html><head><meta charset=\"utf-8\"/><style>\n")
f.write("td{background-color:blue;margin:0;border:none;width:5px;height:5px;padding:none}")
f.write(".no{background-color:white}")
f.write("table,tr{border:none;padding:none}")

(0..20).each {|n|
    f.write(".o#{n} {opacity:#{n.to_f/20}}")
}
f.write("</style></head>\n<body><table border=\"1\">\n")

nums.each {|i|
    f.write('<tr>')

    nums.each {|j|
    
        t = lines[i-1][j-1]
        v = [t.to_f/20, 1].min

        f.write("<td title=\"#{i}x#{j}\" class=\"o#{(v*20).to_i}\"></td>")
    
    }

    f.write("</tr>\n")
}

f.write("</table></html>")
f.close
