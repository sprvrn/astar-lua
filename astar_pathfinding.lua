-- A* path finding
-- by sprvrn
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

local PriorityQueue = require "priority_queue"

local Pathfinder = function(startNode, goalNode, getNeighborNodes, getCost, heuristic)
	assert(type(startNode) == "table", "startNode must be a table")
	assert(type(goalNode) == "table", "goalNode must be a table")
	assert(type(getNeighborNodes) == "function", "getNeighborNodes must be a function")

	getCost = getCost or function() return 0 end
	heuristic = heuristic or function () return 0 end

	local frontier = PriorityQueue()
	local cameFrom = {}
	local costSofar = {}

	frontier:put(startNode, 0)
	cameFrom[startNode] = {node = nil, cost = 0, costSoFar = 0}
	costSofar[startNode] = 0

	while frontier:size() > 0 do
		local current = frontier:pop()

		if current == goalNode then
			break
		end

		for _,next in ipairs(getNeighborNodes(current)) do
			if next then
				local thisCost = getCost(current, next)

				assert(type(thisCost) == "number","getCost function must always return a number value")

				local newCost = costSofar[current] + thisCost

				if not costSofar[next] or newCost < costSofar[next] then
					local distance = heuristic(goalNode, next)

					assert(type(distance) == "number","heuristic function must always return a number value")

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

		for i=#path,1,-1 do
			path[i].step = #path - (i - 1)
			table.insert(finalPath,path[i])
		end
	end

	return finalPath
end

return Pathfinder