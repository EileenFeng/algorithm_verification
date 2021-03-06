module Dijkstras

import Graph
import Data.Vect
import Prelude.Basics
import Prelude.List


%default total 

{-
  should the size of `all_nodes` relates to the size of `explored` and `unexplored`? if do, then sort_nodes might have problems as the size of  `targets` is not tightly relates to the size of `all_nodes`
-}

{-
  data structures:
  0. node and weight : use Nat to represent node, and graph is indexed with the Nat of each node
  1. source node
  2. graph : edge value between each adjacent nodes 
  3. distance: distance between each node to source, initially all infinity except source itself
  3. known min value: a set of nodes whose min distance to source is known
  4. 
-}

infinity : Nat
infinity = 999999    

lte_refl : (a : Nat) -> (lte a a = True)
lte_refl Z = Refl
lte_refl (S n) = lte_refl n

lte_succ_refl : (a : Nat) -> (b : Nat) -> 
                (lte (S a) b = True) -> 
                (lte a b = True) 
lte_succ_refl Z Z refl = absurd $ trueNotFalse (sym refl)
lte_succ_refl Z (S b') refl = refl
lte_succ_refl (S _) Z refl = absurd $ trueNotFalse (sym refl)
lte_succ_refl (S a') (S b') refl = lte_succ_refl a' b' refl


-- currently weight type is Nat

-- define sorted graph property : ndoes are strictly in ascneding ordered accorfing to their distance value 
-- prove that adjusting 

insert_node : (len : Nat) -> 
              (elem : Node m) -> 
              (dist : Vect m Nat) -> 
              (nodes : Vect len (Node m)) -> 
              (Vect (S len) (Node m))
insert_node Z e _ Nil = e :: Nil
insert_node (S s') e@(MKNode e_val) dist n@(x@(MKNode x_val) :: xs) 
  = case (gt (index e_val dist) (index x_val dist)) of 
         True => x :: (insert_node s' e dist xs)
         False => e :: n


sort_nodes : (size : Nat) -> 
             (nodes : Vect size (Node m)) -> 
             (dist : Vect m Nat) -> 
             (Vect size (Node m))
sort_nodes Z Nil _ = Nil 
sort_nodes (S size') (x :: xs) dist = insert_node size' x dist $ sort_nodes size' xs dist


{-
the type of 'nodes' will run into problems during recursion

insert_node : (size : Nat) -> 
              (elem : Node (S size)) -> 
              (dist : Vect (S size) Nat) -> 
              (nodes : Vect size (Node (S size))) -> 
              (Vect (S size) (Node (S size)))
insert_node Z e _ Nil = e :: Nil
insert_node (S s') e@(MKNode e_val) dist n@(x@(MKNode x_val) :: xs) 
  = case (gt (index e_val dist) (index x_val dist)) of 
         True => x :: (insert_node s' e (deleteAt x_val dist) xs)
         False => e :: n
             
       
sort_nodes : (size : Nat) -> 
             (nodes : Vect size (Node size)) -> 
             (dist : Vect size Nat) -> 
             (Vect size (Node size))
sort_nodes Z Nil _ = Nil 
sort_nodes (S size') (x :: xs) dist = insert_node size' x dist $ sort_nodes size' (deleteAt x dist)        
-}

-- weird type checking error in idris: 

update_dist : (size : Nat) -> 
              (srcVal : Fin size) -> 
              (adj : NodeSet size Nat) -> 
              (dist : Vect size Nat) -> 
              (Vect size Nat)
update_dist size src (MKSet _ size Nil)s dist = dist
update_dist size src (MKSet _ size ((MKNode n, edge_w) :: xs)) dist 
  = case (Data.Vect.index src dist + edge_w < Data.Vect.index n dist) of 
         True => update_dist size src (MKSet _ size xs) (replaceAt n (Data.Vect.index src dist + edge_w) dist)
         False => update_dist size src (MKSet _ size xs) dist



run_dijkstras : (size : Nat) -> 
                (size' : Nat) -> 
                (weight : Type) -> 
                (graph : Graph size weight) -> 
                (dist : Vect size weight) -> 
                (lte size' size = True) -> 
                (unexplored : Vect size' (Node size)) -> 
                (Vect size weight) 
run_dijkstras _ Z Nat _ dist _ Nil = dist
run_dijkstras s (S s') Nat g@(MKGraph s Nat _ edges) dist refl ((MKNode x) :: xs) 
  = run_dijkstras s s' Nat g (update_dist s x (Data.Vect.index x edges) dist) (lte_succ_refl s' s refl) xs



dijkstras : (size : Nat) -> 
            (source : Node size) -> 
            (weight : Type) -> 
            (graph : Graph size weight) -> 
            (Vect size Nat) 
dijkstras size src Nat g@(MKGraph size Nat nodes edges) = ?d 
  {-run_dijkstras size size g dist (lte_refl size) unexplored
  where 
    dist = map (\x => if (x == src) then 0 else infinity) nodes
    unexplored = sort_nodes size nodes dist-}
    --new_graph = MKGraph size w (sort_nodes size nodes dist) edges
    

weight : Type 
weight = Nat

--graph : Graph 5 Nat


n1 : Node 5
n1 = MKNode FZ

n2 : Node 5
n2 = MKNode 1

n3 : Node 5
n3 = MKNode 2

n4 : Node 5
n4 = MKNode 3

n5 : Node 5
n5 = MKNode 4

n1_set : NodeSet 5 Nat
n1_set = MKSet Nat 5 [(n2, 5), (n3, 1)]


{-
 _____________VERSION 2____________

--insert_node : 

update_graph : (source_dist : Nat) -> 
               (adj_nodes : Nodeset Nat) -> 
               (dist : List (Node, Nat)) -> 
               (List (Node, Nat))
update_graph _ (MKSet _ Nil) dist = dist
update_graph src (MKSet _ ((MKNode n, edge_w) :: xs)) dist 
  = case (src + edge_w) < cur_dist of 
         True => update_graph src (MKSet _ xs) $ 
                              map (\c => if (fst c) == (fst x) 
                                         then (fst c, src + egde_w) 
                                         else c) dist
         False => update_graph src (MKSet _ xs) dist
9  where 
    cur_dist = snd $ index n dist
    
    
   


-- currently assume edge weight is Nat
run_dijkstras : (unexplored : List Node) -> 
                (distMap : List (Node, Nat)) ->
                (g : Graph Nat) -> --adjacent nodes 
                (List (Node, Nat))   
run_dijkstras Nil distMap g = distMap
run_dijkstras (x :: xs) dist g@(MKGraph _ _ nodesets) = ?j --run_dijkstras xs $ sort (update distances



{-
dijkstras : (weight : Type) -> 
            (comparator : (w1 : weight) -> (w2 : weight) -> Bool) ->
            (source : Graph.node) -> 
            (g : graph weight) ->  
            (List (node, weight)) -- distance from source to each node
-}


{-
  input graph: 'nodes' in ascending order, 'nodesets' ordered by ascending order of 'nodes'
-}
dijkstras : (source : Node) -> 
            (g : Graph Nat) ->  
            (List (Node, Nat)) -- distance from source to each node
dijkstras s g@(MKGraph _ adjMatrix) = run_dijkstras nodes distances g
  where 
    distances = map (\x => if (fst x) == s then (x, 0) else (x, infinity)) adjMatrix
-- distances has type: ((Node, Nodeset), dist)
  
{-

-}





_____________VERSION 1______________
{-
run_dijkstras : (weight : Type) -> 
                (comparator : (w1 : weight) -> (w2 : weight) -> Bool) ->
                (explored : List Graph.node) -> 
                (unexplored : List Graph.node) -> 
                (distance : List (Graph.node, weight)) ->
                (g : graph weight) -> --adjacent nodes 
                (List (Graph.node, weight))
-}

run_dijkstras : (explored : List Graph.node) -> 
                (unexplored : List Graph.node) -> 
                (distance : List (Graph.node, Nat)) ->
                (g : graph Nat) -> --adjacent nodes 
                (List (Graph.node, Nat))   
run_dijkstras exp Nil distance g = distance
run_dijkstras exp (x :: xs) distance g = ?h


{-
dijkstras : (weight : Type) -> 
            (comparator : (w1 : weight) -> (w2 : weight) -> Bool) ->
            (source : Graph.node) -> 
            (g : graph weight) ->  
            (List (node, weight)) -- distance from source to each node
-}

dijkstras : (source : Graph.node) -> 
            (g : graph Nat) ->  
            (List (Graph.node, Nat)) -- distance from source to each node
dijkstras s g = run_dijkstras Nil unexp distances g
  where 
    unexp = map Prelude.Basics.fst g
    distances = map (\x => if (Prelude.Basics.fst x == s) then (Prelude.Basics.fst x, 0) else (Prelude.Basics.fst x, infinity)) g


sort_nodes : (weight : Type) -> 
             (comparator : (w1 : weight) -> (w2 : weight) -> Bool) ->
             (targets : List Nat) -> 
             (g : graph weight) -> 
             (List Nat) -- sorted list of node index 
-}
{-
  1. sort unexplored ascending 
  2. get the first inlist
  3. updated 
-}
  
                 


