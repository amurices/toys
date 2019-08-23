import Prelude

strange_reverse x = zip x (reverse x)

main = putStrLn (strange_reverse ['a','b','c','d','e','f','g'])
