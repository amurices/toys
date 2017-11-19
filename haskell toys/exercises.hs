-- P1: Last element of a list
last' :: [a] -> a
last' [x] = x
last' (x:xs) = last' xs

-- P2: penultimate
last'' :: [a] -> a
last'' [x,y] = x
last'' (x:xs) = last'' xs

-- P3: k-th
elementAt :: [a] -> Int -> a
elementAt (x:xs) 0 = x
elementAt (x:xs) n = elementAt xs (n-1)

-- P4: Num elements
myLengthAux :: [a] -> Int -> Int
myLengthAux [] n = n
myLengthAux (x:xs) n = myLengthAux xs (n+1)
myLengthAux :: [a] -> Int
myLength x = myLengthAux x 0
