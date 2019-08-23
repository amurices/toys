import System.Random
import Control.Monad
import Data.Functor

gauss :: Float -> IO Float
gauss stdev = do
  x1 <- randomIO
  x2 <- randomIO
  return $ stdev * sqrt (-2 * log x1) * cos (2 * pi * x2)

foldl' f z []     = z
foldl' f z (x:xs) = let z' = z `f` x
                    in seq z' $ foldl' f z' xs

sigmoid :: Float -> Float
sigmoid x = 1 / (1 + (exp 1) ** (-x))

sigmoid' :: Float -> Float
sigmoid' x = (exp 1) ** x / ((1 + (exp 1) ** (x)) ** 2)

-- Given a list, gives out a list of lists of length *each element of the list*
makeBiases :: [Int] -> Float -> [[Float]]
makeBiases x b = flip replicate b <$> x

-- Given a list, gives out, for each element X in the list, a list of length x + 1, of
-- x elements in any normal distribution
makeWeights :: [Int] -> Float -> [[[Float]]]
makeWeights xl@(_:xs) el = zipWith (\m n -> replicate n (replicate m el)) xl xs

-- Make initial biases and weights to give a list of tuples that corresponds to biases
-- and weights associated with each node in each layer
makeBrain :: [Int] -> Float -> Float -> [([Float], [[Float]])]
makeBrain (x:xs) b el = zip (makeBiases xs b)  (makeWeights (x:xs) el)

-- Given output of a layer, apply weights and sum for all nodes in a layer. For each list
-- of weights (each node has multiple inputs), there will be one output
sumWeightsL l wvs = sum . zipWith (*) l <$> wvs

-- Given output of a layer, apply weights to get tentative output of each node. Then
-- sum biases of each node to its output
computeLayer :: [Float] -> ([Float], [[Float]]) -> [Float]
computeLayer l (bs, wvs) = zipWith (+) bs (sumWeightsL l wvs)

-- xv: vector of inputs
-- Returns a list of (weighted inputs, activations) of each layer,
-- from last layer to first.
intermediateRes :: [Float] -> [([Float], [[Float]])] -> ([[Float]], [[Float]])
intermediateRes inp = foldl' ( \(avs@(av:_), zs) (bs, wms) ->
  let zs' = computeLayer av (bs, wms) in (((sigmoid <$> zs'):avs), (zs':zs)) ) ([inp], [])

-- xv: vector of inputs
-- yv: vector of desired outputs
-- Returns list of (activations, deltas) of each layer in order.
deltas :: [Float] -> [Float] -> [([Float], [[Float]])] -> ([[Float]], [[Float]])
deltas xv yv layers = let
  (avs@(av:_), zv:zvs)  = intermediateRes xv layers
  delta0                = zipWith (*) (zipWith dCost av yv) (relu' <$> zv)
  in (reverse avs, f (transpose . snd <$> reverse layers) zvs [delta0]) where
    f _ [] dvs = dvs
    f (wm:wms) (zv:zvs) dvs@(dv:_) = f wms zvs $ (:dvs) $
      zipWith (*) [(sum $ zipWith (*) row dv) | row <- wm] (relu' <$> zv)

feed :: [Float] -> [([Float], [[Float]])] -> [Float]
feed inp brain = foldl' (\x y -> sigmoid <$> (computeLayer x y)) inp brain

-- Evaluates cost of feeding *one* input 'inp', comparing the output of that to
-- it to the expected output 'a'
cost :: [([Float], [[Float]])] -> [Float] -> [Float] -> Float
cost brain inp a = sqrt $ sum $ fmap (**2) $ zipWith (-) a (feed inp brain)

-- The derivative of cost is what we use in SGD.
-- cost' :: [([Float], [[Float]])] -> [Float] -> [Float] -> Float


main = do
  putStrLn "3 inputs, a hidden layer of 4 neurons, and 2 output neurons:"
  print $ feed [0.1, 0.2, 0.3] (makeBrain [3,4,2] 0 0.22)

-- Stanford newBrain version
--newBrain :: [Int] -> IO [([Float], [[Float]])]
--newBrain szs@(_:ts) = zip (makeBiases ts 2) <$>
--  zipWithM (\m n -> replicateM n (replicateM m (gauss 0.01))) szs ts

--feed :: [Float] -> [([Float], [[Float]])] -> [Float]
--feed = ((sigmoid <$>) . ) . computeLayer

--main = do
--  putStrLn "3 inputs, a hidden layer of 4 neurons, and 2 output neurons:"
--  myBrain <- newBrain[3, 4, 2]
--  print $ makeBrain [3,4,2] 0 2
