w = d3.select("svg").style("width").replace("px", "")
h = d3.select("svg").style("height").replace("px", "") - 2
svg = d3.select("svg")

data_path = "../data/structure.json"

d3.json data_path, (error, root) ->
  treemap = d3.layout.treemap().size([w, h])

  boxStyle =
    x: (d) ->
      d.x
    y: (d) ->
      d.y
    width: (d) ->
      d.dx
    height: (d) ->
      d.dy

  retSize = (d) ->
    d.s

  boxGroup = svg.selectAll("g").data(treemap.value(retSize).nodes(root)).enter().append("g")

  box =
    boxGroup.filter (d) ->
        d.l
      .append("rect")
        .attr
          fill: (d, i) ->
            if d.l
              "hsl(#{Math.max(200 - d.l*20, 0)}, 100%, 70%)"
            else
              "none"
          "stroke": "#000000"
          "stroke-opacity": 0.2
        .attr(boxStyle)

  label = $("#info")
  parents = svg.append("g")

  boxGroup
    .on 'mouseover', (d) ->
      d3.select(this).attr(opacity: 0)

      node = d
      fullpath = node.n
      h = 1
      while node.parent
        node = node.parent
        fullpath = node.n + "/" + fullpath unless node.depth == 0

        parents.append("rect")
          .attr
            "stroke": "#ff0000"
            "stroke-width": 3
            "stroke-opacity": 1.0 / h
            "fill": "none"
            x: node.x
            y: node.y
            width: node.dx
            height: node.dy

        parents.append("text")
          .attr
            x: node.x + 2
            y: node.y + 2
            "dominant-baseline": "text-before-edge"
          .text(node.n)
        h += 1
      fullpath = "/" + fullpath

      label.css
        left: if w - 300 - 40 > d.x then d.x + 30 else d.x - 330
        top: d.y
      .append("<p>#{fullpath}</p>")
      .append("<p>count: #{d.l}</p>")
      .append("<p>size: #{d.s}</p>")

    .on 'mouseout', (d) ->
      d3.select(this).attr(opacity: 1)
      parents.selectAll("*").remove()
      label.empty()
