-- path finding
--[[
MIT License

Copyright (c) 2022 sprvrn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local path = (...):gsub("pathfinding", "")

local PriorityQueue = require(path .. "priority_queue")

local function contains(table, element)
	for _, value in pairs(table) do
		if value == element then
 			return true
		end
	end
	return false
end
local function index_of(tab, val)
	local index = nil
	for i, v in ipairs (tab) do 
		if (v == val) then
			index = i 
		end
	end
	return index
end

local constructPath = function(startNode, goalNode, cameFrom)
	local finalPath = {}
	if cameFrom[goalNode] then
		local path = {}
		local current = goalNode

		local addStep = function(cur)
			table.insert(path,
				{
					node = cur,
					cost = cameFrom[cur].cost or 0,
					costSoFar = cameFrom[cur].costSoFar or 0
				})
		end

		while current ~= startNode do
			addStep(current)
			current = cameFrom[current].node
		end
		addStep(startNode)

		-- TODO better than this to reverse the table
		for i=#path,1,-1 do
			path[i].step = #path - (i - 1)
			table.insert(finalPath,path[i])
		end
	end

	return finalPath
end

local Pathfinder = function(mode, startNode, goalNode, getNeighborNodes, getCost, heuristic)
	assert(type(startNode) == "table", "startNode must be a table")
	assert(type(goalNode) == "table" or type(goalNode) == "function", "goalNode must be a table or a function")
	assert(type(getNeighborNodes) == "function", "getNeighborNodes must be a function")

	getCost = getCost or function() return 1 end
	heuristic = heuristic or function () return 0 end

	local frontier = PriorityQueue()
	local cameFrom = {}
	local costSofar = {}

	frontier:put(startNode, 0)
	cameFrom[startNode] = {node = nil, cost = 0, costSoFar = 0}
	costSofar[startNode] = 0

	local search = {
		-- A star
		one = function()
			while frontier:size() > 0 do
				local current = frontier:pop()

				if current == goalNode then
					break
				end

				local neighbors = getNeighborNodes(current)

				for i=1,#neighbors do
					local next = neighbors[i]

					if next then
						local thisCost = getCost(current, next)

						assert(type(thisCost) == "number", "getCost function must always return a number value")

						local newCost = costSofar[current] + thisCost

						if not costSofar[next] or newCost < costSofar[next] then
							local distance = heuristic(goalNode, next)

							assert(type(distance) == "number", "heuristic function must always return a number value")

							costSofar[next] = newCost + distance
							frontier:put(next, newCost)

							cameFrom[next] = {
								node = current,
								cost = thisCost,
								costSoFar = thisCost + cameFrom[current].costSoFar
							}
						end
					end
				end
			end

			return constructPath(startNode, goalNode, cameFrom)
		end,
		-- dijkstra
		many = function()
			local paths = {}
			local step = 1

			while frontier:size() > 0 do
				local current = frontier:pop()

				if type(goalNode) == "table" and contains(goalNode, current) then
					table.insert(paths, constructPath(startNode, current, cameFrom))

					table.remove(goalNode, index_of(goalNode, current))

					if #goalNode == 0 then
						break
					end
				end

				if type(goalNode) == "function" then
					if goalNode(current, cameFrom[current]) then
						table.insert(paths, constructPath(startNode, current, cameFrom))
					end
				end

				local neighbors = getNeighborNodes(current)

				for i=1,#neighbors do
					local next = neighbors[i]

					if next then
						local thisCost = getCost(current, next)

						assert(type(thisCost) == "number", "getCost function must always return a number value")

						local newCost = costSofar[current] + thisCost

						if not costSofar[next] or newCost < costSofar[next] then
							costSofar[next] = newCost

							frontier:put(next, newCost)
							cameFrom[next] = {
								node = current,
								cost = thisCost,
								costSoFar = thisCost + cameFrom[current].costSoFar
							}
						end
					end
				end

				step = step + 1
			end

			return paths
		end
	}

	return search[mode]()
end

return Pathfinder
