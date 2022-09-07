# astar-lua

Dependency : [priority_queue](https://gist.github.com/LukeMS/89dc587abd786f92d60886f4977b1953) (or any priority queue class with push, pop and size method)

```lua
path = finder(mode, startNode, goalNode, getNeighborNodes, getCost, heuristic)
```
### Arguments
- **(string)** mode ("one" or "many")
- **(table)** startNode : the starting node
- **(table)** goalNode : the goal node (if mode = "one" this argument is a node, if mode = "many" it's a list of nodes)
- **(function)** getNeighborNodes : a function that take a node as argument and return a **(table)** that contains the adjacent nodes. Don't include **nil** in this table.
```lua
function getAdj(node)
  return {...}
end
```
- *optional* **(function)** getCost : a function that take two adjacent nodes as arguments and return the moving cost **(number)** between those two nodes. If this function is not provided the cost is always == 1.
```lua
function getCost(node1, node2)
  return node1.cost
end
```
- *optional* **(function)** heuristic : a function that take two nodes as arguments and return the estimated distance **(number)** between those two nodes. If this function is not provided the distance is always == 0.
```lua
function heuristic(node1, node2)
  return 0
end
```
### Returns
(table) path : a list of table that contains the path data from startNode to goalNode. If the path doesn't exists the table is empty.
```lua
{
  {
    step = 1, -- 
    cost = 1,
    costSoFar = 1,
    node = (table)
  },
  ...
}
```
Note: if mode is "many", the function returns a list of paths.
