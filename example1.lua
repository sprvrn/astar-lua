-- Example with a grid

local finder = require "astar_pathfinding"

-- the map data
-- -1 : wall

local data = {
	{-1,-1,-1,-1,-1,-1,-1,-1,-1},
	{-1, 1,20, 1,50, 1, 1, 1,-1},
	{-1, 1,20,20,-1,-1,-1,20,-1},
	{-1, 1,50, 1, 1, 1,-1, 1,-1},
	{-1, 1, 1, 1,50,50,-1, 1,-1},
	{-1, 1, 1, 1, 1,50,30, 1,-1},
	{-1,50,-1,-1,-1,-1,-1, 1,-1},
	{-1,50,50, 1, 1, 1, 1, 1,-1},
	{-1,-1,-1,-1,-1,-1,-1,-1,-1},
}

-- building the grid
-- each node will be accessible with map[y][x]
local map = {}
for y=1,#data do
	map[y] = {}
	for x=1,#data[y] do
		local w = true
		if data[y][x] == -1 then
			w = false
		end
		local cost = data[y][x]
		map[y][x] = {x=x, y=y, walkable = w, cost = cost}
	end
end

-- returns all the adjacent walkable nodes from a node
local getAdj = function(node)
    local nodes = {}
	local getNode = function(x, y)
		if y >= 1 and y <= #map and x >= 1 and x <= #map[y] then
			if map[y][x].walkable then
				table.insert(nodes, map[y][x])
			end
		end
	end

	getNode(node.x - 1, node.y),
	getNode(node.x + 1, node.y),
	getNode(node.x, node.y - 1),
	getNode(node.x, node.y + 1),

	--diagonal search
	--getNode(node.x - 1, node.y - 1),
	--getNode(node.x + 1, node.y - 1),
	--getNode(node.x - 1, node.y + 1),
	--getNode(node.x + 1, node.y + 1)

    return nodes
end

-- returns the moving cost
local getCost = function(node1, node2)
	return node2.cost
end

-- returns the manhattan distance between two nodes
local heuristic = function(node1, node2)
	return math.abs(node1.x - node2.x) + math.abs(node1.y - node2.y)
end

-- seach the shortest path from 2:2 to 8:8
local path = finder(map[2][2], map[8][8], getAdj, getCost, heuristic)

for i=1,#path do
	print(
		string.format("step %d, (%d:%d) distance so far : %d",
			path[i].step, path[i].node.x, path[i].node.y, path[i].costSoFar))
end

--[[
output : 
step 1, (2:2) distance so far : 0
step 2, (2:3) distance so far : 1
step 3, (2:4) distance so far : 2
step 4, (2:5) distance so far : 3
step 5, (3:5) distance so far : 4
step 6, (3:6) distance so far : 5
step 7, (4:6) distance so far : 6
step 8, (5:6) distance so far : 7
step 9, (6:6) distance so far : 57
step 10, (7:6) distance so far : 87
step 11, (8:6) distance so far : 88
step 12, (8:7) distance so far : 89
step 13, (8:8) distance so far : 90
]]
