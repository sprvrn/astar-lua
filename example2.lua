-- Example with a graph

local finder = require "astar_pathfinding"

local graph = {
		a = {
			id = "a",
			position = {60, 60},
			neighbors = {
				b = 56, d = 194, a1 = 67
			},
		},
		a1 = {
			id = "a1",
			position = {120, 30},
			neighbors = {
				a = 67, a2 = 150
			},
		},
		a2 = {
			id = "a2",
			position = {270, 25},
			neighbors = {
				a1 = 150, e = 91
			},
		},
		b = {
			id = "b",
			position = {250, 100},
			neighbors = {
				a = 194, e = 104
			},
		},
		c = {
			id = "c",
			position = {60, 150},
			neighbors = {
				d = 64
			},
		},
		d = {
			id = "d",
			position = {100, 100},
			neighbors = {
				g = 212, f = 219
			},
		},
		e = {
			id = "e",
			position = {350, 70},
			neighbors = {
				b = 104, f = 130, h = 174, i = 246, a2 = 91
			},
		},
		f = {
			id = "f",
			position = {300, 190},
			neighbors = {
				d = 219, g = 78, e = 130, j = 42
			},
		},
		g = {
			id = "g",
			position = {250, 250},
			neighbors = {
				d = 212, f = 78, h = 140, i = 196
			},
		},
		h = {
			id = "h",
			position = {390, 240},
			neighbors = {
				e = 174, g = 140, i = 61, j = 78
			},
		},
		i = {
			id = "i",
			position = {440, 300},
			neighbors = {
				h = 78, g = 196, e = 246
			},
		},
		j = {
			id = "j",
			position = {340, 205},
			neighbors = {
				f = 42, h = 61
			},
		},
	}

-- return the adjacent nodes
local getAdj = function(node)
	local neighbors = {}
	for key,_ in pairs(node.neighbors) do
		table.insert(neighbors, graph[key])
	end
	return neighbors
end

-- return the cost (distance) between 2 nodes
local getCost = function(node1, node2)
	return node1.neighbors[node2.id]
end

-- get the shortest path from node A to node I
local path = finder(graph.a, graph.i, getAdj, getCost)

for i=1,#path do
	print(
		string.format("step %d, node %s, distance so far : %s",
			path[i].step, path[i].node.id, path[i].costSoFar))

end

--[[
output : 
step 1, node a, distance so far : 0
step 2, node b, distance so far : 56
step 3, node e, distance so far : 160
step 4, node h, distance so far : 334
step 5, node i, distance so far : 395
]]