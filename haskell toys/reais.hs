-- :: Funções de parsing - A que token cada valor individual corresponde num agrupamento
-- de dígitos individuais ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Determina a unidade do número
det_unit :: Int -> String
det_unit n
  | n == 0 = ""
  | n == 1 = "um"
  | n == 2 = "dois"
  | n == 3 = "tres"
  | n == 4 = "quatro"
  | n == 5 = "cinco"
  | n == 6 = "seis"
  | n == 7 = "sete"
  | n == 8 = "oito"
  | n == 9 = "nove"

-- Determina se há uma unidade de dezenas ou não no número
det_dozen :: Int -> String
det_dozen n
  | n `div` 10 == 0 = ""
  | n `div` 10 == 1 = "dez"
  | n `div` 10 == 2 = "vinte"
  | n `div` 10 == 3 = "trinta"
  | n `div` 10 == 4 = "quarenta"
  | n `div` 10 == 5 = "cinquenta"
  | n `div` 10 == 6 = "sessenta"
  | n `div` 10 == 7 = "setenta"
  | n `div` 10 == 8 = "oitenta"
  | n `div` 10 == 9 = "noventa"

-- Retorna o nome do número que a string de entrada forma, se concatenada a um "dez e 'string'"
parse_dozen :: String -> String
parse_dozen string
  | string == "um"     = "onze"
  | string == "dois"   = "doze"
  | string == "tres"   = "treze"
  | string == "quatro" = "catorze"
  | string == "cinco"  = "quinze"
  | string == "seis"   = "dezesseis"
  | string == "sete"   = "dezessete"
  | string == "oito"   = "dezoito"
  | string == "nove"   = "dezenove"


-- Determina se há uma unidade de centenas ou não no número
det_hundred :: Int -> String
det_hundred n
  | n `div` 100 == 0 = ""
  | n `div` 100 == 1 = "cem"
  | n `div` 100 == 2 = "duzentos"
  | n `div` 100 == 3 = "trezentos"
  | n `div` 100 == 4 = "quatrocentos"
  | n `div` 100 == 5 = "quinhentos"
  | n `div` 100 == 6 = "seiscentos"
  | n `div` 100 == 7 = "setecentos"
  | n `div` 100 == 8 = "oitocentos"
  | n `div` 100 == 9 = "novecentos"


-- :: Funções de processamento - Determinação de como agrupar strings correspondentes aos
-- :: números, e como exibi-las ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- Descreve um número de três dígitos, devolvendo centenas, dezenas e unidades numa lista
det_3 :: Int -> [String]
det_3 n = [(det_hundred n), (det_dozen (n `mod` 100)), (det_unit (n `mod` 10))]

-- Descreve um número de potência de 10 arbitrária, devolvendo agrupamentos de 3 (listas de listas de tamanho 3)
det_tens :: Int -> Int -> [[String]]
det_tens n (-1) = []
det_tens n pot = (det_3 ((n `div` (10^(pot*3))) `mod` 1000)):(det_tens n (pot-1))

-- Determina a necessidade de se adicionar "e" entre agrupamentos, devolvendo o índice do 'e'
det_e :: [[String]] -> Int -> Int
det_e [] w = w
det_e (["", "", ""]:xs) w = det_e xs (w+1)
det_e ([h, d, u]:xs) w
  | h == ""             = w
  | d == "" && u == ""  = w
  | otherwise           = det_e xs (w+1)

-- Descreve a necessidade de um 'e' ou não entre duas strings (pairwise)
det_connector_pw :: String -> String -> String
det_connector_pw s1 s2
  | s1 == ""  = s2
  | s2 == ""  = s1
  | otherwise = s1 ++ " e " ++ s2

-- Descreve a necessidade de um 'e' ou não entre uma lista de strings
det_connector :: [String] -> String
det_connector xs = foldl det_connector_pw [] xs

-- Retorna a magnitude de potências de 10^3 em forma de string
pot_3_str pot hunds
  | hunds == 0 = ""
  | pot   == 2  = " milhoes"
  | pot   == 1  = " mil"
  | otherwise = ""

-- Retorna a magnitude de potências de 10^3 em forma de inteiro
pot_3_int n
  | n > 999  = 1 + pot_3_int (n `div` 1000)
  | otherwise = 1

-- Mostra a string antes de pós processamento
show_reais :: Int -> Int -> Int -> String
show_reais n (-1) _   = ""
show_reais n pot ind
    | pot == ind  = (det_connector . det_3) hunds ++ pot_3_str pot hunds ++  " e " ++ (show_reais n (pot-1) ind)
    | otherwise   = (det_connector . det_3) hunds ++ pot_3_str pot hunds ++ " " ++ (show_reais n (pot-1) ind)
  where hunds = ((n `div` (10^(pot*3))) `mod` 1000)


-- :: Funções de pós processamento - Independentes da lógica de agrupamentos e localização
-- :: de conectores ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- Faz tarefas melhores adaptadas a pós processamento da lógica de nomeação de números: troca "dez e um" por "onze" por
-- exemplo, além de "cem" por "cento" onde apropriado.
replace :: [String] -> [String]
replace [] = []
replace [x] = [x]
replace [x,y] = [x,y]
replace (x:(xs:(xss@(y:ys))))
    | x == "cem" && xs == "e" = "cento":"e":(replace xss)
    | x == "dez" && xs == "e" = (parse_dozen y):(replace ys)
    | otherwise = x:xs:(replace xss)

-- Checa casos de plural de "um" e remove "um" de "um mil". Nao pode ser recursiva como 'replace'
replace_once :: [String] -> [String]
replace_once [] = []
replace_once [x] = [x]
replace_once inx@(x:(xs:(xss)))
  | x == "um" && xs == "mil"      = (xs:xss)
  | x == "um" && xs == "milhoes"  = (x:("milhao":xss))
  | otherwise                     = inx
-- Exibe uma string correspondendo a um número natural menor que 1.000.000.000 por extenso
call_show n = unwords $ replace_once $ replace $ words $ show_reais n (pot_3_int n - 1) (det_e (reverse (det_tens n (pot_3_int n - 1))) 1)

-- Corta a string de entrada, dividindo na vírgula
split_by del = foldr f [[]]
        where f c l@(x:xs)  | c == del  = []:l
                            | otherwise = (c:x):xs

-- Expressa os dois números (antes e depois da vírgula) em termos de reais e centavos
expresser [r,c]
    | read c > 99                 = "Digite menos de 100 centavos, por favor"
    | read r > 999999999          = "Digite menos de um bilhão de reais, por favor"
    | (read r) `div` (10^6) > 0 && (read r) `mod` (10^6) == 0 = call_show (read r) ++ " de reais e " ++ expresser["0", c] 
    | read c == 1 && read r == 1  = call_show (read r) ++ " real e " ++ call_show (read c) ++ " centavo"
    | read c > 1 && read r == 1   = call_show (read r) ++ " real e " ++ call_show (read c) ++ " centavos"
    | read c == 1 && read r > 1   = call_show (read r) ++ " reais e " ++ call_show (read c) ++ " centavo"
    | read r == 0 && read c > 1   = call_show (read c) ++ " centavos"
    | read r == 0 && read c == 1  = call_show (read c) ++ " centavo"
    | read c == 0 && read r == 1  = call_show (read r) ++ " real"
    | read c == 0 && read r > 1   = call_show (read r) ++ " reais"
    | read c == 0 && read r == 0  = "Nada"
    | otherwise = call_show (read r) ++ " reais e " ++ call_show (read c) ++ " centavos"


-- :: Função main: Emissão de I/O ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
main = do
  str <- getLine
  putStrLn $ expresser (split_by ',' str)
