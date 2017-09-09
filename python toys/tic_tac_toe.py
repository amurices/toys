board = [['-','-','-'],['-','-','-'],['-','-','-']]

def print_board(board):
    for row in board:
        print(row[0], end='')
        print(row[1], end='')
        print(row[2], end='')
        print()

def check_game_win(board):
    for row in board:           # Horizontal win check
        if row[0] == row[1] and row[1] == row[2] and row[0] != '-':
            return True

    for i in range(len(board)): # Vertical win check
        if board[0][i] == board[1][i] and board[1][i] == board[2][i] and board[0][i] != '-':
            return True

    # Diagonal win checks
    if board[0][0] == board [1][1] and board[1][1] == board[2][2] and board[0][0] != '-':
        return True
    if board[0][2] == board [1][1] and board[1][1] == board[2][0] and board[0][2] != '-':
        return True


gameEnd = False
circle = False

print_board(board)

while gameEnd == False:
    if check_game_win(board):
        if circle == True:
            print ("The moron with the X wins")
            break
        else:
            print ("The cocksucker with the O wins")
            break
    print ("Make a play (type in horizontal/vertical coordinates of your play)")
    play = input()
    if board[int(play[0])][int(play[2])] == '-':
        if circle:
            board[int(play[0])][int(play[2])] = 'O'
        else:
            board[int(play[0])][int(play[2])] = 'X'
        circle = not circle
    else:
        print ("Lol you can't play there. You fucking moron")
    print_board(board)
