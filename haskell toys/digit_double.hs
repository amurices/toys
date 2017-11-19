-- Given a list of Ints representing a larger number, return a list doubling it
aux :: [Int] -> Int -> [Int]
aux [] c
  | c == 1 = [1]
  | c == 0 = []
aux (n:ns) c = ((n*2+c) `mod` 10):(aux ns (n*2 `div` 10))

doubleList :: [Int] -> [Int]
doubleList x = reverse (aux (reverse x) 0)

doubleListN :: [Int] -> Int -> [Int]
doubleListN x 0 = x
doubleListN x n = doubleListN (doubleList x) (n-1)

getDoubles :: Int -> [[Int]]
getDoubles n = map (\x -> doubleListN [1] x) [1..n]

countDigitN g n = length $ filter (\(x:_) -> x==n) (getDoubles g)
